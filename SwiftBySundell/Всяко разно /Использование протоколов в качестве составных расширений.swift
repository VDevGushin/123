//
//  Использование протоколов в качестве составных расширений.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 14/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
/*Сегодня мы поговорим об использовании протоколов в качестве составных частей для наших контроллеров ViewController. Протоколы и расширения протокола - моя вторая любимая функция Swift после Optionals. Это помогает нам создавать кодируемую и многократно используемую кодовую базу без наследования. В течение многих лет мы использовали наследование как золотой стандарт программирования. Но так ли это хорошо? Давайте рассмотрим простой BaseViewController, который мы использовали в каждом проекте.*/

class BaseViewController1: UIViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    func presenActivity() {
        activityIndicator.startAnimating()
    }

    func dismissActivity() {
        activityIndicator.stopAnimating()
    }

    func present(_ error: Error) {
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
/*Это выглядит просто и удобно, потому что большинству наших ViewControllers нужен индикатор активности при загрузке данных из Интернета и обработке ошибок на случай, если во время загрузки данных что-то пойдет не так. Но мы не останавливаемся на этом и со временем добавляем больше функций в BaseViewController. Это начинает вздутие живота с большим количеством функций общего назначения. Здесь у нас есть как минимум две основные проблемы:
 
 Наш BaseViewController нарушает принцип единой ответственности, реализуя все эти функции в одном месте. Со временем он превратится в Massive-View-Controller, который сложно понять и покрыть тестами.
 Каждый ViewController в нашем приложении наследуется от BaseViewController, чтобы использовать все эти функции. В случае ошибки в BaseViewController, мы будем иметь эту ошибку во всех ViewController в нашем приложении, даже если ViewController не использует ошибочную функциональность из BaseViewController.*/

// MARK: - Protocols for the rescue
/*Функция «Расширения протокола» была выпущена в Swift 2.0 и обеспечивает реальную мощь для типов протоколов, которые объявляют новую парадигму программирования: протоколно-ориентированное программирование. Я рекомендую вам посмотреть доклад WWDC о протоколах и расширениях протоколов.
 Давайте вернемся к нашей теме. Как протоколы могут помочь нам? Давайте начнем с объявления ActivityPresentable Protocol для представления и отклонения индикатора активности.
*/
fileprivate protocol ActivityPresentable {
    func presentActivity()
    func dismissActivity()
}

fileprivate extension ActivityPresentable where Self: UIViewController {
    func presentActivity() {
        if let activityIndicator = findActivity() {
            activityIndicator.startAnimating()
        } else {
            let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            activityIndicator.startAnimating()
            view.addSubview(activityIndicator)

            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
            ])
        }
    }

    func dismissActivity() {
        findActivity()?.stopAnimating()
    }

    func findActivity() -> UIActivityIndicatorView? {
        return view.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
    }
}

fileprivate protocol ErrorPresentable {
    func present(_ error: Error)
}

fileprivate extension ErrorPresentable where Self: UIViewController {
    func present(_ error: Error) {
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}


// MARK: - Using
class ResultViewController: UIViewController, ActivityPresentable, ErrorPresentable {
    override func viewDidLoad() {
        super.viewDidLoad()
        presentActivity()
    }
}


class CustomViewController: UIViewController, ActivityPresentable, ErrorPresentable {
    override func viewDidLoad() {
        super.viewDidLoad()
        presentActivity()
    }

    func presentActivity() {
        // Custom activity presenting logic
    }

    func dismissActivity() {

    }
}
