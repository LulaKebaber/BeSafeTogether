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
    let username: String
    let phone: String
} // get user data

struct UserWord: Decodable, Identifiable {
    let id: String
    let word: String
    let timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case word
        case timestamp
    }
} // get user words

struct UserWords: Decodable {
    let words: [UserWord]
} // get user words

struct UserContact: Decodable, Identifiable {
    let id: String
    let username: String
    let name: String
    let phone: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username
        case name
        case phone
    }
} // get user contacts

struct UserContacts: Decodable {
    let contacts: [UserContact]
} // get user contacts

struct TranscribeResponse: Decodable {
    let text: String
} // get transcription

struct Threat: Decodable {
    let username: String
    let threat_recognised: Bool
    let latitude: Float
    let longitude: Float
} // get threated users

struct Threats: Decodable {
    let threats: [Threat]
}
