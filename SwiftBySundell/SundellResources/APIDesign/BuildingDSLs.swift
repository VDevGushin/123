//
//  BuildingDSLs.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
/*
 DSL, сокращенно от Domain Specific Language, можно объяснить как особый вид API, который фокусируется на предоставлении простого синтаксиса, адаптированного для работы в конкретном домене. Вместо того, чтобы быть полноценными автономными языками, как, например, Swift, DSL часто размещаются на других языках, и поэтому должны использовать грамматику, которая также идеально подходит для их основного языка.
 
 DSL особенно популярны среди настраиваемых инструментов разработчика - CocoaPods, fastlane и Swift Package Manager используют DSL, чтобы позволить своим пользователям легко настроить, как они хотят, чтобы инструмент работал. Но DSL также можно использовать для упрощения работы со многими другими типами доменов, такими как запросы к базам данных, определение макета или настройка какой-либо формы маршрутизации.
 
 Хотя исторически DSL часто написаны на более динамичных языках, таких как Ruby (так как они предлагают множество способов создания собственного синтаксиса), возможности вывода типов и перегрузки Swift также делают его действительно отличным языком для создания DSL - и на этой неделе давайте сделаем это!
 
Одной из задач, которая идеально подходит под это описание, является определение ограничений макета с помощью Auto Layout. Несмотря на то, что API Auto Layout значительно улучшился за прошедшие годы - особенно с введением якорей макетов в iOS 9 - он все еще довольно многословен и тяжел, даже для простых задач, таких как определение позиции и ширины для UILabel на основе одноуровневого элемента и его кнопки. родительский вид:
 */

/*
 label.translatesAutoresizingMaskIntoConstraints = false
 
 NSLayoutConstraint.activate([
 label.topAnchor.constraint(equalTo: button.bottomAnchor,constant: 20),
 label.leadingAnchor.constraint(equalTo: button.leadingAnchor),
 label.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor,constant: -40)
 ])
 ===
 label.layout {
 $0.top == button.bottomAnchor + 20
 $0.leading == button.leadingAnchor
 $0.width <= view.widthAnchor - 40
 }
 
 
 Давайте начнем с создания основы, на которой мы позже построим наш DSL. По сути, мы хотим обернуть API на основе привязки макета по умолчанию для Auto Layout в «оболочку DSL», которая при вызове по-прежнему создает полностью нормальные ограничения макета.
 
 Все привязки макета реализованы с использованием класса NSLayoutAnchor, который является универсальным, поскольку разные привязки действуют по-разному в зависимости от того, используются ли они для таких вещей, как позиционирование или размер. Так как обобщения Objective-C не так мощны, как Swift, давайте начнем с определения протокола, который позволит нам рассматривать NSLayoutAnchor так, как если бы это был нативный тип Swift.
 
 Мы определим наш протокол, взяв методы, которые нам интересны, и добавив их в качестве требований, например:
*/
// MARK: - DSL

fileprivate protocol LayoutAnchor {
    func constraint(equalTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self, constant: CGFloat) -> NSLayoutConstraint
}

/*Поскольку NSLayoutAnchor уже реализует вышеуказанные методы, все, что нам нужно сделать, чтобы привести его в соответствие с нашим новым протоколом, это просто добавить пустое расширение:*/
extension NSLayoutAnchor: LayoutAnchor { }

/*Вышеупомянутая методика, которая по существу скрывает тип системы за протоколом
 
 Далее нам нужен способ более простой ссылки на один якорь. Для этого мы собираемся определить тип LayoutProperty, который мы сможем использовать в нашем DSL для установки ограничений для таких свойств, как top, лид, ширина и т. Д.
 
 Этот новый тип будет просто оболочкой вокруг якоря, так как мы не хотим «загрязнять» сам тип NSLayoutAnchor множеством расширений, чтобы заставить нашу DSL работать. Поскольку теперь у нас есть протокол, который позволяет нам ссылаться на привязки макета безопасным для типов способом, мы будем использовать его как общее ограничение для нашего нового типа, например:
 */
fileprivate struct LayoutProperty<T: LayoutAnchor> {
    fileprivate let anchor: T

    func equal(to otherAnchor: T, offsetBy constant: CGFloat = 0) {
        anchor.constraint(equalTo: otherAnchor, constant: constant).isActive = true
    }

    func greaterThanOrEqual(to otherAnchor: T,
                            offsetBy constant: CGFloat = 0) {
        anchor.constraint(greaterThanOrEqualTo: otherAnchor,
                          constant: constant).isActive = true
    }

    func lessThanOrEqual(to otherAnchor: T,
                         offsetBy constant: CGFloat = 0) {
        anchor.constraint(lessThanOrEqualTo: otherAnchor,
                          constant: constant).isActive = true
    }
}

/*Теперь, когда у нас есть способ обработки как якорей, так и свойств, давайте перейдем к сути нашего DSL, который является объектом, который будет выступать в качестве прокси для представления, для которого мы сейчас определяем макет. Этот объект будет содержать все свойства макета и будет ключевым объектом, с которым мы будем взаимодействовать при использовании нашего DSL. Давайте назовем его LayoutProxy, и начнем с определения свойств для некоторых распространенных якорей - таких как лидерство, верх и ширина:
 */

