//
//  Different flavors of type erasure.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 25/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Всеобъемлющая цель Swift - быть достаточно мощным, чтобы его можно было использовать для низкоуровневого программирования систем, а также достаточно легким для начинающих учиться, иногда может привести к довольно интересным ситуациям - когда мощь системы типов Swift требует от нас применения довольно продвинутых методов решать проблемы, которые, на первый взгляд, могли бы показаться гораздо более тривиальными.
 
 Одна из таких ситуаций, с которой сталкивается большинство разработчиков Swift в тот или иной момент (часто раньше, чем позже), - это когда требуется какая-либо форма стирания типа, чтобы иметь возможность ссылаться на общий протокол. На этой неделе давайте начнем с рассмотрения того, что делает стирание типов такой важной техникой в Swift, а затем перейдем к изучению различных «разновидностей» его реализации - и как каждый из них имеет свои плюсы и минусы.*/

// MARK: - When is type erasure needed?

/*Слова «стирание типов» на первый взгляд могут показаться нелогичными для того, что Swift уделяет большое внимание типам и безопасности типов во время компиляции, поэтому лучше описать их как сокрытие типов, а не полное их удаление. Цель состоит в том, чтобы позволить нам более легко взаимодействовать с общими протоколами, которые имеют требования, специфичные для различных типов, которые их реализуют.
 
 Возьмите в качестве примера Equatable протокол из стандартной библиотеки. Поскольку речь идет о возможности сравнения двух значений одного и того же типа с точки зрения равенства, он использует метатип Self для аргументов своего единственного метода:*/
/*
 protocol Equatable {
 static func ==(lhs: Self, rhs: Self) -> Bool
 }
 */
/*Вышеуказанное позволяет любому типу соответствовать Equatable, при этом все же требуя, чтобы значения на обеих сторонах оператора == были одного и того же типа, поскольку каждый тип, соответствующий протоколу, должен будет «заполнять» свой собственный тип. при реализации вышеуказанного способа:*/
fileprivate struct User {
    let id: Int
}
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
/*Что хорошо в этом подходе, так это то, что он делает невозможным случайное сравнение двух не связанных между собой одинаковых типов (таких как User и String), однако - он также делает невозможным ссылаться на Equatable в качестве автономного протокола (такого как создание массива, подобного [ Equatable]), поскольку компилятор должен знать, какой именно тип действительно соответствует протоколу, чтобы иметь возможность использовать его.
 
 То же самое также верно, когда протокол содержит связанные типы. Например, здесь мы определили протокол запроса, который позволяет нам скрывать различные формы запросов данных (например, сетевые вызовы, запросы к базе данных и выборки из кэша) за единой унифицированной реализацией:*/
fileprivate enum Result<T, E: Error> {
    case success(T)
    case error(E)
}

fileprivate protocol Request {
    associatedtype Response
    associatedtype Error: Swift.Error
    
    typealias Handler = (Result<Response, Error>) -> Void
    
    func perform(then handler: @escaping Handler)
}

/*Приведенный выше подход дает нам тот же набор компромиссов, что и у Equatable - он действительно мощный, потому что он позволяет нам создавать общие абстракции для любого типа запроса, но также делает невозможным непосредственную ссылку на сам протокол запроса, например этот:*/
fileprivate class RequestQueueOld {
//    // Error: protocol 'Request' can only be used as a generic
//    // constraint because it has Self or associated type requirements

//    func add(_ request: Request,
//             handler: @escaping Request.Handler) {
//        ...
//    }

    ///One way to solve the above problem is to do exactly what the error message says, and not reference Request directly, but instead use it as a generic constraint:
    func add<R: Request>(_ request: R, handler: R.Handler) {

    }
}

/*Вышеприведенное работает, поскольку теперь компилятор может гарантировать, что переданный обработчик действительно совместим с реализацией запроса, переданной как запрос, - поскольку они оба основаны на универсальном типе R, который, в свою очередь, ограничен для соответствия запросу.
 
 Однако, хотя мы решили проблему с сигнатурой метода, мы по-прежнему не сможем сделать многое с переданным запросом - поскольку мы не сможем сохранить его как свойство Request или как часть [ Request] массив, что затруднит продолжение построения нашего RequestQueue. То есть, пока мы не начнем стирать тип.*/

// MARK: - Generic wrapper types
/*Первый вариант стирания типов, который мы рассмотрим, на самом деле не включает в себя стирание каких-либо типов, а скорее обертывание их в общий тип, на который мы можем более легко ссылаться. Продолжая опираться на пример RequestQueue, описанный выше, мы начнем с создания этого типа-оболочки, который будет захватывать метод выполнения каждого запроса как замыкание, вместе с обработчиком, который должен быть вызван после завершения запроса:*/

fileprivate struct AnyRequest<Response, Error: Swift.Error> {
    typealias Handler = (Result<Response, Error>) -> Void

    let perform: (@escaping Handler) -> Void
    let handler: Handler
}

/*Далее мы также превратим само RequestQueue в универсальный для одних и тех же типов Response и Error - что даст возможность компилятору гарантировать, что все связанные и универсальные типы выстраиваются в очередь, что позволяет нам хранить запросы, как автономные ссылки и как часть массива - вот так:*/
fileprivate class RequestQueue<Response, Error: Swift.Error> {
    private typealias TypeErasedRequest = AnyRequest<Response, Error>
    private var queue = [TypeErasedRequest]()
    private var ongoing: TypeErasedRequest?

    /*/ / We modify our 'add' method to include a 'where' clause that
    // gives us a guarantee that the passed request's associated
    // types match our queue's generic types.*/
//    func add<R: Request>(_ request: R, handler: @escaping R.Handler) where R.Response == Response, R.Error == Error {
//        
//        let typeErased = AnyRequest(perform: request.perform, handler: handler)
//        
//        guard ongoing == nil else {
//            return queue.append(typeErased)
//        }
//        
//        perform(typeErased)
//    }
//    
//    private func perform(_ request: TypeErasedRequest) {
//        ongoing = request
//        
//        request.perform { [weak self] result in
//            request.handler(result)
//            self?.ongoing = nil
//                
//                // Perform the next request if the queue isn't empty
//        }
//    }
}
