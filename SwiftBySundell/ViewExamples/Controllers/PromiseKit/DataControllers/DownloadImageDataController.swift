//
//  DownloadImageDataController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 20/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import PromiseKit

final class DownloadImageDataController: RequestDataController {
    var requestBahavior: WebRequestBehavior
    var endPoint: EndPoint

    init() {
        self.requestBahavior = CombinedWebRequestBehavior(behaviors: [LoggerBehavior()])
        self.endPoint = DefaultEndPoint(configurator: BigImageDownloadConfigurator.getBitImage(id: 2000, filename: "1*d6l1Gt7j47JyxONXn8moYg.png"))
    }

    func downloadImage() -> Promise<UIImage> {
        let request = self.endPoint.urlRequest()
        self.requestBahavior.beforeSend(with: request)
        let fetchImage = URLSession.shared.dataTask(.promise, with: request).compactMap { UIImage(data: $0.data) }
        return firstly {
            after(seconds: 5)
        }.then {
            fetchImage
        }
    }


    func downloadImageWithCancel() -> (Promise<UIImage>, cancel: () -> Void) {
        let fetchImage = self.downloadImage()
        var cancelMe = false

        let promise = Promise<UIImage> { resolver in
            fetchImage.done { newImage in
                guard !cancelMe else {
                    self.requestBahavior.afterFailure(error: PMKError.cancelled, response: nil)
                    return resolver.reject(PMKError.cancelled)
                }
                self.requestBahavior.afterSuccess(result: newImage, response: nil)
                resolver.fulfill(newImage)
            }.catch { error in
                self.requestBahavior.afterFailure(error: error, response: nil)
                resolver.reject(error)
            }
        }

        let cancel = {
            cancelMe = true
        }

        return (promise, cancel)
    }
}

extension DownloadImageDataController {
    static func fetchImage() -> Promise<UIImage> {
        let controller = DownloadImageDataController()
        return controller.downloadImage()
    }

    static func fetchImageWithCancel() -> (promise: Promise<UIImage>, cancel: () -> Void) {
        let controller = DownloadImageDataController()
        return controller.downloadImageWithCancel()
    }
}