fileprivate final class LayoutProxy {
    lazy var leading = property(with: view.leadingAnchor)
    lazy var trailing = property(with: view.trailingAnchor)
    lazy var top = property(with: view.topAnchor)
    lazy var bottom = property(with: view.bottomAnchor)
    lazy var width = property(with: view.widthAnchor)
    lazy var height = property(with: view.heightAnchor)

    private let view: UIView

    fileprivate init(view: UIView) {
        self.view = view
    }

    private func property<T: LayoutAnchor>(with anchor: T) -> LayoutProperty<T> {
        return LayoutProperty(anchor: anchor)
    }
}

// MARK: - From API to DSL
/*Возможно, у нас еще нет полного DSL, но с завершением нашей основной работы мы уже можем начать использовать наш код, как если бы мы были «нормальным» API. Все, что нам нужно сделать, - это вручную создать экземпляр LayoutProxy для представления, для которого мы хотим определить макет, а затем вызвать методы для его свойств макета, чтобы добавить ограничения, например:
*/
fileprivate func firstTest() {
    let label = UILabel(frame: .zero)
    let button = UIButton(frame: .zero)

    let proxy = LayoutProxy(view: label)
    proxy.top.equal(to: button.topAnchor)
    proxy.leading.equal(to: button.leadingAnchor)
    proxy.width.lessThanOrEqual(to: button.widthAnchor)
}

/*По сравнению с API Auto Layout по умолчанию это уже значительное сокращение многословия! Однако, хотя наши методы читаются довольно хорошо, когда используются как выше, весь код выглядит немного неуместным. Немного странно, что приходится создавать прокси-объект только для определения макета, и вызовы типа proxy.top.equal не имеют особого смысла, не зная о деталях реализации нашего API.
 
 Итак, давайте сделаем еще один шаг вперед и позволим использовать приведенный выше код в качестве правильного DSL. Первое, что нам нужно, это контекст выполнения. Одна из причин того, что DSL могут удалить столько многословия и бессмысленности, заключается в том, что они используются в очень специфическом контексте, который сам уже предоставляет большую часть информации, необходимой для понимания того, что делает код. Когда мы видим pod «Unbox» в Podfile, мы сразу понимаем, что добавляем pod Unbox в наш проект, так как знаем, что в настоящее время мы находимся в контексте DSL CocoaPods.
 
 Для нашего контекста мы будем черпать вдохновение из API UIView.animate и будем использовать замыкание для инкапсуляции использования нашего DSL. Все, что нам нужно для этого, - это простое расширение в UIView, которое добавляет метод, который в свою очередь вызывает закрытие нашего контекста. Мы также воспользуемся этой возможностью, чтобы автоматически установить для translatesAutoresizingMaskIntoConstraints значение false, что дополнительно упрощает использование нашего API, например:
 */
fileprivate extension UIView {
    func layout(using closure: (LayoutProxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        closure(LayoutProxy(view: self))
    }
}

fileprivate func secondTest() {
    let label = UILabel(frame: .zero)
    let button = UIButton(frame: .zero)

    label.layout {
        $0.top.equal(to: button.topAnchor)
        $0.leading.equal(to: button.leadingAnchor)
        $0.width.lessThanOrEqual(to: button.widthAnchor, offsetBy: -40)
    }
}

// MARK: - Hello, Operator!

fileprivate func + <T: LayoutAnchor>(lhs: T, rhs: CGFloat) -> (T, CGFloat) {
    return (lhs, rhs)
}

fileprivate func - <T: LayoutAnchor>(lhs: T, rhs: CGFloat) -> (T, CGFloat) {
    return (lhs, rhs)
}

fileprivate func == <A: LayoutAnchor>(lhs: LayoutProperty<A>,
                                      rhs: (A, CGFloat)) {
    lhs.equal(to: rhs.0, offsetBy: rhs.1)
}

fileprivate func == <A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
    lhs.equal(to: rhs)
}

fileprivate func >= <A: LayoutAnchor>(lhs: LayoutProperty<A>,
                                      rhs: (A, CGFloat)) {
    lhs.greaterThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

fileprivate func >= <A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
    lhs.greaterThanOrEqual(to: rhs)
}

fileprivate func <= <A: LayoutAnchor>(lhs: LayoutProperty<A>,
                                      rhs: (A, CGFloat)) {
    lhs.lessThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

fileprivate func <= <A: LayoutAnchor>(lhs: LayoutProperty<A>, rhs: A) {
    lhs.lessThanOrEqual(to: rhs)
}

fileprivate func threeTest() {
    let label = UILabel(frame: .zero)
    let button = UIButton(frame: .zero)

    label.layout {
        $0.top == button.bottomAnchor + 20
        $0.leading == button.leadingAnchor
        $0.leading == button.leadingAnchor
    }
}
