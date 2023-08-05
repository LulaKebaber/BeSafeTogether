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
    case addContact(username: String)
    case getContacts
    case transcribe(audioFile: URL, model: String)
    case deleteContact(contactId: String)
    case deleteWord(wordId: String)
    case checkForThreat
    case updateLocation(latitude: Float, longitude: Float)
}

extension Service: TargetType {
    var baseURL: URL {
        //        URL(string: "https://besafetogether.up.railway.app")! // на внешку railway
        URL(string: "https://fastapi-nvvx.onrender.com")! // на локалку
    }
    
    var path: String {
        switch self {
        case .registerNewUser, .updateLocation:
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
        case .checkForThreat:
            return "/auth/users/threats"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerNewUser, .loginUser, .addWord, .addContact, .transcribe:
            return .post
        case .getWords, .getContacts, .checkForThreat:
            return .get
        case .deleteContact, .deleteWord:
            return .delete
        case .updateLocation:
            return .patch
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
        case let .addContact(username):
            let parameters: [String: Any] = [
                "username": username
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .transcribe(let file, _):
            let multiPartData = MultipartFormData(provider: .file(file), name: "file")
            return .uploadMultipart([multiPartData])
        case .getContacts, .getWords, .deleteContact, .deleteWord, .checkForThreat:
            return .requestPlain
        case let .updateLocation(latitude, longitude):
            let parameters: [String: Any] = [
                "latitude": latitude,
                "longitude": longitude
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .registerNewUser, .addWord, .addContact, .getContacts, .getWords, .deleteContact, .deleteWord, .checkForThreat, .updateLocation:
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
