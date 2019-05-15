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

final class DownloadImageDataController: RequestDataController {
    let client: RequestMaker?
    weak var delegate: DownloadImageDataControllerDelegate?

    var reqest: (promise: Promise<APIResponse<Data>>, cancel: () -> Void)?

    init() {
        let endPoint = DefaultEndPoint(configurator: BigImageDownloadConfigurator.getBitImage(id: 2000, filename: "1*d6l1Gt7j47JyxONXn8moYg.png"))
        self.client = try? RequestMaker(endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
    }

    var isResolved: Bool {
        guard let promise = self.reqest?.promise else {
            return true
        }
        return promise.isResolved
    }

    func getImage() {
        guard let client = self.client else { return }
        self.reqest = client.makeRequestWithCancel()

        self.reqest?.promise.done(on: .main) { [weak self] response in
            guard let self = self else { return }
            self.delegate?.complete(dataController: self, image: UIImage(data: response.body))
        }.catch(on: .main) { [weak self] error in
            guard let self = self else { return }
            self.delegate?.complete(dataController: self, image: nil)
        }
    }

    func cancel() {
        self.reqest?.cancel()
        self.reqest = nil
    }
}
