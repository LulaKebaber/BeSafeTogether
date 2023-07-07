//
//  UserInfo.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 28.06.2023.
//

import Foundation

struct UserInfo: Decodable {
    let email: String
} // registration

struct UserToken: Decodable {
    let access_token: String
    let token_type: String
} // login

struct UserData: Decodable {
    let _id: String
    let email: String
} // get user data

struct UserWord: Decodable {
    let word: String
    let timestamp: String
}

struct UserWords: Decodable {
    let words: [UserWord]
}

struct UserContact: Decodable {
    let name: String
    let phone: String
    let gps: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case phone
        case gps
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        phone = try container.decode(String.self, forKey: .phone)
        gps = try container.decode(Bool.self, forKey: .gps)
    }
}

struct UserContacts: Decodable {
    let contacts: [UserContact]
}
