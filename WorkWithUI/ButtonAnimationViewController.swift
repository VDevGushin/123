//
//  ButtonAnimationViewController.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 03/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

class ButtonAnimationViewController: UIViewController {
    @IBOutlet weak var sizeButton: UIButton!
    @IBOutlet weak var alphaButton: UIButton!

    @IBAction func startAnimation(_ sender: Any) {
        let firstSize = self.sizeButton.bounds.size
        self.sizeButton.animate([.resize(to: CGSize(width: 200, height: 200)), .resize(to: firstSize)])


//        alphaButton.animate(inParallel: [
//                .fadeIn(duration: 3),
//                .resize(to: CGSize(width: 200, height: 200), duration: 3),
//        ])
//
//        //Declarative animation
//        let animationView = UIView(frame: CGRect(
//            x: 0, y: 0,
//            width: 50, height: 50
//        ))
//
//        animationView.backgroundColor = .red
//        animationView.alpha = 0
//        view.addSubview(animationView)
//
//
////        animationView.animate([
////            .fadeIn(duration: 3),
////            .resize(to: CGSize(width: 200, height: 200), duration: 3),
////            .fadeOut(duration: 3),
////            ])
//        animationView.animate(inParallel: [
//                .fadeIn(duration: 3),
//                .resize(to: CGSize(width: 200, height: 200), duration: 3),
//                .fadeOut(duration: 3),
//        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sizeButton.backgroundColor = .red
        alphaButton.alpha = 0
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
