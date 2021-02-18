//
//  UploadViewModel.swift
//  in3D SDK Example
//
//  Created by Булат Якупов on 19/12/2019.
//

import Foundation
import I3DRecorder
import UIKit
import RxCocoa
import RxSwift

class ScanerUploadViewModel: UploadViewModel {
    
    // MARK: - Public properties
    weak var view: UploadView?
    
    // MARK: - Private properties
    private weak var coordinator: ScannerCoordination?
    private var scanService: ScanService
    private let recording: ScanRecording
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(coordinator: ScannerCoordination,
         scanService: ScanService,
         recording: ScanRecording) {
        self.coordinator = coordinator
        self.scanService = scanService
        self.recording = recording
    }
    
    // MARK: - UploadViewModel
    func ready() {
        scanService.delegate = self
        scanService.upload(recording: recording.id, progress: { (progress, totalSize) in
            self.view?.upload(progress: progress, totalSize: totalSize)
        }, completion: { [unowned self] scan, error in
            guard error == nil else {
                print(error!)
                self.view?.showError()
                return
            }

            self.finish(offset: 0.5)
        })
    }
    
    func finish(offset time: Double) {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + time) { [unowned self] in
            self.coordinator?.showUploadFinish()
        }
    }
    
}

extension ScanerUploadViewModel: ScanServiceDelegate {
    
    func createScan(for recording: ScanRecording, completion: @escaping (String?) -> ()) {
        /// DO NOT DO THIS. THIS IS NOT A PRODUCTION SOLUTION, BUT A DEMONSTRATION.
        /// THIS REQUEST SHOULD BE MADE FROM YOUR SERVER AND THE TOKEN SHOULD ALSO BE STORED ON THE SERVER
        
        let token = "<YOUR_TOKEN>"
        
        if token == "<YOUR_TOKEN>" {
            fatalError()
        }
        
        let header = ["Authorization": "Bearer \(token)"]
        let body = ["callback_url": "", "config_name": "", "vendor_id": ""]
        
        let request: URLRequest
        do {
            request = try URLRequest.createRequest(method: .post,
                                                   url: URL(string: "https://app.gsize.io/v2/scans/init")!,
                                                   parameters: nil,
                                                   header: header,
                                                   body: body,
                                                   encoding: .json)
        } catch {
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                completion(nil)
                return
            }
            
            #if DEBUG
            print(response)
            #endif
            
            guard let data = data else {
                return
            }
            
            if response.statusCode / 200 == 1 {
                do {
                    let result = try JSONDecoder().decode(Scan.self, from: data)
                    completion(result.id)
                    return
                } catch {
                    #if DEBUG
                    print(error)
                    #endif
                    completion(nil)
                }
            } else {
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    #if DEBUG
                    print(result)
                    #endif
                } catch {
                    #if DEBUG
                    print(error)
                    #endif
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
    
}
