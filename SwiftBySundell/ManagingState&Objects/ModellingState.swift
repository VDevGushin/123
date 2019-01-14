//
//  ModellingState.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 14/01/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit


// MARK: - A single source of truth
/*
 Один ключевой принцип, который стоит иметь в виду при моделировании различных состояний, состоит в том, чтобы как можно больше придерживаться «единого источника правды». Простой способ взглянуть на это состоит в том, что вам никогда не нужно проверять наличие нескольких условий, чтобы определить, в каком состоянии вы находитесь. Давайте рассмотрим пример.
 Допустим, мы строим игру, в которой у врагов есть определенное здоровье, а также флаг, чтобы определить, в игре они или нет. Мы можем смоделировать это, используя два свойства класса Enemy, например:
 */
fileprivate class Enemy {
    var health = 10
    var isInPlay = false
}

/*
Хотя вышесказанное выглядит прямо, оно может легко поставить нас в ситуацию, когда у нас есть несколько источников правды.
 Скажем так, как только здоровье врага достигнет нуля, его следует вывести из игры. Итак, где-то в нашем коде у нас есть логика, чтобы справиться с этим:
 */

fileprivate func enemyDidTakeDamage(enemy: Enemy) {
    if enemy.health <= 0 {
        enemy.isInPlay = false
    }
}

/*
 Проблема возникает, когда мы вводим новые пути кода, где мы забываем выполнить вышеуказанную проверку.
 Например, мы можем дать нашему игроку специальную атаку, которая мгновенно устанавливает здоровье всех врагов на ноль:
 */
fileprivate func performSpecialAttack(allEnemies: Enemy...) {
    for enemy in allEnemies {
        enemy.health = 0
    }
}

/*
 Как вы можете видеть выше, мы обновляем свойство здоровья всех врагов, но забываем обновить isInPlay.
 Это, скорее всего, приведет к ошибкам и ситуациям, когда мы окажемся в неопределенном состоянии.
 В такой ситуации может быть заманчиво решить проблему, добавив несколько проверок, например так:
 */

fileprivate func performSpecialAttackWithCheck(allEnemies: Enemy...) {
    for enemy in allEnemies {
        if enemy.isInPlay && enemy.health > 0 {
            enemy.health = 0
        } else {
            return
        }
    }
}
/*Хотя вышеперечисленное может работать как временное решение для «поддержки диапазона», оно быстро приведет к тому, что сложнее будет прочитать код, который легко сломается, когда мы добавим больше условий и более сложные состояния. Если вы подумаете об этом, то сделать что-то подобное вышеперечисленному - все равно, что не доверять нашим собственным API, поскольку мы должны так защищаться от них 😕
 
 Одним из способов решения этой проблемы и обеспечения того, чтобы у нас был единственный источник правды, является автоматическое обновление свойства isInPlay внутри класса Enemy с использованием didSet для свойства health:*/
fileprivate class EnemyWithAutoCheck {
    //Таким образом, теперь нам остается только беспокоиться об обновлении здоровья врага, и мы уверены, что свойство isInPlay всегда будет синхронизировано 👍
    var health = 10 {
        didSet { putOutOfPlayIfNeeded() }
    }

    // Important to only allow mutations of this property from within this class
    private(set) var isInPlay = true

    private func putOutOfPlayIfNeeded() {
        guard health <= 0 else { return }
        isInPlay = false
        remove()
    }

    private func remove() { }
}

// MARK: - Making states exclusive
fileprivate struct Task {
    enum State {
        case inProgress
        case isFinished(file: File)
    }

    var state: State = .inProgress
    func start() { }
    func cancel() { }

    static func download(url: URL) -> Task {
        return Task()
    }
}
fileprivate struct File { }
//Допустим, мы создаем видеоплеер, который позволит нам скачивать и смотреть видео с определенного URL. Для моделирования видео мы можем использовать структуру, например:
fileprivate struct Video {
    let url: URL
    let downloadTask: Task?
    var file: File?
    var isPlaying = false
    var progress: Double = 0
}
/*
 Мы также обычно заканчиваем тем, что пишем сложную обработку, включающую пути кода, которые в идеале никогда не должны вводиться:
 */
fileprivate func workWith(video: Video) {
    if let downloadTask = video.downloadTask {
        //handle download
    } else if let file = video.file {
        // perform playback
    } else {

    }
}
//Я часто решаю эту проблему, используя перечисление для определения очень четких, исключительных состояний, например:
fileprivate struct VideoV1 {
    struct PlaybackState {
        let file: File
        var progress: Double
    }

    enum State {
        case willDownload(from: URL)
        case downloading(task: Task)
        case playing(PlaybackState)
        case paused(PlaybackState)
    }

    var state: State
}

extension VideoV1 {
    var downloadTask: Task? {
        guard case let .downloading(task) = state else { return nil }
        return task
    }
}

// MARK: - Rendering reactively
/*Однако, если вы начнете моделировать свое состояние, как описано выше, но продолжите писать код обработки императивного состояния (используя несколько операторов if / else, как описано выше), все станет довольно уродливо. Так как вся информация, которая нам нужна, «скрыта» в различных случаях, нам нужно будет сделать много переключений или, если операторы case позволяют «получить ее».
 
 Нам нужно объединить наше перечисление состояний с кодом обработки реактивного состояния. В качестве примера, давайте посмотрим, как мы могли бы написать код для обновления кнопки действия в контроллере представления видеоплеера:*/

fileprivate class VideoPlayerViewController: UIViewController {
    struct Player {
        func play() { }
        func pause() { }
    }

    let player = Player()

    var video: VideoV1 {
        didSet {
            self.render()
            self.handleStateChange()
        }
    }

    fileprivate lazy var actionButton = UIButton(frame: .zero)

    init(video: VideoV1) {
        self.video = video
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.video.downloadTask?.cancel()
    }

    /*Теперь каждый раз, когда изменяется состояние нашего видео, наш пользовательский интерфейс будет автоматически обновляться. У нас есть один источник правды и нет неопределенных состояний. Затем мы можем расширить наш метод рендеринга, чтобы автоматически выполнять все наши обновления пользовательского интерфейса при изменении нашего состояния:*/
    private func render() {
        self.renderActionButton()
        //self.renderVideoSurface()
        //self.renderNavigationBarButtonItems()
    }

    private func renderActionButton() {
        let actionButtonImage: UIImage = resolveActionButtonImage()
        actionButton.setImage(actionButtonImage, for: .normal)
    }

    private func resolveActionButtonImage() -> UIImage {
        switch video.state {
        case .willDownload:
            return UIImage(contentsOfFile: "download.png")!
        case .downloading:
            return UIImage(contentsOfFile: "downloading.png")!
        case .paused:
            return UIImage(contentsOfFile: "pause.png")!
        case .playing:
            return UIImage(contentsOfFile: "paying.png")!
        }
    }
}

// MARK: - Handling state changes

extension VideoPlayerViewController {
    func handleStateChange() {
        switch self.video.state {
        case .willDownload(from: let url):
            let task = Task.download(url: url)
            task.start()
            video.state = .downloading(task: task)
        case .downloading(task: let task):
            switch task.state {
            case .inProgress: break
            case .isFinished(file: let file):
                let playBackState = VideoV1.PlaybackState(file: file, progress: 0.0)
                video.state = .playing(playBackState)
            }
        case .playing:
            self.player.play()
        case .paused:
            self.player.pause()
        }
    }
}

// MARK: - Extracting information
