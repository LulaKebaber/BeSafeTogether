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
} // get user words

struct UserWords: Decodable {
    let words: [UserWord]
} // get user words

struct UserContact: Decodable {
    let name: String
    let phone: String
    let gps: Bool
} // get user contacts

struct UserContacts: Decodable {
    let contacts: [UserContact]
} // get user contacts
