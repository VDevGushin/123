//
//  SubclassFreeViewControllers.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 18/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

/*
 Рассмотрим несколько различных методов, которые могут помочь нам написать контроллеры представления без подклассов, и как это может помочь нам избежать проблемы Massive View Controller.
 */

// MARK: - Custom root views
/*
 Например, допустим, мы строим детальный вид для некоторой формы события. Очень распространенным решением было бы создать EventDetailsViewController, дать ему инициализатор, который принимает модель Event, и заставить контроллер представления создать необходимый нам пользовательский интерфейс, например:
 */

fileprivate struct Event {
    let title: String
    let location: String
    let image: UIImage
}

fileprivate class EventDetailViewController: UIViewController {
    private let event: Event
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = UILabel()
        let _ = UILabel()
        let _ = UIImageView()
    }
}

/*Хотя в этом подходе нет ничего плохого, но если все, что EventDetailsViewController делает, это конфигурировать и настраивать подпредставления, возможно, было бы более уместно, чтобы он был просто представлением. Перемещая наш код представления из контроллеров представления в простые представления, мы также можем помочь себе избежать многих ловушек, приводящих к массовым контроллерам представления - например, когда контроллеры представления начинают заполняться всем - от кода макета до создания подпредставления, до привязка данных и не только.
 
 В этом случае мы создадим EventDetailsView и переместим в него весь наш код подробного представления событий:*/

fileprivate class EventDetailsView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let imageView = UIImageView()
}

fileprivate func test() {
    let vc = UIViewController()
    vc.view = EventDetailsView()
    let _ = UINavigationController(rootViewController: vc)
}

// MARK: - Factory methods
/*
 Перемещение нашего кода представления из подкласса UIViewController в подкласс UIView может показаться не таким уж большим делом. Но этот подход начинает становиться все более мощным, когда мы начинаем объединять его с другими шаблонами, которые позволяют нам улучшить инкапсуляцию нашего кода.
 
 Одним из таких шаблонов является шаблон Factory, который мы рассмотрели ранее как способ избежать общего состояния и как способ статического создания объектов. Когда мы имеем дело с более простыми пользовательскими интерфейсами, которые довольно статичны и не требуют тонны взаимодействий, фабричный шаблон также может быть действительно хорошим способом инкапсулировать создание контроллеров представления, которые просто действуют как контейнеры для пользовательского представления.
 
 Здесь мы создаем EventViewControllerFactory, который позволяет абстрагировать создание нашего EventDetailsView и привязку его данных в один простой в использовании API:*/

fileprivate class EventViewControllerFactory {
    func makeDetailViewContoller(for event: Event) -> UIViewController {
        let view = EventDetailsView()
        view.titleLabel.text = event.title
        view.subtitleLabel.text = event.location
        view.imageView.image = event.image

        let vc = UIViewController()
        vc.view = view
        return vc
    }
}
/*
 Прелесть вышеупомянутого подхода в том, что становится гораздо менее вероятным, что мы в конечном итоге будем использовать EventDetailsView «неправильным путем». Абстрагируя не только его создание, но и его представление, мы можем гораздо легче убедиться, что он будет представлен последовательно во всей нашей кодовой базе.
 
 Мы рассмотрим более подробно различные варианты шаблона презентатора (и шаблоны дизайна, способствующие его использованию) в будущих публикациях.
 */

// MARK: - The declarative nature of Auto Layout
/*
 let vc = UIViewController()
 
 let headerView = EventHeaderView()
 headerView.translatesAutoresizingMaskIntoConstraints = false
 vc.view.addSubview(headerView)
 
 let detailView = EventDetailsView()
 detailView.translatesAutoresizingMaskIntoConstraints = false
 vc.view.addSubview(detailView)
 
 NSLayoutConstraint.activate([
 headerView.topAnchor.constraint(equalTo: vc.view.topAnchor),
 headerView.widthAnchor.constraint(equalTo: vc.view.widthAnchor),
 headerView.heightAnchor.constraint(equalTo: vc.view.heightAnchor, multiplier: 0.3),
 detailView.widthAnchor.constraint(equalTo: vc.view.widthAnchor),
 detailView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
 detailView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
 ])
 */
