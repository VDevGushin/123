//
//  Delegation.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 21/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Шаблон делегатов долгое время был очень заметен на платформах Apple. Делегирование используется для всего: от обработки событий табличного представления с использованием UITableViewDelegate до изменения поведения кэша с использованием NSCacheDelegate. Основная цель шаблона делегата состоит в том, чтобы позволить объекту обмениваться данными обратно с его владельцем в отсоединенном виде. Не требуя, чтобы объект знал конкретный тип своего владельца, мы можем написать код, который намного проще использовать и поддерживать.
 
 Так же, как шаблон наблюдателя, который мы рассмотрели в последних двух постах, шаблон делегата может быть реализован многими различными способами. На этой неделе давайте рассмотрим некоторые из этих способов, а также их плюсы и минусы.
 
 Когда делегировать
 
 Основное преимущество делегирования определенных решений и поведения владельцу типа состоит в том, что становится намного проще поддерживать множественные варианты использования без необходимости создавать массивные типы, которые сами должны учитывать все эти варианты использования.
 
 Взять, к примеру, UITableView или UICollectionView. Оба чрезвычайно универсальны с точки зрения того, как и что они делают. Используя делегирование, мы легко можем обрабатывать события, решать, как должны создаваться ячейки, и настраивать атрибуты макета - и все это не нужно знать ни одному классу о нашей конкретной логике.
 
 Делегирование обычно является хорошим выбором, когда тип должен использоваться в разных контекстах, и когда у него есть явный владелец во всех этих контекстах - точно так же, как UITableView часто принадлежит представлению родительского контейнера или его контроллеру представления. В отличие от наблюдаемого типа, тип, использующий делегирование, взаимодействует только с одним владельцем, устанавливая связь между ними 1: 1.*/

// MARK: - Protocols
/*Наиболее распространенный способ делегирования, который можно найти в собственных API Apple, - это использование протоколов делегирования. Точно так же, как UITableView имеет протокол UITableViewDelegate, мы также можем настроить наши собственные типы аналогичным образом - например, как мы здесь определяем протокол FileImporterDelegate для класса FileImporter:*/

fileprivate struct File { }

fileprivate protocol FileImporterDelegate: AnyObject {
    func fileImporter(_ importer: FileImporter,
                      shouldImportFile file: File) -> Bool

    func fileImporter(_ importer: FileImporter,
                      didAbortWithError error: Error)

    func fileImporterDidFinish(_ importer: FileImporter)
}

fileprivate class FileImporter {
    weak var delegate: FileImporterDelegate?
}

/*При реализации наших собственных протоколов делегатов, как правило, хорошей идеей является попытка следовать соглашениям об именах, которые были установлены благодаря собственному использованию Apple этого шаблона. Несколько быстрых рекомендаций, о которых стоит помнить:
 
 1) Чтобы прояснить, что метод действительно является методом делегата, обычной практикой является начинать имя метода с имени делегируемого типа - например, как каждый метод, начинающийся выше, начинается с fileImporter.
 2) Первым аргументом метода делегата в идеале должен быть сам делегирующий объект. Это позволяет объекту, которому принадлежит несколько экземпляров, различать их при обработке событий.
 3) При делегировании важно не пропускать детали реализации делегату. Например, при обработке нажатия кнопки может показаться полезным передать саму кнопку методу делегата, но если эта кнопка является частным подпредставлением, она на самом деле не принадлежит общедоступному API.
 
 Преимущество использования протокола на основе протокола состоит в том, что это установленный шаблон, с которым знакомо большинство разработчиков Swift. Он также группирует все события, которые тип (в данном случае FileImporter) может генерировать в один протокол, и компилятор выдаст нам ошибки в случае, если что-то будет неправильно реализовано.
 
 Однако этот подход также имеет некоторые недостатки. Самый очевидный пример в нашем примере FileImporter выше - это то, что использование протоколов делегатов может стать источником неоднозначного состояния. Обратите внимание, как мы делегируем решение о том, импортировать ли данный файл делегату, но поскольку назначение делегата является необязательным, решить, что делать, если делегат отсутствует, может быть немного сложно:
*/
fileprivate extension FileImporter {
    func processFileIfNeeded(_ file: File) {
        guard let delegate = self.delegate else { return }

        let shouldImport = delegate.fileImporter(self, shouldImportFile: file)

        guard shouldImport else { return }

        process(file)
    }

    private func process(_ file: File) { }
}

