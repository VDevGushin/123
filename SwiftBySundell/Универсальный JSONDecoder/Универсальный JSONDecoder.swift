//
//  Универсальный JSONDecoder.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 15/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

//JSON
/*
 {"topLevelObject":
    {
        "underlyingObject": 1
    },
    "Error": {
        "ErrorCode": 400,
        "ErrorDescription": "SomeDescription"
    }
 }
 
 Для класса JsonDecoder можно указать работу со snake_case ключами, но что делать, если у нас UpperCamelCase, dash-snake-case или вообще сборная солянка, а вручную ключи писать не хочется?
 
 К счастью, Apple предоставила возможность конфигурировать преобразование ключей перед их сопоставлением с CodingKeys структуры с помощью JSONDecoder.KeyDecodingStrategy. Этим мы и воспользуемся.
 
 Для начала создадим структуру, реализующую протокол CodingKey, потому что таковой нет в стандартной библиотеке:
 */

public let anyCodingKeyStrategy: JSONDecoder.KeyDecodingStrategy = .custom(AnyCodingKey.convertToProperLowerCamelCase)

private struct AnyCodingKey: CodingKey {
    
    var stringValue: String
    var intValue: Int?
    
    init(_ base: CodingKey) {
        self.init(stringValue: base.stringValue, intValue: base.intValue)
    }
    
    init(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
    
    static func convertToProperLowerCamelCase(keys: [CodingKey]) -> CodingKey {
        guard let last = keys.last else {
            assertionFailure()
            return AnyCodingKey(stringValue: "")
        }
        
        if let fromUpper = convertFromUpperCamelCase(initial: last.stringValue) {
            return AnyCodingKey(stringValue: fromUpper)
        } else if let fromSnake = convertFromSnakeCase(initial: last.stringValue) {
            return AnyCodingKey(stringValue: fromSnake)
        } else {
            return AnyCodingKey(last)
        }
    }
    
    private static func convertFromSnakeCase(initial: String) -> String? {
        let underscore: Character = "_"
        guard initial.firstIndex(of: underscore) != nil else { return nil }
        
        var result = ""
        // We should uppercase nextCharacter if previous was underscore.
        var shouldUppercaseNextCharacter = false
        for (index, character) in initial.enumerated() {
            if character == "_" {
                // We should not delete first and last underscores (_asd_ert_ -> _asdErt_)
                if index == 0 || index == initial.count - 1 {
                    result.append(character)
                } else {
                    shouldUppercaseNextCharacter = true
                }
            } else {
                if shouldUppercaseNextCharacter {
                    let uppercased = String(character).uppercased()
                    result.append(uppercased)
                    shouldUppercaseNextCharacter = false
                } else {
                    result.append(character)
                }
            }
        }
        
        return result
    }
    
    
    private static func convertFromUpperCamelCase(initial: String) -> String? {
        guard !initial.isEmpty else { return nil }
        let firstChar = String(initial.first!)
        guard firstChar != firstChar.lowercased() else { return nil }
        
        var result = ""
        var previousCharacterUppercased = true
        for (index, character) in initial.enumerated() {
            
            let str = String(character)
            let lower = str.lowercased()
            
            // We should check next character case for proper Abbreviation converts
            // asdEFG -> asdEfg
            // ASDEfg -> asdEfg
            // AsdEfg -> asdEfg
            // helloREADINGDeveloper -> helloReadingDeveloper
            var nextCharacterUppercased = false
            if index < initial.count - 1 {
                let nextCharacter = initial[initial.index(initial.startIndex, offsetBy: index + 1)]
                let nextCharacterStr = String(nextCharacter)
                nextCharacterUppercased = nextCharacterStr != nextCharacterStr.lowercased()
            }
            
            if lower != str {
                if previousCharacterUppercased && nextCharacterUppercased || index == 0 || index == initial.count - 1 {
                    result.append(lower)
                } else {
                    result.append(character)
                }
            } else {
                result.append(character)
            }
            
            previousCharacterUppercased = str != lower
        }
        
        return result
    }
}

// MARK: - DateFormatter
public let universalDateDecodingStrategy = JSONDecoder.DateDecodingStrategy.custom { dateDecoder in
    let container = try dateDecoder.singleValueContainer()
    
    if let dateStr = try? container.decode(String.self), let date = Date.parseDateTime(dateStr) {
        return date
    } else if let miliseconds = try? container.decode(TimeInterval.self) {
        let seconds = miliseconds / 1000
        return Date(timeIntervalSince1970: seconds)
    } else {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date")
    }
}

extension Date {
    
    struct Format {
        static let onlyDate = DateFormatter(format: "yyyy-MM-dd")
        static let full = DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSx")
        static let noWMS = DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ssZ")
        static let noWTZ = DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss.SSS")
        static let noWMSnoWTZ = DateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss")
    }
    
    static func parseDateTime(_ text: String) -> Date? {
        let notWTZ = text.contains("+")
        let notWMS = text.contains(".")
        let noTime = text.contains(":")
        let haveZSymbol = text.contains("Z")
        
        if noTime {
            return Format.onlyDate.date(from: text)
        } else if notWTZ && !haveZSymbol {
            if notWMS {
                return Format.noWMSnoWTZ.date(from: text)
            } else {
                return Format.noWTZ.date(from: text)
            }
        } else {
            if notWMS {
                return Format.noWMS.date(from: text)
            } else {
                return Format.full.date(from: text)
            }
        }
    }
}

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}
