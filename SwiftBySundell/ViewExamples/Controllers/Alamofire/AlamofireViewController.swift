//
//  AlamofireViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import Alamofire
import Lottie
import PromiseKit

class AlamofireViewController: CoordinatorViewController {
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var animationView: LOTAnimationView!

    private let dataController: AlamofireDataController //DI

    init(dataController: AlamofireDataController,
         navigator: AppCoordinator,
         title: String,
         nibName: String,
         bundle: Bundle?) {
        self.dataController = dataController
        super.init(navigator: navigator, title: title, nibName: nibName, bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.animationView.setAnimation(named: "pulsing-loading-circles")
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.animationSpeed = 1.0
        self.animationView.loopAnimation = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //let url = "https://httpbin.org/get"
//        self.dataController.makeRequestResponse(with: url)
//        self.dataController.makeRequestStringResponse(with: url)
//        self.dataController.makeRequestJSONResonse(with: url)
//        self.dataController.makeRequestDataResponse(with: url)
//        //Chained Response
//        self.dataController.makeChainedResponse(with: url)
//        //Response Handler Queue
//        self.dataController.makeRequestJSONResonse(on: .global(), with: url)
//        //Response Validation
//        self.dataController.makeRequestDataResponseWithValidation(with: url)
//        //HTTP Methods
//        self.dataController.makeRequestHTTPMethod()
//        //URL Encoding
//        let parameters: Parameters = ["foo": "bar"]
//        self.dataController.requestWithURLEncodedParameters(with: parameters)
//        //HTTP Headers
//        self.dataController.requestWithHeaders()
//        //HTTP Basic Authentication
//        let user = "user"
//        let password = "password"
//        self.dataController.makeAuth(with: user, password: password)
//        self.dataController.makeAuth(with: user + "123", password: password)
//        self.dataController.makeAuthWithCredential(with: user, password: password)

        //Download image with promise / alamofire

        if self.animationView.isAnimationPlaying {
            self.animationView.stop()
            self.animationView.isHidden = true
        }
        self.animationView.isHidden = false
        self.animationView.play()
        firstly {
            when(fulfilled: [self.dataController.imageDownload(on: .global(qos: .background)),
                     self.dataController.downloadFileDestination(on: .global(qos: .background))])
        }.done { [weak self]images in
            self?.image?.image = images[0]
            self?.dataController.uploadData(image: images[0])
        }.ensure { [weak self] in
            self?.animationView.stop()
            self?.animationView.isHidden = true
        }.catch(on: .main) { error in
            debugPrint(error)
        }
    }
}
