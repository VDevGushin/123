//
//  StaticFactoryMethods.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 15/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

/*Большинство объектов требуют некоторой формы настройки, прежде чем они будут готовы для использования в приложении. Будь то представление, которое мы хотим стилизовать в соответствии с брендом нашего приложения, контроллер представления, который мы настраиваем, или при создании значений-заглушек в тесте - мы часто сталкиваемся с необходимостью поместить куда-нибудь код установки.
 
 Очень распространенное место для размещения такого кода установки находится в подклассе. Просто создайте подкласс для объекта, который вам нужно настроить, переопределите его инициализатор и выполните настройку там - готово! Хотя это, безусловно, способ сделать это, на этой неделе давайте рассмотрим альтернативный подход к написанию кода установки, который не требует какой-либо формы подклассов - с помощью статических фабричных методов.
*/

// MARK: - Views

/*
 Один из самых распространенных объектов, которые мы должны настроить при написании кода пользовательского интерфейса, - это представления. И UIKit на iOS, и AppKit на Mac дают нам все основные базовые строительные блоки, которые нам необходимы для создания пользовательского интерфейса с естественным внешним видом и интерфейсом, но нам часто приходится настраивать эти стили в соответствии с нашим дизайном и определять макет для них.
 
 Опять же, именно здесь многие разработчики будут выбирать подклассы и создавать собственные варианты встроенных классов представления - как здесь для метки, которую мы будем использовать для визуализации заголовка:*/

fileprivate class TitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.boldSystemFont(ofSize: 24)
        self.textColor = UIColor.darkGray
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.75
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*В этом подходе нет ничего плохого, но он создает больше типов для отслеживания, и мы также часто получаем несколько подклассов для небольших вариантов одного и того же типа представления (таких как TitleLabel, SubtitleLabel, FeaturedTitleLabel и т. Д.).
 
 Хотя создание подклассов является важной языковой функцией, даже в эпоху протокольно-ориентированного программирования, пользовательские настройки легко спутать с пользовательским поведением. Мы не добавляем никакого нового поведения в UILabel выше, мы просто настраиваем экземпляр. Таким образом, вопрос в том, действительно ли подкласс является правильным инструментом для работы здесь?
 
 Вместо этого давайте попробуем использовать статический фабричный метод для достижения того же самого. Что мы сделаем, так это добавим в UILabel расширение, которое позволит нам создать новый экземпляр с такой же точной настройкой, как в TitleLabel, как показано выше:*/

fileprivate extension UILabel {
    static func makeForTitle() -> UILabel {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.darkGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }
}

/*Прелесть вышеупомянутого подхода (помимо того, что он не полагается на создание подклассов или добавление каких-либо новых типов), заключается в том, что мы четко отделяем наш установочный код от нашей реальной логики. Кроме того, поскольку расширения могут быть ограничены одним файлом (путем добавления частного), мы можем легко настроить расширения для частей нашего приложения, которым необходимо создавать определенные представления только одной единственной функцией:*/

fileprivate extension UIButton {
    static func makeForBuying() -> UIButton {
        let button = UIButton(frame: .zero)
        return button
    }
}

/*Используя описанный выше метод статических фабричных методов, мы можем теперь сделать наш код пользовательского интерфейса довольно красивым, поскольку все, что нам нужно сделать, - это вызвать наши методы, чтобы создать полностью сконфигурированные экземпляры для того, что нам нужно:
*/

fileprivate class ProductViewController {
    private lazy var titleLabel = UILabel.makeForTitle()
    private lazy var buyButton = UIButton.makeForBuying()
}

/*Если мы хотим сделать наши API-интерфейсы еще более минималистичными (что во многих отношениях поощряет Swift такими функциями, как точечный синтаксис и то, как он сокращает импортированные API-интерфейсы Objective-C), мы можем даже превратить наши методы в вычисляемые свойства, например:*/

fileprivate extension UILabel {
    static var title: UILabel {
        let label = UILabel(frame: .zero)
        return label
    }
}

fileprivate extension UIButton {
    static var buyButton: UIButton {
        let button = UIButton(frame: .zero)
        return button
    }
}

fileprivate class ProductViewController1 {
    private lazy var titleLabel = UILabel.title
    private lazy var buyButton = UIButton.buyButton
}

/*Конечно, если мы в конечном итоге добавим аргументы в наши API-интерфейсы настройки, нам нужно превратить их обратно в методы - но использование статических вычисляемых свойств таким образом может быть довольно хорошим вариантом для более простых случаев использования.
*/

// MARK: - View controllers

/*Давайте перейдем к просмотру контроллеров, другого типа объектов, для которых очень часто используются подклассы. Хотя мы, вероятно, не сможем полностью избавиться от подклассов для контроллеров представлений (или представлений в этом отношении), существуют определенные виды контроллеров представлений, которые могут выиграть от заводского подхода.
 
 Особенно при использовании дочерних контроллеров представления, мы часто заканчиваем с группой контроллеров представления, которые только там, чтобы представить определенное состояние - вместо того, чтобы иметь много логики в них. Для этих контроллеров представления перенос их настройки на статический API-интерфейс фабрики может быть довольно хорошим решением.
 
 Здесь мы используем этот подход для реализации вычисляемого свойства, которое возвращает контроллер представления загрузки, который мы будем использовать для представления загрузчика:*/

fileprivate extension UIViewController {
    static var loading: UIViewController {
        let viewController = UIViewController(nibName: nil, bundle: nil)

        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        viewController.view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])
        return viewController
    }
}

/*Как вы можете видеть выше, мы даже можем установить внутренние ограничения Auto Layout в наших статических свойствах или функциях. Это ситуация, в которой декларативный характер Auto Layout действительно пригодится - мы можем просто указать все наши ограничения заранее, без необходимости переопределять какие-либо методы или отвечать на какие-либо вызовы.
 
 Как и при использовании для просмотра, фабричный подход дает нам очень хорошие и чистые сайты вызовов. Особенно в сочетании с немного измененной версией удобного API из раздела «Использование дочерних контроллеров представления в качестве плагинов в Swift», теперь мы можем легко добавить предварительно настроенный контроллер представления загрузки при выполнении асинхронной операции:*/

fileprivate class ProductListViewController: UIViewController {
    func loadProducts() {
        let loadingVC: UIViewController = self.add(.loading)
        self.load {
            loadingVC.remove()
        }
    }

    private func load(then: () -> Void) {

    }
}

fileprivate extension UIViewController {
    func add(_ child: UIViewController) -> UIViewController {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
        return child
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
