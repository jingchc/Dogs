//
//  BreedListViewController.swift
//  Dogs
//
//  Created by JingChuang on 2019/3/11.
//  Copyright © 2019 JingChuang. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources


class BreedListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let breeds = APIManager.share.getMainBreeds().share()
        
        // data source
        breeds.bind(to: tableView.rx.items(cellIdentifier: "Cell")) { (row, element, cell) in
                cell.textLabel?.text = element
            }
            .disposed(by: bag)
        
        // delegate
        tableView.rx.itemSelected.withLatestFrom(breeds) { $1[$0.row] }
            .subscribe(onNext: { [weak navigationController] breed in
                navigationController?.pushViewController(ImageViewController.init(breed), animated: true)
            })
        .disposed(by: bag)
        
    }

}
