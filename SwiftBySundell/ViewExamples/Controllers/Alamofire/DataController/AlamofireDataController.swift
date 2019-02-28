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
}
