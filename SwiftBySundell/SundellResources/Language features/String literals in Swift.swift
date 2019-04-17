//
//  String literals in Swift.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 08/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Способность выражать базовые значения, такие как строки и целые числа, использование встроенных литералов является важной функцией в большинстве языков программирования. Однако, хотя многие другие языки поддерживают определенные литералы, встроенные в их компилятор, Swift использует гораздо более динамичный подход - использует свою собственную систему типов для определения того, как различные литералы должны обрабатываться с помощью протоколов.
 
 На этой неделе давайте сконцентрируемся на строковых литералах, в частности, рассмотрев множество различных способов их использования и то, как мы - с помощью сильно ориентированного на протокол дизайна Swift - можем настроить способ интерпретации литералов, который Позвольте нам сделать некоторые действительно интересные вещи.*/

// MARK: - The basics

/*Как и во многих других языках, строки Swift выражаются через литералы, заключенные в кавычки, и могут содержать как специальные последовательности (например, новые строки), экранированные символы и интерполированные значения:*/

fileprivate func test() {
    let _ = "\(123) says \"Hi!\"\nWould you like to reply?"
}

// John says "Hi!"
// Would you like to reply?
/*Хотя использованные выше функции уже предоставляют нам большую гибкость и, скорее всего, достаточно для подавляющего большинства случаев использования, существуют ситуации, в которых могут пригодиться более мощные способы выражения литералов. Давайте рассмотрим некоторые из них, начиная с того, что нам нужно определить строку, содержащую несколько строк текста.
*/

// MARK: - Multiline literals
/*Хотя любой стандартный строковый литерал можно разбить на несколько строк с помощью \ n, это не всегда практично, особенно если мы хотим определить больший фрагмент текста как встроенный литерал.
 
 К счастью, начиная с Swift 4, мы также можем определять многострочные строковые литералы, используя три кавычки вместо одной. Например, здесь мы используем эту возможность для вывода текста справки для скрипта Swift, в случае, если пользователь не передал никаких аргументов при вызове его в командной строке:*/
fileprivate func test2() {
    let _ = """
To use this script, pass the following:
- A string to process
- The maximum length of the returned string
"""
}
fileprivate struct Author {
    let twitterHandle, name: String
}
fileprivate struct Article {
    let author: Author
    let title: String
    let body: String
}
fileprivate extension Article {
    var html: String {
        // If we want to break a multiline literal into separate
        // lines without causing an *actual* line break, then we
        // can add a trailing '\' to one of our lines.
        let twitterLink = """
        <a href="https://twitter.com/\(author.twitterHandle)">\
        @\(author.twitterHandle)</a>
        """

        return """
        <article>
        <h1>\(title)</h1>
        <div class="author">
        <p>\(author.name)</p>
        \(twitterLink)
        </div>
        <div class="body">\(body)</div>
        </article>
        """
    }
}

// MARK: - Raw strings
/*Новое в Swift 5, необработанные строки позволяют нам отключить все динамические строковые литеральные функции (такие как интерполяция и интерпретация специальных символов, таких как \ n), в пользу простой обработки литерала как необработанной последовательности символов. Необработанные строки определяются окружением строкового литерала знаками фунта (или «хэштегами», как их называют дети):*/
fileprivate func test3(name: String) {
    let _ = try? NSRegularExpression(
        pattern: #"(([A-Z])|(\d))\w+"#
    )

    let _ = #"Press "Continue" to close this dialog. \#(name)"#
}

// MARK: - Expressing values using string literals
/*Хотя все строковые литералы по умолчанию превращаются в строковые значения, мы также можем использовать их для выражения пользовательских значений. Как мы рассмотрели в «Идентификаторах безопасных типов в Swift», добавление поддержки строкового литерала к одному из наших собственных типов может позволить нам повысить безопасность типов без ущерба для удобства использования литералов.
 
 Например, предположим, что мы определили протокол Searchable, который будет выступать в качестве API для поиска в любой базе данных или базовом хранилище, которое использует наше приложение, и что мы используем перечисление Query для моделирования различных способов выполнения такого поиска. :*/

fileprivate protocol Searchable {
    associatedtype Element
    func search(for query: Query) -> [Element]
}

fileprivate enum Query {
    case matching(String)
    case notMatching(String)
    case matchingAny([String])
}
// Возможносить инициализации через строку
extension Query: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = .matching(value)
    }
}

fileprivate class Search: Searchable {
    typealias Element = Author
    var authors = [Author]()

    func search(for query: Query) -> [Author] {
        switch query {
        case .matching(let value):
            return self.authors.filter {
                $0.name == value
            }
        case .notMatching(let value):
            return self.authors.filter {
                $0.name != value
            }

        case .matchingAny(let values):
            return self.authors.filter {
                values.contains($0.name)
            }
        }
    }
}

// MARK: - Custom interpolation

extension String.StringInterpolation {
    mutating func appendInterpolation(linkTo url: URL,
                                      _ title: String) {
        let string = "url.html(withTitle: title)"
        appendLiteral(string)
    }
}
