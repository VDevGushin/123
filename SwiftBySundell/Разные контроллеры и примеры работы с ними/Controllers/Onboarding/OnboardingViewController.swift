//
//  OnboardingViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 09/10/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class OnboardingViewController: CoordinatorViewController {


    var arrayOfImage = ["image1", "image2", "image3"]
    var arrayOfTitle = ["CREATE ACCOUNT", "CHOOSE THE PLANET", "DEPARTURE"]
    var arrayOfDescription = ["In your profile, you can view the statistics of its operations and the recommandations of friends",
        "Purchase tickets on hot tours to your favorite planet and fly to the most comfortable intergalactic spaceships of best companies",
        "In the process of flight you will be in cryogenic sleep and supply the body with all the necessary things for life"]

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            let source = [OnboardingContentModel(color: .red, image: nil, title: nil, subTitle: nil),
                OnboardingContentModel(color: .green, image: nil, title: nil, subTitle: nil),
                OnboardingContentModel(color: .yellow, image: nil, title: nil, subTitle: nil)]

            let oVC = OnboardingRootViewController(with: source)

            oVC.modalPresentationStyle = .fullScreen
            self.present(oVC, animated: false)
        }
    }
}
