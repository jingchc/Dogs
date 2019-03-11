//
//  APIManager.swift
//  Dogs
//
//  Created by JingChuang on 2019/3/11.
//  Copyright © 2019 JingChuang. All rights reserved.
//

import UIKit
import RxSwift


class APIManager {
    
    static let share = APIManager()

    private let host = "https://dog.ceo/api"
    private let session = URLSession.shared
    
    // API - get main breeds
    func getMainBreeds() -> Observable<[String]> {
        // get url
        guard let url = getURL(endPoint: .getMainBreeds) else {
            return Observable.empty()
        }
        
        return Observable.create { [weak session] observer in
            
            // create task
            let task = session?.dataTask(with: url) { [weak self] (data, response, error) in
                // parse result
                guard let d = data, error == nil,
                    let breeds = self?.parseData(data: d) as? [String] else {
                        observer.onNext([])
                        observer.onCompleted()
                        return
                }
                observer.onNext(breeds)
                observer.onCompleted()
            }
            task?.resume()
            
            
            return Disposables.create()
        }
    }
    
    // API - get random image url by breed
    func getRandomImage(by breed: String) -> Observable<URL?> {
        
        // get url
        guard let url = getURL(endPoint: .getImage(breed: breed, count: 1)) else {
            return Observable.just(nil)
        }
        
        return Observable.create { [weak session] observer in
            // create task
            let task = session?.dataTask(with: url) { [weak self] (data, response, error) in
                // parse result
                guard let d = data, error == nil,
                    let imageUrl = self?.parseData(data: d) as? String else {
                        observer.onNext(nil)
                        observer.onCompleted()
                        return
                }
                observer.onNext(URL(string: imageUrl))
                observer.onCompleted()
            }
            task?.resume()
            
            return Disposables.create()
        }
    }
    
    // API - get random image url
    func getRandomImage(count: Int) -> Observable<URL?> {
        
        // get url
        guard let url = getURL(endPoint: .getRandomImage(count: count)) else {
            return Observable.just(nil)
        }
        
        return Observable.create { [weak session] observer in
            // create task
            let task = session?.dataTask(with: url) { [weak self] (data, response, error) in
                // parse result
                guard let d = data, error == nil,
                    let imageUrl = self?.parseData(data: d) as? String else {
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }
                observer.onNext(URL(string: imageUrl))
                observer.onCompleted()
            }
            task?.resume()
            
            return Disposables.create()
        }
    }
    
    // API - download image
    func downlaodImage(of url: URL) -> Observable<UIImage?> {
        
        return Observable.create { [weak session] observer in
            // create task
            let task = session?.dataTask(with: url) { (data, response, error) in
                // parse result
                guard let d = data, error == nil else {
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }
                observer.onNext(UIImage(data: d))
                observer.onCompleted()
            }
            task?.resume()
            
            return Disposables.create()
        }
        
    }
    

}

// Tool
extension APIManager {
    
    private func parseData(data: Data) -> AnyObject? {
        
        guard let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let dic = object as? [String: AnyObject], (dic["status"] as? String) == "success",
            let objects = dic["message"] else {
                return nil
        }
        return objects
    }
    
}


// Path
extension APIManager {
    
    private enum Endpoint {
        
        case getMainBreeds
        case getAllBreeds
        case getSubBreed(main: String)
        case getInfo(breed: String)
        case getRandomImage(count: Int)
        case getImage(breed: String, count: Int?)
    }
    
    private func getURL(endPoint: Endpoint) -> URL? {
        return URL(string: host + getPath(endPoint: endPoint))
    }
    
    private func getPath(endPoint: Endpoint) -> String {
        
        switch endPoint {
        case .getMainBreeds:
            return "/breeds/list"
        
        case .getAllBreeds:
            return "/breeds/list/all"
        
        case .getSubBreed(let main):
            return "/breed/\(main)/list"
        
        case .getInfo(let breed):
            return "/breed/\(breed)"
        
        case .getRandomImage(let count):
            if count <= 1 {
                return "/breeds/image/random"
            } else {
                return "/breeds/image/random/\(count)"
            }
        
        case .getImage(let breed, let count):
            guard let c = count else {
                return "/breed/\(breed)/images"
            }
            if c <= 1 {
                return "/breed/\(breed)/images/random"
            } else {
                return "/breed/\(breed)/images/random/\(c)"
            }
        }
    }
    
}
