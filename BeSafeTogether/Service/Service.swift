//
//  Service.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 28.06.2023.
//

import Moya
import Foundation

enum Service {
    case registerNewUser(username: String, name: String, phone: String, password: String)
    case loginUser(username: String, password: String)
    case getUserInfo
    case addWord(word: String)
}

extension Service: TargetType {
    var baseURL: URL {
//        URL(string: "https://besafetogether.up.railway.app")! // на внешку railway
        URL(string: "http://0.0.0.0:8000")! // на локалку

    }
    
    var path: String {
        switch self {
        case .registerNewUser(_, _, _, _):
            return "/auth/users"
        case .loginUser(_, _):
            return "/auth/users/tokens"
        case .getUserInfo:
            return "/auth/users/me"
        case .addWord(_):
            return "/auth/users/words"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerNewUser(_, _, _, _):
            return .post
        case .loginUser(_, _):
            return .post
        case .getUserInfo:
            return .get
        case .addWord(_):
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .registerNewUser(username, name, phone, password):
            let parameters: [String: Any] = [
                "username": username,
                "name": name,
                "phone": phone,
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
        case let .addWord(word):
            let parameters: [String: Any] = [
                "word": word,
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .registerNewUser(_, _, _, _):
            return [
                "accept": "application/json",
                "Content-Type": "application/json"
            ]
        case .loginUser(_, _):
            return [
                "accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .getUserInfo:
            return ["accept": "application/json"]
        case .addWord:
            return [
                "accept": "application/json",
                "Content-Type": "application/json"
            ]
        }
    }
}