// MARK: - Closures
/*Один из способов сделать приведенный выше код более предсказуемым - это реорганизовать часть процесса принятия решений в нашем протоколе делегата, чтобы вместо него использовать замыкание. Таким образом, наш пользователь API должен будет указать логику, используемую, чтобы решить, какие файлы будут импортированы заранее, удаляя неоднозначность в логике нашего импортера файлов:*/
fileprivate class FileImporterWithClosures {
    private let predicate: (File) -> Bool

    init(predicate: @escaping (File) -> Bool) {
        self.predicate = predicate
    }

    private func processFileIfNeeded(_ file: File) {
        let shouldImport = predicate(file)

        guard shouldImport else {
            return
        }

        process(file)
    }

    private func process(_ file: File) { }
}
/*Основным преимуществом вышеизложенного является то, что теперь становится намного сложнее использовать наш класс FileImporter «неправильным путем», поскольку теперь его использование полностью допустимо без назначения делегата (что в этом случае может быть полезно в случае, если некоторые файлы должны быть импортированы в фоновом режиме, и мы не очень заинтересованы в результате операции).*/

// MARK: - Configuration types
/*Допустим, мы хотели бы продолжить преобразование остальных методов делегатов в замыкания. Один из способов сделать это - просто продолжить добавление замыканий в качестве аргументов инициализатора или изменяемых свойств. Однако при этом наш API может стать немного запутанным - и может быть трудно различить параметры конфигурации и другие типы свойств.
 
 Одним из способов решения этой дилеммы является использование выделенного типа конфигурации. Таким образом, мы можем добиться такой же хорошей группировки событий, как и в случае с нашим оригинальным протоколом делегатов, и при этом предоставить большую свободу при реализации различных событий. Мы будем использовать структуру для нашего типа конфигурации и добавим свойства для каждого события, например:*/

fileprivate struct FileImporterConfiguration {
    var predicate: (File) -> Bool
    var errorHandler: (Error) -> Void
    var completionHandler: () -> Void
}

/*Использование вышеупомянутого подхода к делегированию также дает приятное бонусное преимущество - становится очень просто определять удобные API для различных распространенных конфигураций FileImporter. Например, мы можем добавить удобный инициализатор в FileImportConfiguration, который принимает только предикат, что упрощает создание импортера типа «запусти и забудь»:*/
fileprivate extension FileImporterConfiguration {
    init(predicate: @escaping (File) -> Bool) {
        self.predicate = predicate
        errorHandler = { _ in }
        completionHandler = { }
    }
}

/*Мы можем даже создать статические вспомогательные API для общих конфигураций, которые не требуют каких-либо параметров, например, вариант, который просто импортирует все файлы:*/
fileprivate extension FileImporterConfiguration {
    static var importAll: FileImporterConfiguration {
        return .init { _ in true }
    }
}

fileprivate class FileImporterWithConfiguration {
    private let configuration: FileImporterConfiguration

    init(configuration: FileImporterConfiguration) {
        self.configuration = configuration
    }

    private func processFileIfNeeded(_ file: File) {
        guard configuration.predicate(file) else {
            return
        }

        process(file)
    }

    private func process(_ file: File) { }

    private func handle(_ error: Error) {
        configuration.errorHandler(error)
    }

    private func importDidFinish() {
        configuration.completionHandler()
    }
}

// MARK: - Using all
fileprivate class TestAll: FileImporterDelegate {
    func testAll() {
        //Использование делегатов
        let f = FileImporter()
        f.delegate = self
        dump(f)
        
        //Использование замыкания
        let fc = FileImporterWithClosures { file in
            return false
        }
        dump(fc)

        //Использование конфигуратора
        let fC = FileImporterWithConfiguration(configuration: .importAll)
        dump(fC)
    }

    func fileImporter(_ importer: FileImporter, shouldImportFile file: File) -> Bool {
        return true
    }

    func fileImporter(_ importer: FileImporter, didAbortWithError error: Error) {

    }

    func fileImporterDidFinish(_ importer: FileImporter) {

    }
}
