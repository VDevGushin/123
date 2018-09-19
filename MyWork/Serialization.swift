//
//  Serialization.swift
//  MyWork
//
//  Created by Vladislav Gushin on 06/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
// MARK: - Using
private class TestUser: Decodable, Encodable {
    let id: Int
    let name: String
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

private class TestSerialization {
    private func test() {
        //Старое без extension Data
        //let decoder = JSONDecoder()
//        if let user = try? decoder.decode(TestUser.self, from: data) {
//            self.userDidLogin(new: user)
//        }
        let user = TestUser(id: 1, name: "Vlad")
        if let data = try? user.encoded() { ///!!!
            if let user: TestUser = try? data.decode() { ///!!!
                self.userDidLogin(new: user)
            }
        }
    }
    private func userDidLogin(new: TestUser) { }
}
// MARK: - Decoding
/////////////////////////////////////////////// ////////////////////Decoding
fileprivate extension Data {
    func decode<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }

    //более расширенная функция декодирования
    func decode<T: Decodable>(using decoder: JSONDecoder = .init()) throws -> T {
        return try decoder.decode(T.self, from: self)
    }

    //Еще больше расширяем возможности декодирования и использования разных декодеров
    func decode<T: Decodable>(using decoder: AnyDecoder = JSONDecoder()) throws -> T {
        return try decoder.decode(T.self, from: self)
    }
}

protocol AnyDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: AnyDecoder { }
extension PropertyListDecoder: AnyDecoder { }

// MARK: - Encoding
protocol AnyEncoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: AnyEncoder { }
extension PropertyListEncoder: AnyEncoder { }

extension Encodable {
    func encoded(using encoder: AnyEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}

// MARK: - Decoding containers
private struct Comment: Decodable {
    let text: String
}

private struct Video {
    let url: URL
    let containsAds: Bool
    var comments: [Comment]
}

extension Video: Decodable {
    enum CodingKey: String, Swift.CodingKey {
        case url
        case containsAds = "contains_ads"
        case comment
    }

    //Работа без расширения
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKey.self)
//        url = try container.decode(URL.self, forKey: .url)
//        containsAds = try container.decodeIfPresent(Bool.self, forKey: .containsAds) ?? false
//        comments = try container.decodeIfPresent([Comment].self, forKey: .comment) ?? []
//    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKey.self)
        url = try container.decode(URL.self, forKey: .url)
        containsAds = try container.decode(forKey: .containsAds, default: false)
        comments = try container.decode(forKey: .comment, default: [])
    }
}

extension KeyedDecodingContainerProtocol {
    func decode<T: Decodable>(forKey key: Key) throws -> T {
        return try decode(T.self, forKey: key)
    }

    func decode<T: Decodable>(forKey key: Key, default defaultExpression: @autoclosure () -> T) throws -> T {
        return try decodeIfPresent(T.self, forKey: key) ?? defaultExpression()
    }
}
