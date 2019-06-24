//
//  Configurable types in Swift.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 24/06/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*
 Когда мы начинаем писать новый класс, структуру или другой тип, мы чаще всего имеем в виду очень конкретную цель или вариант использования. Нам может понадобиться новая модель для представления некоторых данных, с которыми мы работаем, или нам может потребоваться инкапсулировать часть логики, адаптированную для новой функции, которую мы создаем.
 
 Однако со временем мы часто хотим использовать очень похожую версию того же типа или логики, но для чего-то совершенно другого. Мы могли бы хотеть повторно использовать существующую модель, но обрабатывать ее немного по-другому - или мы могли бы искать решение, которое очень похоже на то, что мы уже решили, но с другим типом результата.
 
 Тогда возникает вопрос - как взять наш существующий код и реорганизовать его, чтобы сделать его более универсальным и пригодным для повторного использования - не заканчивая чем-то грязным или несфокусированным. На этой неделе давайте взглянем на технику, которая делает именно это - она включает в себя настройку определенных типов.
 */

/*Изначально конкретный
 
 Нет ничего плохого в том, чтобы писать код, специфичный для отдельного варианта использования - на самом деле можно с уверенностью утверждать, что именно так должен создаваться более или менее исходный код - чтобы решить очень реальный вариант использования самым простым способом.
 
 Допустим, мы работаем над приложением для создания заметок и хотим добавить функцию, позволяющую пользователю импортировать набор внешних заметок из группы текстовых файлов, содержащихся в папке. Для первоначальной версии этой функции мы решили, что будем обрабатывать только заметки, которые являются либо простыми текстовыми файлами, либо отформатированы с использованием Markdown - поэтому мы пишем нашу первую реализацию с учетом только этих двух вариантов использования, как это :*/

fileprivate struct Folder {
    var files: [File]
}

fileprivate struct File {
    var `extension`: String
}

fileprivate struct Note { }

fileprivate struct NoteImporter {
    func importNotes(from folder: Folder) throws -> [Note] {
        // Iterate over all the files contained within the
        // folder, and only handle the ones that have an
        // extension matching what we're supporting for now:
        return try folder.files.compactMap { file in
            switch file.extension {
            case "txt":
                return try importPlainTextNote(from: file)
            case "md", "markdown":
                return try importMarkdownNote(from: file)
            default:
                return nil
            }
        }
    }

    fileprivate func importPlainTextNote(from: File)throws -> Note? { return nil }
    fileprivate func importMarkdownNote(from: File)throws -> Note? { return nil }
}

/*В качестве начальной реализации, вышеупомянутое, скорее всего, достаточно хорошо. Однако, поскольку мы будем продолжать поддерживать все больше и больше текстовых форматов, нам всегда нужно возвращаться и изменять основную логику нашего вышеупомянутого NoteImporter - что не очень хорошо с точки зрения гибкости.
 
 В идеале нам бы хотелось, чтобы NoteImporter просто беспокоился о задаче организации реального импорта, а не привязывался к очень конкретным форматам файлов - в противном случае приведенный выше оператор switch более или менее гарантированно выйдет из-под контроля, рано или поздно ,
 
 За исключением различных форматов файлов, допустим, что в следующий раз мы хотим добавить поддержку для аудиозаписей, одновременно предоставляя пользователю возможность использовать ту же функцию импорта для переноса своих существующих аудиофайлов в наше приложение. Несмотря на то, что мы это делаем, было бы неплохо, если бы пользователь мог импортировать фотографии - и, возможно, другие виды мультимедиа.
 
 С нашей текущей настройкой каждый новый вид импорта требует совершенно новой реализации - предоставляя нам группу различных типов, которые все выполняют очень похожие задачи, используя очень похожие API:*/
fileprivate struct Audio { }
fileprivate struct Photo { }

fileprivate struct AudioImporter {
    func importAudio(from folder: Folder) throws -> [Audio] {
        return []
    }
}

