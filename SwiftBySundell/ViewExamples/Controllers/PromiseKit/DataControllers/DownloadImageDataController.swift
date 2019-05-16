//
//  DownloadImageDataController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 20/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import PromiseKit

protocol DownloadImageDataControllerDelegate: class {
    func complete(dataController: DownloadImageDataController, image: UIImage?)
}

final class DownloadImageDataController {
    weak var delegate: DownloadImageDataControllerDelegate?

    let request: HTTPRequest

    init() {
        let endPoint = DefaultEndPoint(configurator: BigImageDownloadConfigurator.getBitImage(id: 2000, filename: "1*d6l1Gt7j47JyxONXn8moYg.png"))
        self.request = try! HTTPRequest(endPoint: endPoint, requestBahaviors: [LoggerBehavior()], name: nil)
    }

    func getImage() {
        if request.status == .request {
            request.cancel()
            return
        }
        request.perform { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.delegate?.complete(dataController: self, image: UIImage(data: data.body))
            case .failure:
                self.delegate?.complete(dataController: self, image: nil)
            }
        }
    }

    func cancel() {
        self.request.cancel()
    }
}
