//
//  UsingAutoclosure .swift
//  MyWork
//
//  Created by Vladislav Gushin on 16/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

private func animate(_ animation: @escaping () -> Void, duration: TimeInterval = 0.25) {
    UIView.animate(withDuration: duration, animations: animation)
}

private class Autoclosure {
    var view: UIView?
    func testAutoclosure() {
        if let view = view {
            animate({ view.frame.origin.y = 100 }, duration: 100)
        }
    }
}

private class TestOptional {
    struct ArgumetError {
        enum Er: Error {
            case test
        }
        static func testCase() -> Error {
            return Er.test
        }
    }
    let a: Int? = 3
    func test() {
        do {
            let value = try a.unwrapOrThrow(ArgumetError.Er.test)
            print(value)
        } catch {
            print(test)
        }
    }
}

//Работа с нетипизированным словарем
private class WorkWithDictAny {
    let dic = [String: Any]()
    func test() {
        //обычное использование
        _ = (dic["numberOfCoins"] as? Int) ?? 100

        //Новое использование с автозамыканием
        _ = dic.value(forKey: "numberOfCoins", defaultValue: 4)
    }
}

extension Dictionary where Value: Any {
    func value<T>(forKey key: Key, defaultValue: @autoclosure () -> T) -> T {
        guard let value = self[key] as? T else {
            return defaultValue()
        }
        return value
    }
}
