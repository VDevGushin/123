//
//  CaptchaService.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 06/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

fileprivate extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map {
                //self.substring(with: Range($0.range, in: self)!)
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
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

final class CaptchaService {
    typealias Handler = (Result<UIImage?>) -> Void

    func getCaptcha(then handler: @escaping Handler) {
        struct CaptchaModel: Decodable {
            enum CodingKeys: String, CodingKey {
                case id = "Id"
                case name = "Image"
            }
            let id: String
            var image: UIImage?
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.id = try container.decode(String.self, forKey: .id)
                if let text = try? container.decode(String.self, forKey: .name) {
                    let results = text.matches(for: "data:image\\/([a-zA-Z]*);base64,([^\\\"]*)")
                    for imageString in results {
                        autoreleasepool {
                            self.image = imageString.base64ToImage()
                        }
                    }
                }
            }
        }
        let config = FeedBackWebConfigurator.getCaptcha()
        let endpoint = FeedBackEndpoint(configurator: config)
        let request = endpoint.urlRequest()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error { return handler(Result.error(error)) }
            guard let jsonData = data else { return handler(Result.error(FeedBackError.noData)) }
            do {
                let model: CaptchaModel = try jsonData.decode(using: FeedBackConfig.decoder)
                return handler(Result.result(model.image))
            } catch {
                handler(Result.error(error))
            }
        }
        task.resume()
    }
}
