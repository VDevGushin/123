//
//  RealAlamofireDataController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Alamofire

/*Обработчик ответа НЕ оценивает какие-либо данные ответа. Он просто перенаправляет всю информацию непосредственно от делегата сеанса URL. Это эквивалент Alamofire использования cURL для выполнения запроса.*/
class RealAlamofireDataController: AlamofireDataController {
    // Response Handler - Unserialized Response
    func makeRequestResponse(with string: String) {
        AF.request(string).response { response in
            print("Request: \(String(describing: response.request))") // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
        }
    }
    
    // Response Data Handler - Serialized into Data
    /*The responseData handler uses the responseDataSerializer (the object that serializes the server data into some other type)
     to extract the Data returned by the server. If no errors occur and Data is returned, the response Result will be a .success and the value will be of type Data.*/
    func makeRequestDataResponse(with string: String) {
        AF.request(string).responseData { response in
            print("Request: \(String(describing: response.request))") // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            
            //get data from result
            if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
        }
    }
    
    // Response String Handler - Serialized into String
    /*The responseString handler uses the responseStringSerializer to convert the Data returned by the server into a String with the specified encoding.
     If no errors occur and the server data is successfully serialized into a String, the response Result will be a .success and the value will be of type String.*/
    func makeRequestStringResponse(with string: String) {
        AF.request(string).responseString { response in
            print("Request: \(String(describing: response.request))") // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            
            if let json = response.result.value {
                print("JSON: \(json)")
            }
        }
    }
    
    func makeRequestJSONResonse(with string: String) {
        AF.request(string).responseJSON { response in
            print("Request: \(String(describing: response.request))") // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    
    // MARK: - Chained Response Handlers
    /*Важно отметить, что использование нескольких обработчиков ответов для одного и того же запроса требует многократной сериализации данных сервера.
     Один раз для каждого обработчика ответа.*/
    func makeChainedResponse(with string: String) {
        AF.request(string).responseString { response in
            if let json = response.result.value {
                print("JSON: \(json)")
            }
            }.responseJSON { response in
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
        }
    }
    
    // MARK: - Response Handler Queue
    func makeRequestJSONResonse(on queue: DispatchQueue, with string: String) {
        AF.request(string).responseJSON(queue: queue) { response in
            print("Executing response handler on utility queue")
        }
    }
    
    // MARK: - Response Validation
    /*По умолчанию Alamofire рассматривает любой выполненный запрос как успешный независимо от содержания ответа. Вызов validate до того, как обработчик ответа вызовет ошибку, если ответ имеет недопустимый код состояния или тип MIME.
     By default, Alamofire treats any completed request to be successful, regardless of the content of the response. Calling validate before a response handler causes an error to be generated if the response had an unacceptable status code or MIME type.*/
    func makeRequestDataResponseWithValidation(with string: String) {
        AF.request(string + "123")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                }
        }
        
        //Auto validation
        /*Автоматически проверяет код состояния в диапазоне 200 .. <300, и что заголовок Content-Type ответа соответствует заголовку Accept запроса, если таковой имеется.*/
        AF.request(string).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - HTTP Methods
    func makeRequestHTTPMethod() {
        /*public enum HTTPMethod: String {
         case options = "OPTIONS"
         case get     = "GET"
         case head    = "HEAD"
         case post    = "POST"
         case put     = "PUT"
         case patch   = "PATCH"
         case delete  = "DELETE"
         case trace   = "TRACE"
         case connect = "CONNECT"
         }*/
        
        // method defaults to `.get`
        AF.request("https://httpbin.org/get").responseData { response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
        }
        AF.request("https://httpbin.org/post", method: .post).responseData { response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
        }
        AF.request("https://httpbin.org/put", method: .put).responseData { response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
        }
        AF.request("https://httpbin.org/delete", method: .delete).responseData { response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
        }
    }
}
