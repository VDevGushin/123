//
//  UIImage+Ex.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

extension UIImage {
    var decompressedImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(at: CGPoint.zero)
        guard let decompressedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        return decompressedImage
    }
}
