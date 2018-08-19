//
//  CustomeApiClient.swift
//  Networking
//
//  Created by Bhavesh Chaudhari on 18/08/18.
//  Copyright © 2018 Alaeddine Me. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class customeClient {
    static func fetch(request:APIRouter , onSuccess: @escaping (Any) -> Void, onError: @escaping (Error) -> Void ) {
        Alamofire.request(request).responseJSON { (response) in
            switch response.result {
            case .success( let responses) :
                onSuccess(responses)
            case .failure(let error) :
                onError(error)
            }
        }
    }
    
//    test@gmail.com", password: "myPassword")
    static func getItunes(completion:@escaping (Result<User>)->Void) {
        fetch(request: APIRouter.login(email: "test@gmail.com", password: "myPassword"), onSuccess: { (response) in
            print(response)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    static func getArticles(completion:@escaping ([Article])->Void) {
        fetch(request: APIRouter.articles, onSuccess: { (response) in
            let articleList  = Mapper<Article>().mapArray(JSONArray: response as! [[String : Any]])
            completion(articleList)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}

