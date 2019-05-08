//
//  TaskTableViewCell.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 08/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var task: TimerTask? {
        didSet {
            taskLabel.text = task?.name
            self.setState()
            self.updateTime()
        }
    }

    func updateState() {
        guard let task = task else { return }
        task.completed.toggle()
        self.setState()
        self.updateTime()
    }

    func updateTime() {
        guard let task = task else { return }

        if task.completed {
            timeLabel.text = "Completed"
        } else {
            let time = Date().timeIntervalSince(task.creationDate)
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            var times: [String] = []
            if hours > 0 {
                times.append("\(hours)h")
            }
            if minutes > 0 {
                times.append("\(minutes)m")
            }
            times.append("\(seconds)s")
            timeLabel.text = times.joined(separator: " ")
        }
    }

    private func setState() {
        guard let task = task else { return }
        if task.completed {
            taskLabel.attributedText = NSAttributedString(string: task.name,
                attributes: [.strikethroughStyle: 1])
        } else {
            taskLabel.attributedText = NSAttributedString(string: task.name,
                attributes: nil)
        }
    }
}
