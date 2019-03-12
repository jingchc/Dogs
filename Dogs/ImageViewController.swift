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
    
    private var breed: String = ""
    
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var breedName: UILabel!
    @IBOutlet weak var change: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let bag = DisposeBag()
    
    class func `init`(_ breed: String) -> ImageViewController {
        let imageVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        imageVC.breed = breed
        return imageVC
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // UI setting
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .yellow
        dogImage.contentMode = .scaleAspectFit
        breedName.text = breed

        let activeIndicator = ActivityIndicator()

        let viewWillAppear = rx.viewWillAppear.mapToVoid() //.map { _ in () }
        // API
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
        
        // loading indicator
        activeIndicator.asObservable()
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: bag)
        
        
    }
    

}