fileprivate struct PhotoImporter {
    func importPhotos(from folder: Folder) throws -> [Photo] {
        return []
    }
}

/*Хотя наличие разных реализаций для разных вариантов использования в некотором смысле является хорошей вещью - это разделяет проблемы и позволяет нам оптимизировать каждый тип для каждого конкретного варианта использования. Однако без какой-либо общей абстракции или общего API мы также упускаем тонну потенциального повторного использования кода - и мы затрудняем написание общих API для любого типа средства импорта файлов.*/

/*Time for some protocol-oriented programming?
 
 Первоначальной идеей решения этой проблемы может быть использование протокольно-ориентированного подхода - и создание протокола, которому могут соответствовать все наши различные импортеры файлов:*/

fileprivate protocol FileImporting {
    associatedtype Result
    func importFiles(from folder: Folder) throws -> [Result]
}

/*Используя вышесказанное, мы могли бы позволить каждому типу импортера оставаться отдельным, при этом все они соответствовали одному и тому же протоколу - предоставляя нам общий и согласованный API, и в то же время позволяя каждому типу импортера быть адаптированным для каждого варианта использования:*/

extension AudioImporter: FileImporting {
    typealias Result = Audio

    func importFiles(from folder: Folder) throws -> [Audio] {
        return []
    }
}
extension PhotoImporter: FileImporting {
    typealias Result = Photo

    func importFiles(from folder: Folder) throws -> [Photo] {
        return []
    }
}

/*Настраиваемые типы

 Вместо создания абстракции с несколькими реализациями, давайте попробуем создать один тип FileImporter, который мы сделаем достаточно настраиваемым, чтобы его можно было использовать для всех наших текущих (и, надеюсь, будущих) вариантов использования.
 
 Поскольку единственная логика, которая на самом деле отличается между нашими различными импортерами файлов, заключается в том, как обрабатывается каждый файл, давайте сделаем только эту часть настраиваемой - используя ту же реализацию для всего остального. В этом случае мы могли бы сделать это, создав структуру, которая содержит словарь обработчиков в качестве единственного свойства:*/

fileprivate struct UniversalFileImporter<Result> {
    typealias FileType = String

    var handlers: [FileType: (File) throws -> Result]
}

extension UniversalFileImporter {
    func importFiles(from folder: Folder) throws -> [Result] {
        return try folder.files.compactMap { file in
            guard let handler = handlers[file.extension] else { return nil }
            return try handler(file)
        }
    }
}

/*С учетом вышесказанного мы имеем гораздо более общую реализацию, которая затем может быть специализирована для решения конкретных случаев использования. Но мы бы не хотели, чтобы на каждом сайте вызовов приходилось вручную указывать все обработчики (что быстро приведет к куче несоответствий), поэтому мы будем специализироваться на общих статических фабричных методах. Таким образом, мы можем создать фабричный метод для каждого конкретного вида импорта - например, для заметок:
*/

extension UniversalFileImporter where Result == Note {
    static func notes() -> UniversalFileImporter {
        return UniversalFileImporter(handlers: [
            "txt": importPlainTextNote,
            "text": importPlainTextNote,
            "md": importMarkdownNote,
            "markdown": importMarkdownNote
            ])
    }

    private static func importPlainTextNote(from file: File) throws -> Note {
        return Note()
    }

    private static func importMarkdownNote(from file: File) throws -> Note {
        return Note()
    }
}

extension UniversalFileImporter where Result == Audio {
    static func audio(includeOggFiles: Bool) -> UniversalFileImporter {
        var handlers = [
            "mp3": importMp3Audio,
            "aac": importAacAudio
        ]

        if includeOggFiles {
            handlers["ogg"] = importOggAudio
        }

        return UniversalFileImporter(handlers: handlers)
    }
    
    private static func importOggAudio(from file: File) throws -> Audio {
        return Audio()
    }
    
    private static func importMp3Audio(from file: File) throws -> Audio {
        return Audio()
    }
    
    private static func importAacAudio(from file: File) throws -> Audio {
        return Audio()
    }
}
