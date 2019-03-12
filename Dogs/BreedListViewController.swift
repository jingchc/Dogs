//
//  BreedListViewController.swift
//  Dogs
//
//  Created by JingChuang on 2019/3/11.
//  Copyright © 2019 JingChuang. All rights reserved.
//

import UIKit
import RxSwift


class BreedListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var breeds: [String] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        APIManager.share.getMainBreeds()
            .subscribe(onNext: { [weak self] in self?.breeds = $0 })
            .disposed(by: bag)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage", let breed = sender as? String, let imageVC = segue.destination as? ImageViewController {
            imageVC.breed = breed
        }
    }

}

extension BreedListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = breeds[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 1. use segue
        performSegue(withIdentifier: "showImage", sender: breeds[indexPath.row])
        // 2. init VC here
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
//        vc.breed = breeds[indexPath.row]
//        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
