//
//  ContactsViewModel.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 30.07.2023.
//

import Foundation

class ContactsViewModel: ObservableObject {
    private let apiManager = APIManager.shared
    
    @Published var contacts = [UserContact]()
    
    func addContact(username: String) {
        apiManager.addContact(username: username) { [weak self] in
            self?.getContacts()
            
        }
    }
    
    func getContacts() {
        apiManager.getContacts { [weak self] userContacts in
            self?.contacts = userContacts
            print(userContacts)
            WordsAndContactsStorage.shared.contacts = .init(contacts: userContacts)
        }
    }
    
    func deleteContacts(contactId: String) {
        apiManager.deleteContact(contactId: contactId) { [weak self] in
            self?.getContacts()
        }
    }
}
