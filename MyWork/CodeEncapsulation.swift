//
//  CodeEncapsulation.swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol ImageLoader {
    typealias Handler = (Result<UIImage>) -> Void
    func loadImage(from url: URL, then handler: Handler)
}

class ImageLoaderFactory {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func makeImageLoader() -> ImageLoader {
        //тут можно использовать любой фрейворк для работы с сетью
        return SessionImageLoader(session: self.session)
    }
}

private extension ImageLoaderFactory {
    class SessionImageLoader: ImageLoader {
        let session: URLSession
        private var ongoingRequests = Set<URLRequest>()
        init(session: URLSession) {
            self.session = session
        }

        deinit {
            //cancelAllRequests()
        }

        func loadImage(from url: URL,
                       then handler: (Result<UIImage>) -> Void) {
            //let request = Request(url: url, handler: handler)
           // perform(request)
        }
    }
}
