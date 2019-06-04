//
//  RealAlamofireDataController+HTTPHeaders.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Alamofire
/*Adding a custom HTTP header to a Request is supported directly in the global request method. This makes it easy to attach HTTP headers to a Request that can be constantly changing.*/

/*Для HTTP-заголовков, которые не изменяются, рекомендуется установить их в URLSessionConfiguration, чтобы они автоматически применялись к любому URLSessionTask, созданному базовым URLSession. Для получения дополнительной информации см. Раздел «Конфигурации диспетчера сеансов».
 
 The default Alamofire SessionManager provides a default set of headers for every Request. These include:
 
 Accept-Encoding, which defaults to gzip;q=1.0, compress;q=0.5, per RFC 7230 §4.2.3.
 Accept-Language, which defaults to up to the top 6 preferred languages on the system, formatted like en;q=1.0, per RFC 7231 §5.3.5.
 User-Agent, which contains versioning information about the current app. For example: iOS Example/1.0 (com.alamofire.iOS-Example; build:1; iOS 10.0.0) Alamofire/4.0.0, per RFC 7231 §5.5.3.
 If you need to customize these headers, a custom URLSessionConfiguration should be created, the defaultHTTPHeaders property updated and the configuration applied to a new SessionManager instance.
 */
extension RealAlamofireDataController {
    func requestWithHeaders() {
        let headers: HTTPHeaders = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json"
        ]
        
        AF.request("https://httpbin.org/headers", headers: headers).responseJSON { response in
            debugPrint(response)
        }
    }
}
