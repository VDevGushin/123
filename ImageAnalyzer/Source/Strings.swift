//
//  Strings.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 09/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

fileprivate protocol IText {
    var text: String { get }
}

enum AppText {
    enum ImageGetColorsViewController: String, IText {
        case title = "Image colors"
        var text: String {
            return self.rawValue
        }
    }

    enum ImageCaptureViewController: String, IText {
        case title = "Image"
        var text: String {
            return self.rawValue
        }
    }
}
