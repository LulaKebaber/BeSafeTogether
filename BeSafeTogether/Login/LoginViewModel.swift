//
//  LoginViewModel.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 29.07.2023.
//
//
//import Foundation
//import KeychainAccess
//
//class LoginViewModel: ObservableObject {
//    var username: String = ""
//    var password: String = ""
//    
//    func loginUser() {
//        APIManager.shared.loginUser(username: username, password: password) {
//            APIManager.shared.getWords { words in
//                WordsAndContactsStorage.shared.words = .init(words: words)
//            }
//            APIManager.shared.getContacts { contacts in
//                WordsAndContactsStorage.shared.contacts = .init(contacts: contacts)
//            }
//        }
//    }
//}
