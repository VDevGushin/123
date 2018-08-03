//
//  ETBAddTimeViewControl.swift
//  MyWork
//
//  Created by Vladislav Gushin on 02/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
class ETBTimePickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    enum PickerText: String {
        case min = "мин"
        case sec = "сек"
        init(component: Int) {
            switch component {
            case 0:
                self = .min
            default:
                self = .sec
            }
        }
    }
    var minutes: Int = 0
    var seconds: Int = 0
    var totalSeconds: Int {
        return self.minutes * 60 + seconds
    }
    private let numberComponents = 2
    private let numberRowsInComponent = 60
    private let rowHeight: CGFloat = 30

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberComponents
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberRowsInComponent
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.minutes = row
        case 1:
            self.seconds = row
        default:
            return
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let addtext = PickerText(component: component)
        if let label = view as? UILabel {
            label.text = String(format: "%02lu \(addtext.rawValue)", row)
            return label
        }

        let columnView = UILabel(frame: CGRect(x: 35, y: 0, width: self.frame.size.width / 2 - 35, height: 30))
        columnView.text = String(format: "%02lu  \(addtext.rawValue)", row)
        columnView.textAlignment = NSTextAlignment.center

        return columnView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        dataSource = self
        delegate = self
    }
}

protocol ETBAddTimeViewControlDelegate: class {
    func done(_ result: ETBAddTimeViewControl.TimeResult)
}

@IBDesignable
class ETBAddTimeViewControl: UIView {
    enum TimeResult {
        case cancel
        case addTime(Int)
    }
    weak var delegate: ETBAddTimeViewControlDelegate?
    @IBOutlet weak var timerPicker: ETBTimePickerView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        guard let view = self.loadFromNib(ETBAddTimeViewControl.self) else { return }
        self.addSubview(view)
    }

    @IBAction func addAction(_ sender: Any) {
        delegate?.done(TimeResult.addTime(self.timerPicker.totalSeconds))
    }

    @IBAction func cancel(_ sender: Any) {
        delegate?.done(TimeResult.cancel)
    }
}
