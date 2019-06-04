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

    // let request: HTTPRequest?
    var db: DispatchWorkItem?
    var db2: DispatchWorkItem?
    var db3: DispatchWorkItem?

    init() {


//        self.request = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])

//        let r1 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//        r1?.perform { _ in
//        }
//
//        self.db = DispatchWorkItem {
//            let r1 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//            let r2 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//            let r3 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//            let r4 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//            let r5 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//            let r6 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//            let r7 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//
//            r1?.perform { _ in }
//            r2?.perform { _ in }
//            r3?.perform { _ in }
//            r4?.perform { _ in }
//            r5?.perform { _ in }
//            r6?.perform { _ in }
//            r7?.perform { _ in }
//        }
//
//        self.db2 = DispatchWorkItem {
//            let r1 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//            let r2 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//            let r3 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//            let r4 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//            let r5 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//            let r6 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//            let r7 = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])
//
//            r1?.perform { _ in }
//            r2?.perform { _ in }
//            r3?.perform { _ in }
//            r4?.perform { _ in }
//            r5?.perform { _ in }
//            r6?.perform { _ in }
//            r7?.perform { _ in }
//        }
//
//        self.db3 = DispatchWorkItem { [weak self] in
//            self?.db?.perform()
//            self?.db2?.perform()
//        }
//
//        db2?.perform()
//        DispatchQueue.global().async {
//            self.db?.perform()
//        }
//        DispatchQueue.global().async {
//            self.db3?.perform()
//        }
    }

    func getImage() {
        //guard let request = self.request else { return }
        let endPoint = DefaultEndPoint(configurator: BigImageDownloadConfigurator.getBitImage(id: 2000, filename: "1*d6l1Gt7j47JyxONXn8moYg.png"))
        let request = HTTPRequestPool.shared.make(name: nil, endPoint: endPoint, requestBahaviors: [LoggerBehavior()])!

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
        HTTPRequestPool.shared.cancelAll()
        //self.request?.cancel()
    }
}
