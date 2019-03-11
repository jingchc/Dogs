//
//  ViewController.swift
//  Dogs
//
//  Created by JingChuang on 2019/3/11.
//  Copyright © 2019 JingChuang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var change: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // UI setting
        loadingIndicator.hidesWhenStopped = true
        dogImage.contentMode = .scaleAspectFit
        
        // API
        change.addTarget(self, action: #selector(changeImage), for: .touchUpInside)
        
    }
    
    @objc private func changeImage() {
        loadingIndicator.startAnimating()
        APIManager.share.getRandomImage(count: 1) { [weak self] url in
            guard let imageURL = url else {
                // todo: error handling
                return
            }
            APIManager.share.downlaodImage(of: imageURL) { image in
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    self?.dogImage?.image = image
                }
            }
        }
    }

}

