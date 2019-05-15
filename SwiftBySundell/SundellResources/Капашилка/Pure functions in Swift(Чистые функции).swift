//
//  Pure functions in Swift.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 14/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
/*Чистые функции - это одна из тех основных концепций программирования, которая может быть применена к более или менее любому языку, который поддерживает некоторую форму функций или подпрограмм.
 
 Функция считается чистой, если она не вызывает побочных эффектов и не зависит от какого-либо внешнего состояния. Основная идея заключается в том, что чистая функция всегда будет выдавать один и тот же вывод для данного набора ввода - независимо от того, когда и сколько раз она вызывается.
 
 Хотя приведенное выше может звучать в основном как теоретическая концепция, чистые функции могут дать нам очень реальные практические преимущества - от увеличения повторного использования и тестируемости до более предсказуемого кода. На этой неделе давайте рассмотрим, как чистые функции могут использоваться в Swift - и как мы можем применять их для решения реальных проблем очень хорошим способом.*/

// MARK: - Очищающие функции

/*Давайте начнем с рассмотрения примера функции, которая потенциально может стать чистой, но еще не удовлетворяет требованию не создавать никаких побочных эффектов - поскольку она мутирует значение, к которому она вызывается:*/

fileprivate extension String {
    mutating func addSuffixIfNeeded(_ suffix: String) {
        guard !self.hasSuffix(suffix) else {
            return
        }
        self.append(suffix)
    }
}

/*Тот факт, что вышеприведенная функция является мутирующей, может не показаться чем-то большим, но поскольку String является типом значения, мы сможем вызывать его только для изменяемых значений, что часто может привести к классическому «var mutate assign» - танец:*/

fileprivate func t1(contentName: String) {
    var fileName = contentName
    fileName.addSuffixIfNeeded(".md")
    dump(fileName)
}

/*Давайте вместо этого очистим нашу функцию - заставляя ее возвращать новое значение String, а не изменяя то, к чему она была вызвана, - вот так:*/
fileprivate extension String {
    func addingSuffixIfNeeded(_ suffix: String) -> String {
        guard !self.hasSuffix(suffix) else {
            return self
        }

        return self.appending(suffix)
    }
}

fileprivate func t2(contentName: String) {
    let fileName = contentName.addingSuffixIfNeeded(".md")
    dump(fileName)
}

/*Еще одна вещь, которая может помешать функции считаться чистой, - это если она зависит от некоторой формы внешнего изменчивого состояния. Например, допустим, что мы создаем экран входа в систему для нашего приложения и хотим отобразить другое сообщение об ошибке в случае, если пользователь неоднократно не смог войти в систему. Функция, которая содержит эту логику, в настоящее время выглядит следующим образом:*/

fileprivate struct LoginController {
    var numberOfAttempts = 3
    func makeFailureHelpText() -> String {
        guard numberOfAttempts < 3 else {
            return "Still can't log you in. Forgot your password?"
        }

        return "Invalid username/password. Please try again."
    }
}

/*Поскольку вышеприведенная функция зависит от свойства numberOfAttempts контроллера представления, которое является внешним по отношению к самой функции, мы не можем считать его чистым, так как оно может начать давать разные результаты, когда свойство, от которого оно зависит, мутирует.
 Один из способов исправить это - параметризовать состояние, на которое опирается наша функция - превратить ее в чистую функцию из Int в String - или, другими словами, из числа попыток помочь тексту:
*/
extension LoginController {
    func makeFailureHelpText(numberOfAttempts: Int) -> String {
        guard numberOfAttempts < 3 else {
            return "Still can't log you in. Forgot your password?"
        }

        return "Invalid username/password. Please try again."
    }
}

// MARK: - Обеспечение чистоты

/*Хотя чистые функции имеют массу преимуществ, во время повседневного кодирования иногда бывает сложно узнать, действительно ли какая-либо конкретная функция действительно чиста - поскольку большая часть кода, который мы пишем при работе с приложениями и продуктами, полагается на много разных состояний.
 
 Однако один из способов обеспечить хотя бы определенную степень «чистоты» - это структурировать нашу логику вокруг типов значений. Поскольку значение не может мутировать себя или любых своих свойств вне мутирующих функций - это дает нам гораздо более сильную гарантию того, что наша логика действительно чиста.
 
 Например, вот как мы могли бы настроить логику для расчета общей цены покупки массива продуктов - используя структуру, которая состоит только из свойств let (которые, в свою очередь, также являются типами значений), и не мутирующий метод:*/
