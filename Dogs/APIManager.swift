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
    
    // API - get random image url
    func getRandomImage(count: Int, completion: @escaping(_ url: URL?) -> Void) {
        
        // get url
        guard let url = getURL(endPoint: .getRandomImage(count: count)) else {
            completion(nil)
            return
        }
        
        // create task
        let task = session.dataTask(with: url) { (data, response, error) in
            // parse result
            guard let d = data, error == nil,
                let object = try? JSONSerialization.jsonObject(with: d, options: .allowFragments),
                let dic = object as? [String: String], dic["status"] == "success",
                let imageUrl = dic["message"] else {
                    completion(nil)
                    return
            }
            completion(URL(string: imageUrl))
        }
        task.resume()
    }
    
    
    // download image
    func downlaodImage(of url: URL, completion: @escaping(_ image: UIImage?) -> Void) {
        // create task
        let task = session.dataTask(with: url) { (data, response, error) in
            // parse result
            guard let d = data, error == nil else {
                    completion(nil)
                    return
            }
            completion(UIImage(data: d))
        }
        task.resume()
    }
    

}



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
