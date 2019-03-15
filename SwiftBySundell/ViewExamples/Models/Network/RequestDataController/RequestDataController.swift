//
//  RequestDataController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 15/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

protocol RequestDataController {
    var endPoint: EndPoint { get set }
    var requestBahavior: WebRequestBehavior { get set }
}
