//
//  Заместитель (Прокси).swift
//  Patterns
//
//  Created by Vlad Gushchin on 23/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Паттерн Заместитель (Proxy) предоставляет объект-заместитель, который управляет доступом к другому объекту. То есть создается объект-суррогат, который может выступать в роли другого объекта и замещать его.
 
 Когда использовать прокси?
 
 Когда надо осуществлять взаимодействие по сети, а объект-проси должен имитировать поведения объекта в другом адресном пространстве. Использование прокси позволяет снизить накладные издержки при передачи данных через сеть. Подобная ситуация еще называется удалённый заместитель (remote proxies)
 
 Когда нужно управлять доступом к ресурсу, создание которого требует больших затрат. Реальный объект создается только тогда, когда он действительно может понадобится, а до этого все запросы к нему обрабатывает прокси-объект. Подобная ситуация еще называется виртуальный заместитель (virtual proxies)
 
 Когда необходимо разграничить доступ к вызываемому объекту в зависимости от прав вызывающего объекта. Подобная ситуация еще называется защищающий заместитель (protection proxies)
 
 Когда нужно вести подсчет ссылок на объект или обеспечить потокобезопасную работу с реальным объектом. Подобная ситуация называется "умные ссылки" (smart reference)*/

fileprivate protocol Subject {
    func request()
}

fileprivate class RealSubject: Subject {
    func request() {
    }
}

fileprivate class Proxy: Subject {
    var realSubject: RealSubject?
    func request() {
        if self.realSubject == nil {
            self.realSubject = RealSubject()
        }
        self.realSubject?.request()
    }
}

//Рассмотрим применение паттерна. Допустим, мы взаимодействуем с базой данных через Entity Framework. У нас есть модель и контекст данных:

protocol DbContext { }

struct Page: Hashable {
    var id: Int
    var number: Int
    var text: String
}

struct PageContext: DbContext {
    var pages: Set<Page> = Set<Page>()
    init() {
        let p1 = Page(id: 1, number: 1, text: "Первая страница")
        let p2 = Page(id: 1, number: 1, text: "Вторая страница")
        let p3 = Page(id: 1, number: 1, text: "Третья страница")
        let p4 = Page(id: 1, number: 1, text: "Четвертая страница")
        self.pages.insert(p1)
        self.pages.insert(p2)
        self.pages.insert(p3)
        self.pages.insert(p4)
    }
}

//Класс Page представляет отдельную страницу книги, у которой есть номер и текст. Взаимодействие с базой данных может уменьшить производительность приложения. Для оптимизации приложения мы можем использовать паттерн Прокси. Для этого определим репозиторий и его прокси-двойник:

protocol BookProtocol {
    func getPage(number: Int) -> Page?
}

struct BookStore: BookProtocol {
    let db: PageContext

    init() {
        self.db = PageContext()
    }

    func getPage(number: Int) -> Page? {
        return db.pages.first {
            $0.number == number
        }
    }
}

class BookStoreProxy: BookProtocol {
    var pages = Set<Page>()
    var bookStore: BookStore?

    func getPage(number: Int) -> Page? {
        guard let page = pages.first(where: { $0.number == number }) else {
            if self.bookStore == nil { self.bookStore = BookStore() }
            guard let page = self.bookStore?.getPage(number: number) else {
                return nil
            }
            self.pages.insert(page)
            return page
        }
        return page
    }
}

func testProxy() {
    let book = BookStoreProxy()
    let page1 = book.getPage(number: 1)
    print(page1?.text ?? "")

    let page2 = book.getPage(number: 2)
    print(page2?.text ?? "")
}
