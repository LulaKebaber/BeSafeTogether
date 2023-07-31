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
    case addWord(word: String)
    case getWords
    case addContact(name: String, phone: String, gps: Bool)
    case getContacts
    case transcribe(audioFile: URL, model: String)
    case deleteContact(contactId: String)
    case deleteWord(wordId: String)
}

extension Service: TargetType {
    var baseURL: URL {
        //        URL(string: "https://besafetogether.up.railway.app")! // на внешку railway
        URL(string: "http://localhost:8000")! // на локалку
    }
    
    var path: String {
        switch self {
        case .registerNewUser:
            return "/auth/users"
        case .loginUser:
            return "/auth/users/tokens"
        case .addWord, .getWords:
            return "/auth/users/words"
        case .addContact, .getContacts:
            return "/auth/users/contacts"
        case .transcribe:
            return "/auth/users/transcriptions"
        case .deleteContact(let contactId):
            return "/auth/users/contacts/\(contactId)"
        case .deleteWord(let wordId):
            return "/auth/users/words/\(wordId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerNewUser, .loginUser, .addWord, .addContact, .transcribe:
            return .post
        case .getWords, .getContacts:
            return .get
        case .deleteContact, .deleteWord:
            return .delete
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
        case .transcribe(let file, _):
            let multiPartData = MultipartFormData(provider: .file(file), name: "file")
            return .uploadMultipart([multiPartData])
        case .getContacts, .getWords, .deleteContact, .deleteWord:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .registerNewUser, .addWord, .addContact, .getContacts, .getWords, .deleteContact, .deleteWord:
            return [
                "accept": "application/json",
                "Content-Type": "application/json"
            ]
        case .loginUser:
            return [
                "accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        case .transcribe:
            return ["Content-type": "multipart/form-data"]
        }
    }
}
