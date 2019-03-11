//
//  ImageViewController.swift
//  Dogs
//
//  Created by JingChuang on 2019/3/11.
//  Copyright © 2019 JingChuang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

class ImageViewController: UIViewController {
    
    var breed: String = ""

    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var breedName: UILabel!
    @IBOutlet weak var change: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // UI setting
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .yellow
        dogImage.contentMode = .scaleAspectFit
        breedName.text = breed

        let activeIndicator = ActivityIndicator()


        // API
        let viewWillAppear = rx.viewWillAppear.filter { $0 }.map { _ in () }
        
        Observable.merge(change.rx.tap.asObservable(), viewWillAppear)
            .flatMapLatest { [unowned self] in
                APIManager.share
                    .getRandomImage(by: self.breed)
                    .trackActivity(activeIndicator)
            }
            .filterNil()
            .flatMapLatest {
                APIManager.share
                    .downlaodImage(of: $0)
                    .trackActivity(activeIndicator)
            }
            .bind(to: dogImage.rx.image)
            .disposed(by: bag)
        
        activeIndicator.asObservable()
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: bag)
        
        
    }
    

}

