//
//  Rule-based logic in Swift.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 30/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

/*Размышляя об архитектуре кода или проектировании системы, довольно легко думать только о общей картине, всеобъемлющих концепциях и абстракциях, которые использует база кода, например, о том, используем ли мы модели представлений, логические контроллеры или презентаторы, и то, как общаться между нашей основной логикой и нашим пользовательским интерфейсом.
 
 Однако, хотя эти более масштабные концепции невероятно важны, мы также часто можем оказывать большое влияние на общую структуру и качество нашей кодовой базы, улучшая некоторые более локальные и второстепенные детали. Как структурированы отдельные функции, как мы принимаем локальные решения в рамках типа или функции, и насколько связаны или разъединены наши различные кусочки логики?
 
 На этой неделе давайте рассмотрим один метод для выполнения таких локальных улучшений путем реорганизации больших функций в выделенные системы на основе правил - и как это может также привести к повышению как ясности, так и качества в более широком масштабе.*/

// MARK: - Handling events

/*Единственное, что объединяет почти все современные приложения, особенно те, которые работают на все более совершенных операционных системах - таких как iOS и macOS, - это то, что им приходится обрабатывать различные виды событий. Мы не только должны обрабатывать пользовательский ввод и изменения данных или состояния, но и реагировать на различные системные события - от поворота устройства до push-уведомлений, глубокого связывания и т. Д.
 
 Давайте рассмотрим пример такой обработки событий, когда мы отвечаем на запрос системы, чтобы наше приложение открывало данный URL, используя тип URLHandler. В качестве примера, скажем, мы создаем музыкальное приложение, которое работает с исполнителями, альбомами, а также с профилями пользователей - поэтому наш код обработки URL-адресов может выглядеть примерно так:
*/

fileprivate class ProfileViewController: UIViewController {
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class AlbumViewController: UIViewController {
    init(albumID: Int) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class Album {
    static func ID(_ urlPath: String) -> Int { return 0 }
}

fileprivate struct URLHandler {
    let navigationController: UINavigationController

    func handle(_ url: URL) {
        // Verify that the passed URL is something we can handle:
        guard url.scheme == "music-app", !url.pathComponents.isEmpty, let host = url.host else {
            return
        }

        // Route to the appropriate view controller, depending on
        // the initial component (or host) of the URL:
        switch host {
        case "profile":
            let username = url.pathComponents[0]
            let vc = ProfileViewController(username: username)
            navigationController.pushViewController(vc, animated: true)
        case "album":
            let id = Album.ID(url.pathComponents[0])
            let vc = AlbumViewController(albumID: id)
            navigationController.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

/*Приведенный выше код работает, но с архитектурной точки зрения у него есть некоторые проблемы. Прежде всего, поскольку наш URLHandler в настоящее время непосредственно отвечает за создание контроллеров представления для всех функций нашего приложения, ему необходимо знать много о всевозможных деталях, которые выходят далеко за рамки обработки URL. Например, ему нужно знать, как анализировать идентификаторы, какие аргументы принимают различные контроллеры представления и так далее.
 
 Мало того, что это делает наш код сильно связанным - что, скорее всего, сделает задачи, такие как рефакторинг, намного сложнее, чем нужно, - это также требует, чтобы вышеописанный метод handle был довольно массивным, и почти гарантированно будет продолжать расти по мере добавления новые функции или возможности глубоких ссылок на наше приложение.*/

// MARK: - Following the rules

/*Вместо того чтобы помещать весь наш код обработки URL-адресов в один метод или тип, давайте посмотрим, сможем ли мы реорганизовать его, чтобы он стал немного более разделенным. Если мы подумаем об этом, когда речь заходит о таких задачах, как обработка URL (или любой другой вид кода обработки событий), мы чаще всего оцениваем набор предопределенных правил, чтобы сопоставить событие, которое произошло с набором логика для выполнения.
 
 Давайте примем это, чтобы увидеть, что произойдет, если мы на самом деле смоделируем наш код как явные правила. Мы начнем с типа правила - назовем его URLRule - и добавим свойства для информации, которая нам потребуется для оценки правила в контексте обработки URL:*/

fileprivate struct URLRule {
    /// The host name that the rule requires in order to be evaluated.
    var requiredHost: String
    /// Whether the URL's path components array needs to be non-empty.
    var requiresPathComponents: Bool
    /// The body of the rule, which takes a set of input, and either
    /// produces a view controller, or throws an error.
    var evaluate: (Input) throws -> UIViewController
}

extension URLRule {

    struct Input {
        var url: URL
        var pathComponents: [String]
        var queryItems: [URLQueryItem]
    }
}


