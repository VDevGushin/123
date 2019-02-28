//
//  RealAlamofireDataController+Upload.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import Alamofire
/*When sending relatively small amounts of data to a server using JSON or URL encoded parameters, the Alamofire.request APIs are usually sufficient. If you need to send much larger amounts of data from a file URL or an InputStream, then the Alamofire.upload APIs are what you want to use.
 
 The Alamofire.upload APIs should also be used if you need to upload data while your app is in the background. For more information, please see the Session Manager Configurations section.*/

extension RealAlamofireDataController {
    //Uploading Data
    func uploadData(image: UIImage) {
        let imageData = image.pngData()!
        AF.upload(imageData, to: "https://httpbin.org/post").validate()
            .uploadProgress { progress in // main queue by default
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            .downloadProgress { progress in // main queue by default
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .response { response in
                debugPrint(response)
        }
    }

    //Uploading a File
    func uploadFile() {
        let fileURL = Bundle.main.url(forResource: "video", withExtension: "mov")
        AF.upload(fileURL!, to: "https://httpbin.org/post")
            .uploadProgress { progress in // main queue by default
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            .downloadProgress { progress in // main queue by default
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseJSON { response in
                debugPrint(response)
        }
    }

    //Uploading Multipart Form Data
    func uploadMultipartFormData() {
//        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(unicornImageURL, withName: "unicorn")
//            multipartFormData.append(rainbowImageURL, withName: "rainbow")
//
//        }, to: "https://httpbin.org/post", encodingCompletion: { encodingResult in
//            switch encodingResult {
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    debugPrint(response)
//                }
//            case .failure(let encodingError):
//                print(encodingError)
//            }
//        })
    }
}

