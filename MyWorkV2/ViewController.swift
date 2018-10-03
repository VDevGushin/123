//
//  ViewController.swift
//  MyWorkV2
//
//  Created by Vladislav Gushin on 05/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var ttt: UILabel!
    let tcs = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "testID")
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = #imageLiteral(resourceName: "clors")
        
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame.size = view.frame.size
        replicatorLayer.masksToBounds = true
        view.layer.addSublayer(replicatorLayer)
        
        let imageLayer = CALayer()
        imageLayer.contents = image.cgImage
        imageLayer.frame.size = image.size
        replicatorLayer.addSublayer(imageLayer)
        
        let instanceCount = view.frame.width / image.size.width
        replicatorLayer.instanceCount = Int(ceil(instanceCount))
        
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(
            image.size.width, 0, 0
        )
        
        // Reduce the red & green color component of each instance,
        // effectively making each copy more and more blue
//        let colorOffset = -1 / Float(replicatorLayer.instanceCount)
//        replicatorLayer.instanceRedOffset = colorOffset
//        replicatorLayer.instanceGreenOffset = colorOffset
        
        let verticalReplicatorLayer = CAReplicatorLayer()
        verticalReplicatorLayer.frame.size = view.frame.size
        verticalReplicatorLayer.masksToBounds = true
        //verticalReplicatorLayer.instanceBlueOffset = colorOffset
        view.layer.addSublayer(verticalReplicatorLayer)
        
        let verticalInstanceCount = view.frame.height / image.size.height
        verticalReplicatorLayer.instanceCount = Int(ceil(verticalInstanceCount))
        
        verticalReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(
            0, image.size.height, 0
        )
        
        verticalReplicatorLayer.addSublayer(replicatorLayer)
        
        let delay = TimeInterval(0.1)
        replicatorLayer.instanceDelay = delay
        verticalReplicatorLayer.instanceDelay = delay
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 2
        animation.fromValue = 1
        animation.toValue = 0.1
        animation.autoreverses = true
        animation.repeatCount = .infinity
        imageLayer.add(animation, forKey: "hypnoscale")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}
