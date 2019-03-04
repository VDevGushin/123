//
//  AdvancedUsage.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 01/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Alamofire

//Ждем обновления документации
// MARK: - Session Manager
fileprivate class SessionManagerTest: SessionDelegate {
    fileprivate func sessionManager() {
        /*Удобные методы верхнего уровня, такие как Alamofire.request, используют экземпляр Alamofire.SessionManager по умолчанию, который настроен с помощью URLSessionConfiguration по умолчанию.
     Таким образом, следующие два утверждения эквивалентны:*/

        _ = AF.request("https://httpbin.org/get")
        let sessionManager = Session.default
        _ = sessionManager.request("https://httpbin.org/get")

        /*Приложения могут создавать менеджеры сеансов для фоновых и промежуточных сеансов, а также новые менеджеры, которые настраивают конфигурацию сеансов по умолчанию, например, для заголовков по умолчанию (httpAdditionalHeaders) или интервала времени ожидания (timeoutIntervalForRequest).*/

        //Creating a Session Manager with Default Configuration
        /*Конфигурация сеанса по умолчанию использует постоянный дисковый кэш (кроме случаев, когда результат загружается в файл) и сохраняет учетные данные в цепочке для ключей пользователя. Он также сохраняет файлы cookie (по умолчанию) в том же общем хранилище файлов cookie, что и классы NSURLConnection и NSURLDownload.
         Заметка
         Если вы переносите код на основе класса NSURLConnection, используйте этот метод для получения объекта начальной конфигурации, а затем настройте этот объект по мере необходимости.
         Изменение возвращенного объекта конфигурации сеанса не влияет на объекты конфигурации, возвращаемые будущими вызовами этого метода, и не изменяет поведение по умолчанию для существующих сеансов. Поэтому всегда безопасно использовать возвращенный объект в качестве отправной точки для дополнительной настройки.*/
        let defaultConfiguration = URLSessionConfiguration.default
        let _ = Session.init(startRequestsImmediately: false, configuration: defaultConfiguration, delegate: self)

        //Creating a Session Manager with Background Configuration
        /*Используйте этот метод для инициализации объекта конфигурации, подходящего для передачи файлов данных, пока приложение работает в фоновом режиме. Сеанс, настроенный с этим объектом, передает управление переносами в систему, которая обрабатывает переносы в отдельном процессе. В iOS эта конфигурация позволяет продолжить передачу, даже если само приложение приостановлено или завершено.
         Если приложение iOS завершается системой и перезапускается, приложение может использовать тот же идентификатор для создания нового объекта конфигурации и сеанса, а также для получения статуса передач, которые выполнялись в момент завершения. Это поведение применяется только для нормального завершения приложения системой. Если пользователь закрывает приложение с экрана многозадачности, система отменяет все фоновые передачи сеанса. Кроме того, система не запускает автоматически приложения, которые были принудительно закрыты пользователем. Пользователь должен явно перезапустить приложение, прежде чем передача может начаться снова.
         Вы можете настроить фоновый сеанс для планирования передач по усмотрению системы для оптимальной производительности, используя свойство isDiscretionary. При передаче больших объемов данных рекомендуется установить для этого свойства значение true. Пример использования фоновой конфигурации см. В разделе «Загрузка файлов в фоновом режиме».*/
        let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "com.example.app.background")
        let _ = Session.init(startRequestsImmediately: false, configuration: backgroundConfiguration, delegate: self)

        //Creating a Session Manager with Ephemeral Configuration
        /*Эфемерный объект конфигурации сеанса аналогичен конфигурации сеанса по умолчанию (см. По умолчанию), за исключением того, что соответствующий объект сеанса не хранит кэши, хранилища учетных данных или любые связанные с сеансом данные на диске. Вместо этого данные, относящиеся к сеансу, хранятся в оперативной памяти. Единственный раз, когда эфемерный сеанс записывает данные на диск, это когда вы говорите ему записать содержимое URL в файл.
         Заметка
         Можно настроить объект конфигурации сеанса по умолчанию, чтобы получить то же поведение (или любую его часть), обеспечиваемое эфемерным объектом конфигурации сеанса, но использование этого способа более удобно. */
        let ephemeralConfiguration = URLSessionConfiguration.ephemeral
        let _ = Session.init(startRequestsImmediately: false, configuration: ephemeralConfiguration, delegate: self)

        //Modifying the Session Configuration
        var defaultHeaders = HTTPHeaders.default
        defaultHeaders["DNT"] = "1 (Do Not Track Enabled)"

        let config = URLSessionConfiguration.default
        config.httpHeaders = defaultHeaders
        let _ = Session.init(startRequestsImmediately: false, configuration: config, delegate: self)
    }
    
    // MARK: - Session delegate
}

// MARK: - Network Reachability
/*The NetworkReachabilityManager listens for reachability changes of hosts and addresses for both WWAN and WiFi network interfaces.*/
fileprivate func networkReachability() {
    let manager = NetworkReachabilityManager(host: "www.apple.com")
    manager?.listener = { status in
        print(status)
    }
    manager?.startListening()
}
/*Не забудьте сохранить менеджера в вышеприведенном примере, иначе об изменении статуса не будет сообщено. Кроме того, не включайте схему в строку хоста, иначе достижимость не будет работать правильно.
 НЕ используйте Reachability, чтобы определить, следует ли отправлять сетевой запрос.
 Вы должны ВСЕГДА отправить его.
 Когда Reachability восстанавливается, используйте событие, чтобы повторить неудачные сетевые запросы.
 Несмотря на то, что сетевые запросы все еще могут не работать, это хороший момент, чтобы повторить их.
 Статус достижимости сети может быть полезен для определения причины сбоя сетевого запроса.
 В случае сбоя сетевого запроса более полезно сообщить пользователю, что сетевой запрос не выполнен из-за отсутствия связи, а не из-за более технической ошибки, такой как «истекло время ожидания запроса».*/
