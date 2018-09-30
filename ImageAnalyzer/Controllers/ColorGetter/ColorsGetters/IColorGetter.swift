//
//  IColorGetter.swift
//  UIPart
//
//  Created by Vladislav Gushin on 26/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol IColorGetter {
    var isInWork: Bool { get set }
    func process(_ image: UIImage, completion: @escaping ([ColorInfoModel]) -> Void)
    func cancel()
}
