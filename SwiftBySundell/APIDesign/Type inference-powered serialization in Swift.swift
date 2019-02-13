//
//  Type inference-powered serialization in Swift.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 13/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*На этой неделе давайте посмотрим, как мы можем сделать Codable API Swift немного более приятным и менее многословным в использовании, используя возможности вывода типов.*/

// MARK: - Decoding

/*Если вы раньше не использовали Codable, это встроенный API Swift для кодирования и декодирования сериализуемых значений в двоичные данные и из них. Он в основном используется для кодирования JSON и включает в себя интеграцию на уровне компилятора, чтобы автоматически синтезировать большую часть стандартного шаблона, который обычно требуется при написании кода сериализации.
 
 На самом деле Codable - это просто простые typealias для объединения протокола Decodable и Encodable, которые определяют требования к типу, который может быть либо декодирован, либо закодирован соответственно.
 
 Во-первых, давайте посмотрим, как мы можем использовать вывод типов при декодировании значения Decodable из данных JSON. Здесь мы используем способ по умолчанию для декодирования набора данных в экземпляр User, который мы затем передаем функции, чтобы наша система входа в систему знала, что пользователь вошел в систему:*/

fileprivate struct User: Codable {
}

fileprivate func TestDecoding(data: Data)throws {
    let decoder = JSONDecoder()
    let user = try decoder.decode(User.self, from: data)
    dump(user)
}

/*В приведенном выше коде нет ничего плохого, но давайте посмотрим, сможем ли мы сделать его немного лучше, используя вывод типов. Во-первых, давайте добавим в Data расширение, которое позволит нам декодировать любой тип Decodable напрямую, просто вызвав для него decoded ():*/
fileprivate extension Data {
    func decoded<T: Decodable>()throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}

/*Поскольку мы не используем аргумент для указания того, в какой тип мы декодируем, мы оставляем это на усмотрение системы типов Swift, чтобы выяснить это, используя возможности логического вывода. Все, что нам нужно сделать, это сказать ему, к какому типу должно относиться определенное значение, а компилятор определит остальное. Это позволяет нам использовать действительно хороший синтаксис при декодировании данных, просто используя ключевое слово as для указания типа, например так:*/
fileprivate func testDecoding(with data: Data)throws {
    let user = try data.decoded() as User
    dump(user)
}

// MARK: - Improving flexibility
/*Наш новый Decodable API на основе логических выводов действительно хорош и удобен в использовании, но он может использовать некоторую дополнительную гибкость. Прежде всего, он в настоящее время всегда создает новый экземпляр JSONDecoder, встроенный при декодировании, что делает невозможным повторное использование декодера или установку его с определенными настройками. Это то, что мы можем легко решить, полностью обратно совместимым способом, параметрируя декодер, используя аргумент по умолчанию:*/

fileprivate extension Data {
    func decoded<T: Decodable>(using decoder: JSONDecoder = .init()) throws -> T {
        return try decoder.decode(T.self, from: self)
    }
}

/*Параметризация зависимостей, как мы делали выше, не только увеличивает гибкость, но и улучшает тестируемость нашего кода - так как мы по существу начали использовать внедрение зависимостей. Для получения дополнительной информации об этом и других видах внедрения зависимостей - ознакомьтесь с разделом «Различные варианты внедрения зависимостей в Swift».
 
 Теперь можно использовать любой JSONDecoder с нашим новым API, но он все еще сильно привязан к JSON в качестве исходного формата. Хотя это, вероятно, хорошо для большинства приложений, некоторые базы кода также используют списки свойств для сериализации - которую Codable также полностью поддерживает «из коробки». Не было бы неплохо, если бы мы могли заставить наш новый API, основанный на логическом выводе типов, поддерживать какой-либо Codable-совместимый механизм сериализации?
 
 Хорошей новостью является то, что это может быть легко достигнуто с помощью протокола. К сожалению, нет общего встроенного протокола для всех типов декодеров, но мы можем легко создать свой собственный. Все, что нам нужно сделать, это извлечь функцию декодирования в протокол, а затем привести все декодеры, которые нас интересуют, в соответствие с ней через расширения, например:
*/

fileprivate protocol AnyDecoder {
    func decode<T:Decodable>(_ type: T.Type, from data: Data)throws -> T
}

extension JSONDecoder: AnyDecoder { }
extension PropertyListDecoder: AnyDecoder { }

/*Наконец, мы можем обновить наше расширение Data, чтобы использовать наш новый протокол, по-прежнему используя новый экземпляр JSONDecoder в качестве значения по умолчанию для максимального удобства:
*/
fileprivate extension Data {
    func decoded<T: Decodable>(using decoder: AnyDecoder = JSONDecoder()) throws -> T {
        return try decoder.decode(T.self, from: self)
    }
}

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

fileprivate func test(user: User)throws {
    let data = try user.encoded()
    dump(data)
}

// MARK: - Decoding containers

/*Наконец, давайте посмотрим, как мы можем использовать вывод типов при работе с декодирующими контейнерами. Основным преимуществом Codable по сравнению со всеми сторонними средами JSON является то, что он тесно интегрирован с компилятором и может автоматически синтезировать соответствия, учитывая, что структура JSON соответствует тому, как мы структурировали наши значения в коде.
 
 Тем не менее, это не всегда так, и иногда нам нужно написать ручные соответствия для Decodable и Encodable, чтобы указать системе, как переводить между JSON и нашими типами. Допустим, наше приложение работает с видео и имеет структуру видео для представления видео, например:*/

fileprivate struct Comment: Decodable { }

fileprivate struct Video {
    let url: URL
    let containsAds: Bool
    var comments: [Comment]
}

extension Video: Decodable {
    enum CodingKey: String, Swift.CodingKey {
        case url
        case containsAds = "contains_ads"
        case comments
    }

    init(from decoder: Decoder)throws {
        let container = try decoder.container(keyedBy: CodingKey.self)
        url = try container.decode(URL.self, forKey: .url)
        containsAds = try container.decodeIfPresent(Bool.self, forKey: .containsAds) ?? false
        comments = try container.decodeIfPresent([Comment].self, forKey: .comments) ?? []

        //Использование расширений ниже
        let url1: URL = try container.decode(from: .url)
        let containsAds1 = try container.decode(from: .containsAds, defaultExpression: false)
        let comments1: [Comment] = try container.decode(from: .comments, defaultExpression: [])
        dump((url1, containsAds1, comments1))
    }
}

/*Существует довольно много подробностей и ручных спецификаций типов, описанных выше, поэтому давайте попробуем улучшить это, используя вывод типов.
 
 Мы начнем с расширения KeyedDecodingContainerProtocol двумя методами - один, который позволяет нам указать значение по умолчанию, и другой, который не работает в случае, если значение не было найдено для данного ключа - оба используют ту же стратегию, что и наше расширение Decodable, как раньше - полагаясь на то, что компилятор выведет тип, вместо того, чтобы указывать его на сайте вызова:*/

extension KeyedDecodingContainerProtocol {
    func decode<T: Decodable>(from key: Key) throws -> T {
        return try decode(T.self, forKey: key)
    }

    func decode<T: Decodable> (from key: Key, defaultExpression: @autoclosure () -> T)throws -> T {
        return try decodeIfPresent(T.self, forKey: key) ?? defaultExpression()
    }
}

//Использование выше


