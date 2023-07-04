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
