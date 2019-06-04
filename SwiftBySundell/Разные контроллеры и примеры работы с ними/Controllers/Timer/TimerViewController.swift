//
//  TimerViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 08/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import Lottie
import AVFoundation

class TimerViewController: CoordinatorViewController {
    @IBOutlet private weak var table: UITableView!
    @IBOutlet private weak var animationView: AnimationView!
    private var taskList: [TimerTask] = []
    private var player: AVAudioPlayer?
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupPlayer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.animationView.stop()
        timer?.invalidate()
        timer = nil
    }

    private func setupPlayer() {
        guard let url = Bundle.main.url(forResource: "109662_945474-lq", withExtension: "mp3"),
            let player = try? AVAudioPlayer(contentsOf: url) else {
                return
        }
        self.player = player
        self.player?.prepareToPlay()
    }

    private func setupUI() {
        self.animationView.isHidden = true
        self.table.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        self.table.delegate = self
        self.table.dataSource = self

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
            target: self,
            action: #selector(presentAlertController))
        let animation = Animation.named("success-animation")
        self.animationView.animation = animation
        self.animationView.contentMode = .scaleAspectFit
    }

    @objc private func presentAlertController(_ sender: UIBarButtonItem) {
        self.createTimer()
        let alertController = UIAlertController(title: "Task name",
            message: nil,
            preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Task name"
            textField.autocapitalizationType = .sentences
        }

        let createAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak alertController] _ in
            guard let self = self, let text = alertController?.textFields?.first?.text else { return }
            DispatchQueue.main.async {
                let task = TimerTask(name: text)
                self.taskList.append(task)

                let indexPath = IndexPath(row: self.taskList.count - 1, section: 0)

                self.table.beginUpdates()
                self.table.insertRows(at: [indexPath], with: .top)
                self.table.endUpdates()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(createAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    private func showCongratulationsIfNeeded() {
        if taskList.filter({ !$0.completed }).count == 0 {
            self.animationView.isHidden = false
            self.animationView.play()
            self.player?.play()
        }
    }
}

extension TimerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.task = taskList[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
        cell.updateState()
        self.showCongratulationsIfNeeded()
    }
}

// MARK: - Timer
extension TimerViewController {
    private func createTimer() {
        guard self.timer == nil else { return }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
        timer!.tolerance = 0.1
    }


    @objc private func updateTimer() {
        if let fireDateDescription = timer?.fireDate.description {
            print(fireDateDescription)
        }
        guard let visibleRowsIndexPaths = self.table.indexPathsForVisibleRows else { return }
        let cells = visibleRowsIndexPaths.compactMap {
            return self.table.cellForRow(at: $0) as? TaskTableViewCell
        }
        cells.forEach {
            $0.updateTime()
        }
    }
}
