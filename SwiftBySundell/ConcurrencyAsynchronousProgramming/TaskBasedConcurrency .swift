//
//  TaskBasedConcurrency .swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 04/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
//MARK: - The task at hand
/*
 Допустим, мы создаем приложение для социальных сетей и предлагаем нашим пользователям возможность прикреплять фотографии и видео при публикации сообщения. В настоящее время всякий раз, когда пользователь нажимает «Опубликовать», мы вызываем следующую функцию, которая загружает все прикрепленные файлы, а также загружает данные для самого сообщения, например:
 */
fileprivate struct Post {
    var source: String
    var photos: [String]
    var videos: [String]
}

fileprivate struct PhotoPublish {
    func publish(new post: Post) {
        for photo in post.photos {
            self.upload(photo) { }
        }

        for video in post.videos {
            self.upload(video) { }
        }
    }

    func upload(_ resource: String, then handler: () -> Void) { }
    func upload(_ resource: String, then handler: (Error?) -> Void) { }
    func upload(_ post: Post) { }
    func handle(_ error: Error) { }
}

/*Хотя приведенный выше код очень прост, с ним есть несколько проблем. Во-первых, мы не можем получать уведомления о завершении публикации сообщения. Мы также не занимаемся обработкой ошибок, что означает, что если фото или видео не удалось загрузить - мы все равно будем продолжать загружать данные поста, что не идеально.
 
 Существует много способов решения вышеуказанной проблемы. Одна идея может состоять в том, чтобы использовать встроенные типы Operation и OperationQueue для последовательного выполнения всех операций, но для этого нам необходимо либо сделать наш фактический сетевой код синхронным, либо создать подкласс Operation для создания очень индивидуального решения. Обе эти альтернативы действительны, но могут показаться немного «жесткими», поскольку они потребуют довольно серьезных изменений в нашем исходном коде.
 
 К счастью, оказывается, что все, что нам нужно сделать, чтобы получить контроль, который нам нужен, это перейти на один уровень глубже в стек и использовать среду, на которой основаны Operation и OperationQueue - Grand Central Dispatch.
 
 Как мы уже видели в «Глубоком погружении в Grand Central Dispatch в Свифте», GCD позволяет нам довольно легко сгруппировать кучу операций и получать уведомления, когда все они завершены. Чтобы это произошло, мы немного изменим наши функции загрузки, чтобы они теперь предлагали нам наблюдать за их завершением с помощью замыкания и делать сбалансированные вызовы для входа и выхода из DispatchGroup, чтобы получить уведомление о завершении загрузки всех медиафайлов:*/
