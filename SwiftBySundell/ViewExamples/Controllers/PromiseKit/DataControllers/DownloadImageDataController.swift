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

    let request: HTTPRequest?

    init() {
        let endPoint = DefaultEndPoint(configurator: BigImageDownloadConfigurator.getBitImage(id: 2000, filename: "1*d6l1Gt7j47JyxONXn8moYg.png"))

        self.request = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])

        let db = DispatchWorkItem {
            let r1 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
            let r2 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
            let r3 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
            let r4 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
            let r5 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
            let r6 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
            let r7 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])

            r1?.perform { _ in }
            r2?.perform { _ in }
            r3?.perform { _ in }
            r4?.perform { _ in }
            r5?.perform { _ in }
            r6?.perform { _ in }
            r7?.perform { _ in }
        }
        
        db.perform()
    }

    func getImage() {
        guard let request = self.request else { return }
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
        self.request?.cancel()
    }
}
