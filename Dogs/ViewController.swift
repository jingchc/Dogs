//
//  ViewController.swift
//  Dogs
//
//  Created by JingChuang on 2019/3/11.
//  Copyright © 2019 JingChuang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

class ViewController: UIViewController {

    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var change: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let bag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // UI setting
        loadingIndicator.hidesWhenStopped = true
        dogImage.contentMode = .scaleAspectFit

        let activeIndicator = ActivityIndicator()


        // API
        change.rx.tap
            .flatMapLatest { APIManager.share.getRandomImage(count: 1).trackActivity(activeIndicator) }
            .filterNil()
            .flatMapLatest { APIManager.share.downlaodImage(of: $0).trackActivity(activeIndicator) }
            .bind(to: dogImage.rx.image)
            .disposed(by: bag)
        
        activeIndicator.asObservable()
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: bag)
        
    }
    

}

