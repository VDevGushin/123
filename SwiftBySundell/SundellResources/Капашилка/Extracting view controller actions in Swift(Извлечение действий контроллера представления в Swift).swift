//
//  Extracting view controller actions in Swift(Извлечение действий контроллера представления в Swift).swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 20/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
/*Контроллеры представлений, как правило, играют центральную роль в большинстве приложений, созданных для платформ Apple. Они управляют ключевыми аспектами нашего пользовательского интерфейса, обеспечивают мост к функциональным возможностям системы, таким как ориентация устройства и внешний вид строки состояния, и часто реагируют на взаимодействие с пользователем, например нажатие кнопок и ввод текста.
 
 Поскольку они обычно играют такую ​​ключевую роль, поэтому неудивительно, что многие контроллеры представлений страдают от общей проблемы Massive View Controller - когда они в итоге берут на себя слишком много обязанностей, что приводит к множеству переплетенных логик, часто смешанных с представлением и макет кода.
 
 Хотя на этой неделе мы уже исследовали несколько способов смягчения и разрушения контроллеров больших представлений, таких как использование композиции, перемещение кода навигации к выделенным типам, повторное использование источников данных и использование логических контроллеров, давайте рассмотрим методику это позволяет нам извлекать основные действия наших контроллеров представления, не вводя никаких дополнительных абстракций или архитектурных концепций.*/

/*Допустим, мы создаем представление композитора для приложения обмена сообщениями, и чтобы
1) иметь возможность добавлять получателей из контактов пользователя
2) разрешать отправку сообщений,
3) мы предоставляем нашему контроллеру представления прямой доступ к нашей базе данных и сетевому коду.
*/

fileprivate struct Message {
    var text: String = ""
    var recipients: [Recipient] = []
    init(recipients: [Recipient]) { }
}
fileprivate struct MessageSender {
    init(networking: Networking) { }
    func send(_ message: Message, error closure: (Error?) -> Void) { }
}
fileprivate struct UserDatabase { }
fileprivate struct Networking { }
fileprivate struct Recipient { }
fileprivate struct RecipientPicker {
    init(database: UserDatabase) { }
    func present(in: BaseMessageVC, then closure: (Recipient) -> Void) { }
}

fileprivate class BaseMessageVC { }

fileprivate class MessageComposerViewController: BaseMessageVC {
    private var message: Message
    private let userDatabase: UserDatabase
    private let networking: Networking

    init(recipients: [Recipient],
        userDatabase: UserDatabase,
        networking: Networking) {
        self.message = Message(recipients: recipients)
        self.userDatabase = userDatabase
        self.networking = networking
        //super.init(nibName: nil, bundle: nil)
    }

    func renderRecipientsView() { }
    func dismiss() { }
    func dismissAfterAskingForConfirmation() { }
    func display(_ error: Error) { }
}

/*Вышеприведенное может показаться не таким уж большим делом - мы используем внедрение зависимостей, и не похоже, что у нашего контроллера представления есть большое количество зависимостей. Однако, хотя наш контроллер представления еще не превратился в массовый, у него действительно есть довольно много действий, которые он должен выполнить - таких как добавление получателей, отмена и отправка сообщений - все из которых он в настоящее время выполняет свой собственный:
*/

private extension MessageComposerViewController {
    func handleAddRecipientButtonTap() {
        let picker = RecipientPicker(database: userDatabase)

        picker.present(in: self) { [weak self] recipient in
            self?.message.recipients.append(recipient)
            self?.renderRecipientsView()
        }
    }

    func handleCancelButtonTap() {
        if self.message.text.isEmpty {
            self.dismiss()
        } else {
            self.dismissAfterAskingForConfirmation()
        }
    }

    func handleSendButtonTap() {
        let sender = MessageSender(networking: networking)

        sender.send(message) { [weak self] error in
            if let error = error {
                self?.display(error)
            } else {
                self?.dismiss()
            }
        }
    }
}

