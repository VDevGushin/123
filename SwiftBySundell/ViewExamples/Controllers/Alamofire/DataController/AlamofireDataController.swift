//
//  AlamofireDataController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

protocol AlamofireDataController {
    /*Ни один из обработчиков ответов не выполняет никакой проверки HTTPURLResponse, который он возвращает с сервера.
     Например, коды состояния ответа в диапазонах 400 .. <500 и 500 .. <600 НЕ автоматически вызывают ошибку.
     Alamofire использует цепочку методов Response Validation для достижения этой цели.*/
    func makeRequestResponse(with string: String)
    func makeRequestDataResponse(with string: String)
    func makeRequestStringResponse(with string: String)
    func makeRequestJSONResonse(with string: String)

    //Chained Response
    func makeChainedResponse(with string: String)
    //Response Handler Queue
    func makeRequestJSONResonse(on queue: DispatchQueue, with string: String)
    //Response Validation
    func makeRequestDataResponseWithValidation(with string: String)
    //HTTP Methods
    func makeRequestHTTPMethod()
    //URL Encoding
    //GET Request With URL-Encoded Parameters
    //POST Request With URL-Encoded Parameters
    func requestWithURLEncodedParameters(with parameters: Parameters)
    //HTTP Headers
    func requestWithHeaders()
    //HTTP Basic Authentication
    func makeAuth(with user: String, password: String)
    func makeAuthWithCredential(with user: String, password: String)
    //Download data to file
    func imageDownload(on queue: DispatchQueue) -> Promise<UIImage>
    func downloadFileDestination(on queue: DispatchQueue) -> Promise<UIImage>
    //Uploading
    func uploadData(image: UIImage)
    func uploadFile()
    func uploadMultipartFormData()
}

/*Statistical Metrics
 
 Timeline
 
 Alamofire collects timings throughout the lifecycle of a Request and creates a Timeline object exposed as a property on all response types.
 
 Alamofire.request("https://httpbin.org/get").responseJSON { response in
 print(response.timeline)
 }
 The above reports the following Timeline info:
 
 Latency: 0.428 seconds
 Request Duration: 0.428 seconds
 Serialization Duration: 0.001 seconds
 Total Duration: 0.429 seconds
 URL Session Task Metrics
 
 In iOS and tvOS 10 and macOS 10.12, Apple introduced the new URLSessionTaskMetrics APIs. The task metrics encapsulate some fantastic statistical information about the request and response execution. The API is very similar to the Timeline, but provides many more statistics that Alamofire doesn't have access to compute. The metrics can be accessed through any response type.
 
 Alamofire.request("https://httpbin.org/get").responseJSON { response in
 print(response.metrics)
 }
 It's important to note that these APIs are only available on iOS and tvOS 10 and macOS 10.12. Therefore, depending on your deployment target, you may need to use these inside availability checks:
 
 Alamofire.request("https://httpbin.org/get").responseJSON { response in
 if #available(iOS 10.0, *) {
 print(response.metrics)
 }
 }
 cURL Command Output
 
 Debugging platform issues can be frustrating. Thankfully, Alamofire Request objects conform to both the CustomStringConvertible and CustomDebugStringConvertible protocols to provide some VERY helpful debugging tools.
 
 CustomStringConvertible
 
 let request = Alamofire.request("https://httpbin.org/ip")
 
 print(request)
 // GET https://httpbin.org/ip (200)
 CustomDebugStringConvertible
 
 let request = Alamofire.request("https://httpbin.org/get", parameters: ["foo": "bar"])
 debugPrint(request)
 Outputs:
 
 $ curl -i \
 -H "User-Agent: Alamofire/4.0.0" \
 -H "Accept-Encoding: gzip;q=1.0, compress;q=0.5" \
 -H "Accept-Language: en;q=1.0,fr;q=0.9,de;q=0.8,zh-Hans;q=0.7,zh-Hant;q=0.6,ja;q=0.5" \
 "https://httpbin.org/get?foo=bar"*/
