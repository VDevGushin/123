//
//  ResumingDownload.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

/*If a DownloadRequest is cancelled or interrupted, the underlying URL session may generate resume data for the active DownloadRequest. If this happens, the resume data can be re-used to restart the DownloadRequest where it left off. The resume data can be accessed through the download response, then reused when trying to restart the request.
 
 IMPORTANT: On some versions of all Apple platforms (iOS 10 - 10.2, macOS 10.12 - 10.12.2, tvOS 10 - 10.1, watchOS 3 - 3.1.1), resumeData is broken on background URL session configurations. There's an underlying bug in the resumeData generation logic where the data is written incorrectly and will always fail to resume the download. For more information about the bug and possible workarounds, please see this Stack Overflow post.*/

final class ImageRequestor {
    private var resumeData: Data?
    private var image: UIImage?

    func fetchImage() -> Promise<UIImage?> {
        guard image == nil else { return Promise { resolver in resolver.fulfill(self.image) } }

        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, options: [.removePreviousFile, .createIntermediateDirectories])

        let request: DownloadRequest

        if let resumeData = resumeData {
            request = AF.download(resumingWith: resumeData, to: destination)
        } else {
            request = AF.download("https://httpbin.org/image/png", to: destination)
        }

        return Promise { resolver in
            request.responseData { response in
                switch response.result {
                case .success(let data):
                    self.image = UIImage(data: data)
                    resolver.fulfill(self.image)
                case .failure(let error):
                    self.resumeData = response.resumeData
                    resolver.reject(error)
                }
            }
        }
    }
}
