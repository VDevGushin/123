//
//  DownloadImageDataController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 20/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import PromiseKit

final class DownloadImageDataController {
    let imageUrl = URL(string: "https://cdn-images-1.medium.com/max/2000/1*d6l1Gt7j47JyxONXn8moYg.png")!

    func downloadImage() -> Promise<UIImage> {
        let fetchImage = URLSession.shared.dataTask(.promise, with: self.imageUrl).compactMap { UIImage(data: $0.data) }
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
                    return resolver.reject(PMKError.cancelled)
                }
                resolver.fulfill(newImage)
            }.catch { error in
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
