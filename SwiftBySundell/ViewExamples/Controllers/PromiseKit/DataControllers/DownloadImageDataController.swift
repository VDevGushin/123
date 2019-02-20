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
        return firstly {
            after(seconds: 5)
        }.then {
            URLSession.shared.dataTask(.promise, with: self.imageUrl)
        }.compactMap(on: .main) {
            UIImage(data: $0.data)
        }
    }
}
