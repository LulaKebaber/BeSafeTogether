//
//  Service.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 28.06.2023.
//

import Moya
import Foundation

enum Service {
    case registerNewUser(username: String, password: String)
    case loginUser(username: String, password: String)
    case getUserInfo
}

extension Service: TargetType {
    var baseURL: URL {
//        URL(string: "https://besafetogether.up.railway.app")! // на внешку railway
        URL(string: "http://0.0.0.0:8000")! // на локалку

    }
    
    var path: String {
        switch self {
        case .registerNewUser(_, _):
            return "/auth/users"
        case .loginUser(_, _):
            return "/auth/users/tokens"
        case .getUserInfo:
            return "/auth/users/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerNewUser(_, _):
            return .post
        case .loginUser(_, _):
            return .post
        case .getUserInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .registerNewUser(username, password):
            let parameters: [String: Any] = [
                "email": username,
                "password": password
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case let .loginUser(username, password):
            let parameters: [String: Any] = [
                "grant_type": "",
                "username": username,
                "password": password,
                "scope": "",
                "client_id": "",
                "client_secret": ""
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getUserInfo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {

        switch self {
        case .registerNewUser(_, _):
            return [
                "Content-Type": "application/json"
            ]
        case .loginUser(_, _):
            return [
                "accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .getUserInfo:
            return ["accept": "application/json"]
        }
//        ["accept: application/json": "application/json"]
        
    }
}
