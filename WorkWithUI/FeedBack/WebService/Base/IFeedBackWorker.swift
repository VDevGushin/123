//
//  IFeedBackWorker.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

protocol IFeedBackWorkerDelegate: class {
    func sourceChanged<T>(isFirstTime: Bool, source: T)
    func sourceError(with: Error)
}

protocol IFeedBackWorker {
    var delegate: IFeedBackWorkerDelegate? { get set }
    func execute()
    func refresh()
}
