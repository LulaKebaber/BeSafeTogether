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
    //    @Published var contacts = [Contact]()
    
    func addContact(firstName: String, lastName: String, phoneNumber: String, gps: Bool) {
        apiManager.addContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, gps: gps) { [weak self] in
            self?.getContacts()
        }
    }
    
    func getContacts() {
        apiManager.getContacts { [weak self] userContacts in
            self?.contacts = userContacts
            WordsAndContactsStorage.shared.contacts = .init(contacts: userContacts)
        }
    }
    
    func deleteContacts(contactId: String) {
        apiManager.deleteContact(contactId: contactId) { [weak self] in
            self?.getContacts()
        }
    }
}
