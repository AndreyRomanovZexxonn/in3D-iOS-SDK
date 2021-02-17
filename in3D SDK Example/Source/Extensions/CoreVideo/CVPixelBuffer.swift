//
//  CVPixelBuffer.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 13/01/2020.
//

import Accelerate
import CoreVideo
import Foundation

extension CVPixelBuffer {
    var size: CGSize {
        return CGSize(width: CVPixelBufferGetWidth(self), height: CVPixelBufferGetHeight(self))
    }
    
    /// First crops the pixel buffer, then resizes it.
    ///
    /// - Parameters:
    ///   - cropX: x crop coordinate
    ///   - cropY: y crop coordinate
    ///   - cropWidth: crop width
    ///   - cropHeight: crop height
    ///   - scaleWidth: width scale value
    ///   - scaleHeight: height scale value
    func resizePixelBuffer(cropX: Int,
                           cropY: Int,
                           cropWidth: Int,
                           cropHeight: Int,
                           scaleWidth: Int,
                           scaleHeight: Int) -> CVPixelBuffer? {
        let flags = CVPixelBufferLockFlags(rawValue: 0)
        guard kCVReturnSuccess == CVPixelBufferLockBaseAddress(self, flags) else {
            return nil
        }
        defer { CVPixelBufferUnlockBaseAddress(self, flags) }
        
        guard let srcData = CVPixelBufferGetBaseAddress(self) else {
            print("Error: could not get pixel buffer base address")
            return nil
        }
        let srcBytesPerRow = CVPixelBufferGetBytesPerRow(self)
        let offset = cropY*srcBytesPerRow + cropX*4
        var srcBuffer = vImage_Buffer(data: srcData.advanced(by: offset),
                                      height: vImagePixelCount(cropHeight),
                                      width: vImagePixelCount(cropWidth),
                                      rowBytes: srcBytesPerRow)
        
        let destBytesPerRow = scaleWidth*4
        guard let destData = malloc(scaleHeight*destBytesPerRow) else {
            print("Error: out of memory")
            return nil
        }
        var destBuffer = vImage_Buffer(data: destData,
                                       height: vImagePixelCount(scaleHeight),
                                       width: vImagePixelCount(scaleWidth),
                                       rowBytes: destBytesPerRow)
        
        let error = vImageScale_ARGB8888(&srcBuffer, &destBuffer, nil, vImage_Flags(0))
        if error != kvImageNoError {
            print("Error:", error)
            free(destData)
            return nil
        }
        
        let releaseCallback: CVPixelBufferReleaseBytesCallback = { _, ptr in
            if let ptr = ptr {
                free(UnsafeMutableRawPointer(mutating: ptr))
            }
        }
        
        let pixelFormat = CVPixelBufferGetPixelFormatType(self)
        var dstPixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreateWithBytes(nil, scaleWidth, scaleHeight,
                                                  pixelFormat, destData,
                                                  destBytesPerRow, releaseCallback,
                                                  nil, nil, &dstPixelBuffer)
        if status != kCVReturnSuccess {
            print("Error: could not create new pixel buffer")
            free(destData)
            return nil
        }
        return dstPixelBuffer
    }
    
    
    /// Resizes a CVPixelBuffer to a new width and height.
    /// - Parameters:
    ///   - width: target width
    ///   - height: target height
    func resize(width: Int, height: Int) -> CVPixelBuffer? {
        return resizePixelBuffer(cropX: 0,
                                 cropY: 0,
                                 cropWidth: CVPixelBufferGetWidth(self),
                                 cropHeight: CVPixelBufferGetHeight(self),
                                 scaleWidth: width,
                                 scaleHeight: height)
    }
    
    /// Returns the RGB `Data` representation of the given image buffer with the specified
    /// `byteCount`.
    ///
    /// - Parameters:
    ///   - byteCount: The expected byte count for the RGB data calculated using the values that the
    ///       model was trained on: `batchSize * imageWidth * imageHeight * componentsCount`.
    ///   - isModelQuantized: Whether the model is quantized (i.e. fixed point values rather than
    ///       floating point values).
    /// - Returns: The RGB data representation of the image buffer or `nil` if the buffer could not be
    ///     converted.
    func rgbData(
        byteCount: Int,
        isModelQuantized: Bool
    ) -> Data? {
        CVPixelBufferLockBaseAddress(self, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(self, .readOnly) }
        guard let sourceData = CVPixelBufferGetBaseAddress(self) else {
            return nil
        }
        
        let width = CVPixelBufferGetWidth(self)
        let height = CVPixelBufferGetHeight(self)
        let sourceBytesPerRow = CVPixelBufferGetBytesPerRow(self)
        let destinationBytesPerRow = Constants.rgbPixelChannels * width
        
        // Assign input image to `sourceBuffer` to convert it.
        var sourceBuffer = vImage_Buffer(
            data: sourceData,
            height: vImagePixelCount(height),
            width: vImagePixelCount(width),
            rowBytes: sourceBytesPerRow)
        
        // Make `destinationBuffer` and `destinationData` for its data to be assigned.
        guard let destinationData = malloc(height * destinationBytesPerRow) else {
            os_log("Error: out of memory", type: .error)
            return nil
        }
        defer { free(destinationData) }
        var destinationBuffer = vImage_Buffer(
            data: destinationData,
            height: vImagePixelCount(height),
            width: vImagePixelCount(width),
            rowBytes: destinationBytesPerRow)
        
        // Convert image type.
        switch CVPixelBufferGetPixelFormatType(self) {
        case kCVPixelFormatType_32BGRA:
            vImageConvert_BGRA8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
        case kCVPixelFormatType_32ARGB:
            vImageConvert_BGRA8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
        default:
            os_log("The type of this image is not supported.", type: .error)
            return nil
        }
        
        // Make `Data` with converted image.
        let imageByteData = Data(
            bytes: destinationBuffer.data, count: destinationBuffer.rowBytes * height)
        
        if isModelQuantized { return imageByteData }
        
        let imageBytes = [UInt8](imageByteData)
        return Data(copyingBufferOf: imageBytes.map { Float($0) / Constants.maxRGBValue })
    }
    
    func pixelFrom(x: Int, y: Int) -> Float? {
        CVPixelBufferLockBaseAddress(self, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(self, .readOnly) }
        guard let baseAddress = CVPixelBufferGetBaseAddress(self) else {
            return nil
        }

        let width = CVPixelBufferGetWidth(self)
        let buffer = baseAddress.assumingMemoryBound(to: UInt16.self)

        let index = x + y * width
        
        var input: [UInt16] = [buffer[index]]
        var output: [Float] = [0]
        var sourceBuffer = vImage_Buffer(data: &input, height: 1, width: 1, rowBytes: MemoryLayout<UInt16>.size)
        var destinationBuffer = vImage_Buffer(data: &output, height: 1, width: 1, rowBytes: MemoryLayout<Float>.size)
        vImageConvert_Planar16FtoPlanarF(&sourceBuffer, &destinationBuffer, 0)

        return output[0]
    }
    
    
}

// MARK: - Constants
private enum Constants {
    static let bgraPixel = (channels: 4, alphaComponent: 3, lastBgrComponent: 2)
    static let rgbPixelChannels = 3
    static let maxRGBValue: Float32 = 255.0
}

extension Data {
    func elements <T> () -> [T] {
        return withUnsafeBytes {
            Array(UnsafeBufferPointer<T>(start: $0, count: count/MemoryLayout<T>.size))
        }
    }
}
