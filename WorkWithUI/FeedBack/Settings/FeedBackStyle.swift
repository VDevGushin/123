//
//  FeedBackStyle.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 06/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class FeedBackStyle {
    static let indicator: Decoration<UIActivityIndicatorView> = { (indicator: UIActivityIndicatorView) -> Void in
        indicator.color = FeedBackConfig.indicatorColor
    }
}
