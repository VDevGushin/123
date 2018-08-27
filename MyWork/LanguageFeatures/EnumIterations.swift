//
//  EnumIterations.swift
//  MyWork
//
//  Created by Vladislav Gushin on 27/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

//Enum dictionaries
let string = NSAttributedString(
    string: "Hello, world!",
    attributes: [
        .foregroundColor: UIColor.red,
        .font: UIFont.systemFont(ofSize: 20)
    ]
)


enum TextType : CaseIterable{    
    case title
    case subtitle
    case sectionTitle
    case body
    case comment
}

let fonts: [TextType : UIFont] = [
    .title : .preferredFont(forTextStyle: .headline),
    .subtitle : .preferredFont(forTextStyle: .subheadline),
    .sectionTitle : .preferredFont(forTextStyle: .title2),
    .comment : .preferredFont(forTextStyle: .footnote)
]