fileprivate extension PhotoPublish {
    func publish1(new post: Post) {
        let group = DispatchGroup()

        for photo in post.photos {
            group.enter()
            self.upload(photo) {
                group.leave()
            }
        }

        for video in post.videos {
            group.enter()
            self.upload(video) {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.upload(post)
        }
    }
}

/*Вышеописанное работает очень хорошо и оставляет нам довольно чистый код. Но мы до сих пор не решили проблему с обработкой ошибок - поскольку мы по-прежнему будем загружать сообщение вслепую, независимо от того, были ли успешно завершены загрузки медиафайлов.
 
 Чтобы исправить это, давайте добавим необязательную переменную Error, которую мы будем использовать для отслеживания любой произошедшей ошибки. Мы сделаем еще одну настройку для наших функций загрузки, чтобы они передавали необязательный аргумент Error своим обработчикам завершения и использовали его для записи первой обнаруженной ошибки - например, так:*/
fileprivate extension PhotoPublish {
    func publish2(new post: Post) {
        let group = DispatchGroup()
        var anyError: Error?
        for photo in post.photos {
            group.enter()
            self.upload(photo) { error in
                anyError = anyError ?? error
                group.leave()
            }
        }

        for video in post.videos {
            group.enter()
            self.upload(video) { error in
                anyError = anyError ?? error
                group.leave()
            }
        }

        group.notify(queue: .main) {
            if let error = anyError {
                return self.handle(error)
            }
            self.upload(post)
        }
    }
}
/*Теперь мы исправили все проблемы с корректностью с нашим оригинальным фрагментом кода, но в процессе этого мы также сделали его намного более сложным и трудным для чтения. Наше новое решение также является достаточно сложным (с локальной переменной и вызовами групп отправки, которые необходимо отслеживать), что может и не быть проблемой, но как только мы начнем перемещать больше нашего асинхронного кода для использования этот шаблон - вещи могут стать намного сложнее поддерживать довольно быстро.*/

// MARK: - It’s abstraction time!
/*Давайте посмотрим, сможем ли мы упростить работу с вышеуказанными операциями, введя тонкий, основанный на задачах уровень абстракции поверх Grand Central Dispatch.
 
 Мы начнем с создания типа с именем Task, который, по сути, будет просто оберткой вокруг замыкания, которая получит доступ к Controller для управления потоком задачи:*/

fileprivate struct Task {
    enum Outcome {
        case success
        case failure(Error)
    }

    struct Controller {
        fileprivate let queue: DispatchQueue
        fileprivate let handler: (Outcome) -> Void

        func finish() {
            handler(.success)
        }

        func fail(with error: Error) {
            handler(.failure(error))
        }
    }

    private let closure: (Controller) -> Void

    init(closure: @escaping (Controller) -> Void) {
        self.closure = closure
    }

    func perform(on queue: DispatchQueue = .global(), then handler: @escaping (Outcome) -> Void) {
        queue.async {
            let controller = Controller(
                queue: queue,
                handler: handler
            )
            self.closure(controller)
        }
    }
}

fileprivate extension Task {
    static func uploading(source: String, using uploader: Uploader) -> Task {
        return Task { controller in
            uploader.upload(url: source) { error in
                if let error = error {
                    controller.fail(with: error)
                } else {
                    controller.finish()
                }
            }
        }
    }
}

fileprivate struct Uploader {
    func upload(url: String, then handler: (Error?) -> Void) { }
}

fileprivate extension PhotoPublish {
    func publish3(new post: Post) {
        let uploader = Uploader()
        for photo in post.photos {
            let task = Task.uploading(source: photo, using: uploader)
            task.perform(on: .global()) { result in

            }
        }
    }
}

// MARK: - Grouping tasks
extension Task {
    static func group(_ tasks: [Task]) -> Task {
        return Task { controller in
            let group = DispatchGroup()
            var anyError: Error?

            for task in tasks {
                group.enter()
                // It’s important to make the sub-tasks execute
                // on the same DispatchQueue as the group, since
                // we might cause unexpected threading issues otherwise.
                task.perform(on: controller.queue) { outcome in
                    switch outcome {
                    case .success: break
                    case .failure(let error):
                        anyError = anyError ?? error
                    }
                    group.leave()
                }
            }

            group.notify(queue: controller.queue) {
                if let error = anyError {
                    controller.fail(with: error)
                } else {
                    controller.finish()
                }
            }
        }
    }
}


fileprivate extension PhotoPublish {
    func publish4(new post: Post) {
        let uploader = Uploader()
        let photoTasks = post.photos.map {
            return Task.uploading(source: $0, using: uploader)
        }
        let group = Task.group(photoTasks)
        group.perform { result in
            switch result {
            case .failure: break
            case .success: break
            }
        }
    }
}

// MARK: - Sequencing
/*Вместо того чтобы использовать DispatchGroup (которая не имеет никакого мнения о порядке наших операций), давайте реализуем последовательность, отслеживая индекс текущей задачи и затем непрерывно выполняем следующую задачу после ее завершения. Как только мы достигнем конца нашего списка задач, мы будем считать последовательность завершенной:*/
extension Task {
    static func sequence(_ tasks: [Task]) -> Task {
        var index = 0
        func performNext(using contorller: Controller) {
            guard index < tasks.count else {
                // We’ve reached the end of our array of tasks,
                // time to finish the sequence.
                return contorller.finish()
            }
            let task = tasks[index]
            index += 1

            task.perform(on: contorller.queue) { outcome in
                switch outcome {
                case .success:
                    performNext(using: contorller)
                case .failure(let error):
                    contorller.fail(with: error)
                }
            }

        }

        return Task(closure: performNext)
    }
}
/*
Причина, по которой мы не просто используем последовательную DispatchQueue для реализации последовательности, заключается в том, что мы не можем предполагать, что наша последовательность всегда будет отправляться в последовательную очередь - пользователь API может выбрать ее выполнение в любой очереди.
 
 Выше мы используем тот факт, что Swift поддерживает как функции первого класса, так и определения встроенных функций - поскольку мы передаем нашу функцию executeNext как замыкание для создания Задачи для нашей последовательности.
 
 И это все - хотите верьте, хотите нет, но мы фактически только что создали полную систему параллелизма на основе задач - с нуля! */
fileprivate extension PhotoPublish {
    func publish5(new post: Post) {
        let uploader = Uploader()

        let photoTasks = post.photos.map {
            return Task.uploading(source: $0, using: uploader)
        }

        let videoTasks = post.videos.map { video in
            return Task.uploading(source: video, using: uploader)
        }

        let sequence = Task.sequence([.group(photoTasks + videoTasks), .uploading(source: post.source, using: uploader)])

        sequence.perform { result in
            switch result {
            case .failure: break
            case .success: break
            }
        }
    }
}

//Попытка сделать универсальную задачу
fileprivate enum Result<T> {
    case success(T)
    case failure(Error)
}

fileprivate struct UniversalTask<T> {
    typealias Outcome = Result<T>

    struct Controller {
        fileprivate let queue: DispatchQueue
        fileprivate let handler: (Outcome) -> Void

        func finish(with value: T) {
            handler(Outcome.success(value))
        }

        func fail(with error: Error) {
            handler(.failure(error))
        }
    }

    private let closure: (Controller) -> Void

    init(closure: @escaping (Controller) -> Void) {
        self.closure = closure
    }

    func perform(on queue: DispatchQueue = .global(), then handler: @escaping (Outcome) -> Void) {
        queue.async {
            let controller = Controller(
                queue: queue,
                handler: handler
            )
            self.closure(controller)
        }
    }
}

fileprivate class TestUploader {
    func upload(url: String, then handler: (Result<Data>) -> Void) {

    }
}

fileprivate extension UniversalTask {
    static func uploading(source: String, using uploader: TestUploader) -> UniversalTask<Data> {
        return UniversalTask<Data> { controller in
            uploader.upload(url: source) { result in
                switch result {
                case .failure(let error):
                    controller.fail(with: error)
                case .success(let data):
                    controller.finish(with: data)
                }
            }
        }
    }
}


fileprivate extension PhotoPublish {
    func publishMyWork(new post: Post) {
        let uploader = TestUploader()
        for photo in post.photos {
            let task = UniversalTask<Data>.uploading(source: photo, using: uploader)
            task.perform(on: .global()) { result in
                switch result {
                case .failure(let error): dump(error)
                case .success(let data): dump(data)
                }
            }
        }
    }
}
