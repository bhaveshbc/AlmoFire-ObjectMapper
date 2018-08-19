//
//  APIRouter.swift
//  Networking
//
//  Created by Alaeddine Messaoudi on 26/11/2017.
//  Copyright © 2017 Alaeddine Me. All rights reserved.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case login(email:String, password:String)
    case articles
    case article(id: Int)
    case itunesFeed
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .articles, .article,.itunesFeed:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return "/login"
        case .articles:
            return "/articles/all.json"
        case .article(let id):
            return "/article/\(id)"
        case .itunesFeed:
            return "coming-soon/all/10/explicit.json"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return [K.APIParameterKey.email: email, K.APIParameterKey.password: password]
        case .articles, .article,.itunesFeed:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var url = try K.ProductionServer.baseURL.asURL()
        if path == "coming-soon/all/10/explicit.json" {
            url = try K.ItunesURl.baseURL.asURL()
        }
        else {
            url = try K.ProductionServer.baseURL.asURL()
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}

