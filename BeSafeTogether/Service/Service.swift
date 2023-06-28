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
}

extension Service: TargetType {
    var baseURL: URL {
//        URL(string: "https://besafetogether.up.railway.app")! // на внешку railway
        URL(string: "http://localhost:8000")! // на локалку

    }
    
    var path: String {
        "/auth/users"
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        switch self {
        case let .registerNewUser(username, password):
            let parameters: [String: Any] = [
                "email": username,
                "password": password
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
}
