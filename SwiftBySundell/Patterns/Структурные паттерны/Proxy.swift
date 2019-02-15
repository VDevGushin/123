//
//  Proxy.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 15/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Паттерн Заместитель (Proxy) предоставляет объект-заместитель, который управляет доступом к другому объекту. То есть создается объект-суррогат, который может выступать в роли другого объекта и замещать его.
 
 Когда использовать прокси?
 
 Когда надо осуществлять взаимодействие по сети, а объект-проси должен имитировать поведения объекта в другом адресном пространстве. Использование прокси позволяет снизить накладные издержки при передачи данных через сеть. Подобная ситуация еще называется удалённый заместитель (remote proxies)
 
 Когда нужно управлять доступом к ресурсу, создание которого требует больших затрат. Реальный объект создается только тогда, когда он действительно может понадобится, а до этого все запросы к нему обрабатывает прокси-объект. Подобная ситуация еще называется виртуальный заместитель (virtual proxies)
 
 Когда необходимо разграничить доступ к вызываемому объекту в зависимости от прав вызывающего объекта. Подобная ситуация еще называется защищающий заместитель (protection proxies)
 
 Когда нужно вести подсчет ссылок на объект или обеспечить потокобезопасную работу с реальным объектом. Подобная ситуация называется "умные ссылки" (smart reference)*/


//определяет общий интерфейс для Proxy и RealSubject. Поэтому Proxy может использоваться вместо RealSubject
fileprivate protocol Subject {
    func request()
}

//представляет реальный объект, для которого создается прокси
fileprivate class RealSubject: Subject {
    func request() { }
}

/* заместитель реального объекта. Хранит ссылку на реальный объект, контролирует к нему доступ, может управлять его созданием и удалением. При необходимости Proxy переадресует запросы объекту RealSubject*/

fileprivate class Proxy: Subject {
    private var realSubject: RealSubject?

    func request() {
        if self.realSubject == nil {
            self.realSubject = RealSubject()
        }
        self.realSubject?.request()
    }
}

//Client: использует объект Proxy для доступа к объекту RealSubject
fileprivate class Client {
    func main() {
        let subject = Proxy()
        subject.request()
    }
}

/*Рассмотрим применение паттерна. Допустим, мы взаимодействуем с базой данных через Entity Framework. У нас есть модель и контекст данных:*/
fileprivate protocol DbContext {
    var pages: Set<Page> { get set }
}

fileprivate struct Page: Hashable {
    let id: Int
    var number: Int
    let text: String
}

fileprivate struct PageContext: DbContext {
    var pages: Set<Page>
}

fileprivate protocol Book {
    func getPage(number: Int) -> Page?
}

fileprivate class BookStore: Book {
    private let db: DbContext?
    init(db: DbContext) {
        self.db = db
    }

    func getPage(number: Int) -> Page? {
        return db?.pages.first {
            $0.number == number
        }
    }
}

fileprivate class BookStoreProxy: Book {
    private var pages: [Page] = []
    private lazy var bookStore = BookStore(db: PageContext(pages: []))


    func getPage(number: Int) -> Page? {
        var page = pages.first {
            $0.number == number
        }
        if page == nil {
            page = bookStore.getPage(number: number)
            self.pages.append(page!)
        }
        return page
    }
}

fileprivate class Programm{
    func main(){
        let book = BookStoreProxy()
        //Читаем 1 стрницу
        let page1 = book.getPage(number: 1)
        //...
    }
}
