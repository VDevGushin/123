//
//  CaptchaModel.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 08/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct CaptchaModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case image = "Image"
    }
    let id: String
    var image: UIImage?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        if let text = try? container.decode(String.self, forKey: .image) {
            let results = text.matches(for: "data:image\\/([a-zA-Z]*);base64,([^\\\"]*)")
            for imageString in results {
                autoreleasepool {
                    self.image = imageString.base64ToImage()
                }
            }
        }
    }
}

fileprivate extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch {
            return []
        }
    }

    func base64ToImage() -> UIImage? {
        if let url = URL(string: self), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            return image
        }
        return nil
    }
}
