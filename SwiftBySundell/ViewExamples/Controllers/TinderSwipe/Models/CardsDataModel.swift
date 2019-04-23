//
//  CardsDataModel.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 23/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
struct CardsDataModel {
    var bgColor: UIColor
    var text : String
    var image : String
    
    init(bgColor: UIColor, text: String, image: String) {
        self.bgColor = bgColor
        self.text = text
        self.image = image
    }
}
