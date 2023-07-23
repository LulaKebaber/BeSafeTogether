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
    case getWords
    case addContact(name: String, phone: String, gps: Bool)
    case getContacts
}

extension Service: TargetType {
    var baseURL: URL {
//        URL(string: "https://besafetogether.up.railway.app")! // на внешку railway
        URL(string: "http://localhost:8000")! // на локалку
        
    }
    
    var path: String {
        switch self {
        case .registerNewUser(_, _, _, _):
            return "/auth/users"
        case .loginUser(_, _):
            return "/auth/users/tokens"
        case .getUserInfo:
            return "/auth/users/me"
        case .addWord(_), .getWords:
            return "/auth/users/words"
        case .addContact(_, _, _), .getContacts:
            return "/auth/users/contacts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerNewUser(_, _, _, _), .loginUser(_, _), .addWord(_), .addContact(_, _, _):
            return .post
        case .getUserInfo, .getWords, .getContacts:
            return .get
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
        case let .addWord(word):
            let parameters: [String: Any] = [
                "word": word,
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .addContact(name, phone, gps):
            let parameters: [String: Any] = [
                "name": name,
                "phone": phone,
                "gps": gps
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getUserInfo, .getWords, .getContacts:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .registerNewUser(_, _, _, _), .getUserInfo, .addWord, .addContact(_, _, _):
            return [
                "accept": "application/json",
                "Content-Type": "application/json"
            ]
        case .loginUser(_, _), .getWords, .getContacts:
            return [
                "accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }
}