/*Наличие контроллеров представления для выполнения их собственных действий может быть очень удобным, и для более простых контроллеров представления это, скорее всего, не вызовет никаких проблем - но, как мы можем видеть, просто взглянув на приведенную выше выдержку из MessageComposerViewController, часто требуется, чтобы наши контроллеры представления были знать о вещах, которые они в идеале не должны быть слишком обеспокоены - таких как сети, создание логических объектов и предположения о том, как они представлены их родителем.
 
 Поскольку большинство контроллеров представлений уже достаточно заняты такими вещами, как создание и управление представлениями, настройка ограничений макета и обнаружение пользовательских взаимодействий - давайте посмотрим, сможем ли мы извлечь вышеуказанные действия и сделать наш контроллер представления намного проще (и менее осведомленным) в процесс.*/

// MARK: - Actions
/*действия
 
 Действия часто бывают двух разных вариантов - синхронные и асинхронные. Некоторые действия просто требуют, чтобы мы быстро обрабатывали или преобразовывали заданное значение и возвращали его напрямую, в то время как другие будут выполнять немного больше времени.
 
 Чтобы смоделировать оба из этих двух типов действий, давайте создадим общее перечисление Action - которое фактически не имеет ни одного случая - но вместо этого содержит два псевдонима типа, один для действий синхронизации и один для асинхронных:*/

fileprivate enum Action<I, O> {
    typealias Sync = (BaseMessageVC, I) -> O
    typealias Async = (BaseMessageVC, I, @escaping (O) -> Void) -> Void
}

fileprivate class NewMessageComposerViewController: BaseMessageVC {
    typealias Actions = (
        addRecipient: Action<Message, Message>.Async,
        finish: Action<Message, Error?>.Async,
        cancel: Action<Message, Void>.Sync
    )

    private var message: Message
    private let actions: Actions

    init(recipients: [Recipient], actions: Actions) {
        self.message = Message(recipients: recipients)
        self.actions = actions
        //super.init(nibName: nil, bundle: nil)
    }

    func handleAddRecipientButtonTap() {
        actions.addRecipient(self, message) { [weak self] newMessage in
            self?.message = newMessage
            self?.renderRecipientsView()
        }
    }

    func handleCancelButtonTap() {
        actions.cancel(self, message)
    }

    func handleSendButtonTap() {
        actions.finish(self, message) { [weak self] error in
            error.map { self?.display($0) }
        }
    }

    private func renderRecipientsView() { }
    private func display(_ error: Error) { }
}

/*Стоит отметить, что в рамках этого рефакторинга мы также улучшили способ добавления получателей в сообщение. Вместо того, чтобы сам контроллер представления выполнял мутацию своей модели, мы просто возвращаем новое значение сообщения в результате его действия addRecipient.
 
 Прелесть вышеупомянутого подхода в том, что теперь наш контроллер представления может сосредоточиться на том, что контроллеры представления делают лучше всего - контролировать представления - и позволить контексту, который его создал, иметь дело с такими деталями, как сетевое взаимодействие и представление RecipientPicker. Вот как мы можем теперь представить компоновщик сообщений поверх другого контроллера представления, например, внутри координатора или навигатора:*/

/*
fileprivate func presentMessageComposerViewController(for recipients: [Recipient], in presentingViewController: UIViewController) {
    let composer = MessageComposerViewController(
        recipients: recipients,
        actions: (
            addRecipient: { [userDatabase] vc, message, handler in
                let picker = RecipientPicker(database: userDatabase)

                picker.present(in: vc) { recipient in
                    var message = message
                    message.recipients.append(recipient)
                    handler(message)
                }
            },
            cancel: { vc, message in
                if message.text.isEmpty {
                    vc.dismiss(animated: true)
                } else {
                    vc.dismissAfterAskingForConfirmation()
                }
            },
            finish: { [networking] vc, message, handler in
                let sender = MessageSender(networking: networking)

                sender.send(message) { error in
                    handler(error)

                    if error == nil {
                        vc.dismiss(animated: true)
                    }
                }
            }
        )
    )

    presentingViewController.present(composer, animated: true)
}
*/
