//
//  Inspiration.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class Inspiration: Session {
    class func allInspirations() -> [Inspiration] {
        var inspirations: [Inspiration] = []
        guard let URL = Bundle.main.url(forResource: "Inspirations", withExtension: "plist"),
            let tutorialsFromPlist = NSArray(contentsOf: URL) else {
                return inspirations
        }
        for dictionary in tutorialsFromPlist {
            let inspiration = Inspiration(dictionary: dictionary as! NSDictionary)
            inspirations.append(inspiration)
        }
        return inspirations
    }
}