fileprivate struct ShippingCostDirectory {
    func shippingCost(forRegion: Region) -> Int {
        return 2
    }
}
fileprivate struct Currency { }
fileprivate typealias Cost = Int
fileprivate extension Cost {
    func convert(to currency: Currency) -> Cost {
        return self
    }
}
fileprivate struct Product {
    let price: Int
}
fileprivate struct Region { }

fileprivate struct PriceCalculator {
    let shippingCosts: ShippingCostDirectory
    let currency: Currency

    func calculateTotalPrice(for products: [Product], shippingTo region: Region) -> Cost {

        let productCost: Cost = products.reduce(0) { cost, product in
            return cost + product.price
        }

        let shippingCost: Cost = shippingCosts.shippingCost(forRegion: region)

        let totalCost: Cost = productCost + shippingCost

        return totalCost.convert(to: currency)
    }
}

// MARK: - Purifying refactors
/*В то время как чистые функции часто выглядят великолепно, когда их показывают с использованием весьма надуманных или изолированных примеров, вопрос в том, как мы можем удобно вписать их в реальную базу кода для приложения? Большая часть кода приложения не на 100% аккуратно разделена, и большая часть логики в конечном итоге изменяет некоторую форму состояния - будь то обновление файла, изменение данных в памяти или сетевой вызов.
 
 Давайте рассмотрим другой пример, в котором мы обрабатываем нажатие следующей кнопки в ReaderViewController приложения для чтения статей. В зависимости от текущего состояния контроллера представления мы либо отображаем следующую статью в очереди чтения пользователя, показываем набор рекламных акций или отклоняем текущий поток - используя логику, которая выглядит следующим образом:*/

fileprivate struct Article { }
fileprivate struct Promotion { }

fileprivate class ArticleViewController {
    var article: Article?
}

fileprivate class PromotionViewController {
    var promotions: [Promotion]?
}


fileprivate class ReaderViewController {
    var articles: [Article] = []
    var promotions: [Promotion] = []

    @objc func nextButtonTapped() {
        guard !articles.isEmpty else {
            return didFinishArticles()
        }

        let vc = ArticleViewController()
        vc.article = articles.removeFirst()
        present(vc)
    }

    func didFinishArticles() {
        guard !promotions.isEmpty else {
            return dismiss()
        }

        let vc = PromotionViewController()
        vc.promotions = promotions
        present(vc)
    }

    private func present(_ vc: Any) { }
    private func dismiss() { }
}

/*Вышесказанное ни в коем случае не является «плохим кодом» - его довольно легко прочитать, и оно даже разбито на две отдельные функции, чтобы упростить обзор логики. Но поскольку вышеприведенная функция nextButtonTapped не является чистой, ее будет очень сложно протестировать (особенно если учесть, что она зависит от множества частных состояний, которые мы должны раскрыть).
 
 Логика, подобная приведенной выше, также является очень распространенной причиной проблемы «Massive View Controller» - когда контроллеры представлений сами принимают слишком много решений, в результате чего сложная логика переплетается с кодом представления и компоновки.
 
 Вместо этого давайте выделим вышеупомянутую логику в чистый логический тип - единственной ролью которого будет содержать логику для нашей кнопки. Таким образом, мы можем смоделировать нашу логику как чистую функцию от состояния к результату и использовать статическую функцию в сочетании с типами значений, чтобы гарантировать, что наша логика является и остается чистой:*/

fileprivate struct ReaderNextButtonLogic {
    enum Outcome {
        case present(Any, remainingArticles: [Article])
        case dismiss
    }

    static func outcome(forArticles articles: [Article], promotions: [Promotion]) -> Outcome {
        guard !articles.isEmpty else {
            guard !promotions.isEmpty else {
                return .dismiss
            }

            let vc = PromotionViewController()
            vc.promotions = promotions
            return .present(vc, remainingArticles: [])
        }

        var remainingArticles = articles
        let vc = ArticleViewController()
        vc.article = remainingArticles.removeFirst()
        return .present(vc, remainingArticles: remainingArticles)
    }
}

/*Что действительно важно в приведенном выше коде, так это то, что он делает все, что ранее делал наш контроллер представления, для обработки событий касания - кроме как для изменения любой формы состояния (например, изменение свойства article или представление дочерних контроллеров представления). Это все еще то, что мы позволяем самому контроллеру представления, после определения того, каким был результат нажатия кнопки:*/

private extension ReaderViewController {
    @objc func nextButtonTapped1() {
        let outcome = ReaderNextButtonLogic.outcome(
            forArticles: articles,
            promotions: promotions)
        switch outcome {
        case .present(let vc, let remainingArticles):
            articles = remainingArticles
            present(vc)
        case .dismiss:
            dismiss()
        }
    }
}
