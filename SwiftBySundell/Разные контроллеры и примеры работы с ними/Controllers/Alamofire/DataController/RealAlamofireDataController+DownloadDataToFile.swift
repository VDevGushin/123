//
//  RealAlamofireDataController+DownloadDataToFile.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

extension RealAlamofireDataController {
    // MARK: - Downloading Data to a File
    /*The Alamofire.download APIs should also be used if you need to download data while your app is in the background. For more information, please see the Session Manager Configurations section.*/
    func imageDownload(on queue: DispatchQueue = .global(qos: .background)) -> Promise<UIImage> {
        return Promise { resolver in
            queue.async {
                AF.download("https://httpbin.org/image/png").validate()
                    .downloadProgress(queue: queue) { progress in
                        print(progress.fractionCompleted)
                    }.responseData { response in
                        switch response.result {
                        case .failure(let error):
                            resolver.reject(error)
                        case .success(let data):
                            guard let image = UIImage(data: data) else {
                                return resolver.reject(PMKError.cancelled)
                            }
                            resolver.fulfill(image)
                        }
                }
            }
        }
    }

    // MARK: - Download File Destination
    func downloadFileDestination(on queue: DispatchQueue = .global(qos: .background)) -> Promise<UIImage> {
        /*You can also provide a DownloadFileDestination closure to move the file from the temporary directory to a final destination. Before the temporary file is actually moved to the destinationURL, the DownloadOptions specified in the closure will be executed. The two currently supported DownloadOptions are:
         
         .createIntermediateDirectories - Creates intermediate directories for the destination URL if specified.
         .removePreviousFile - Removes a previous file from the destination URL if specified.*/
        return Promise { resolver in
            queue.async {
                //custom
                let _: DownloadRequest.Destination = { _, _ in
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    debugPrint(documentsURL)
                    let fileURL = documentsURL.appendingPathComponent("pig.png")
                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }

                //You can also use the suggested download destination API.
                let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, options: [.removePreviousFile, .createIntermediateDirectories])

                AF.download("https://httpbin.org/image/png", to: destination).response { response in
                    switch response.result {
                    case .failure(let error):
                        resolver.reject(error)
                    case .success:
                        guard let imagePath = response.fileURL?.path, let image = UIImage(contentsOfFile: imagePath) else {
                            return resolver.reject(PMKError.cancelled)
                        }
                        resolver.fulfill(image)
                    }
                }
            }
        }
    }
}
