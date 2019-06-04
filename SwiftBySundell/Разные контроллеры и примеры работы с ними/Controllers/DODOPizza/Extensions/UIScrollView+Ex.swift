//
//  UIScrollView+Ex.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 28/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

extension UIScrollView {
    func screenCenterYOffset(for offset: CGPoint? = nil) -> CGFloat {
        let offsetY = offset?.y ?? contentOffset.y
        let contentOffsetY = offsetY + bounds.height / 2

        return contentOffsetY
    }
}
