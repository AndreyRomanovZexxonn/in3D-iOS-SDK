//
//  Data.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 01.12.2020.
//

import Foundation

extension Data {
  /// Creates a new buffer by copying the buffer pointer of the given array.
  ///
  /// - Warning: The given array's element type `T` must be trivial in that it can be copied bit
  ///     for bit with no indirection or reference-counting operations; otherwise, reinterpreting
  ///     data from the resulting buffer has undefined behavior.
  /// - Parameter array: An array with elements of type `T`.
  init<T>(copyingBufferOf array: [T]) {
    self = array.withUnsafeBufferPointer(Data.init)
  }

  /// Convert a Data instance to Array representation.
  func toArray<T>(type: T.Type) -> [T] where T: AdditiveArithmetic {
    var array = [T](repeating: T.zero, count: self.count / MemoryLayout<T>.stride)
    _ = array.withUnsafeMutableBytes { self.copyBytes(to: $0) }
    return array
  }
}
