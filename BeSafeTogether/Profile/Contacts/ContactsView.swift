//
//  ContactsView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 23.06.2023.
//

import SwiftUI
import Contacts
import Moya
import KeychainAccess

struct ContactsView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let keychain = Keychain(service: "com.BeSafeTogether.service")
    @State var isAddingContact = false
    
    @State var firstName = ""
    @State var lastName = ""
    @State var phoneNumber = ""
    @State var gps = false
    
    @State var contacts: [(String, String, Bool)] = []
    
    var body: some View {
        VStack {
            Text("My Contacts")
                .font(Font(UIFont.bold_32))
            
            ContactsListView(contacts: $contacts)
            Spacer()
            HStack {
                Text("Your default message:")
                    .font(Font(UIFont.regular_18))
                Spacer()
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .padding([.leading, .trailing], 30)
            MessageView()
                .padding(.bottom, 25)
            
            Button(action:{getContacts()}) {
                Text("hello")
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: AddContactButtonView(isAddingContact: $isAddingContact, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, gps: $gps, addContactAction: addContact))
    }
    
    func addContact() {
        guard let savedBearerToken = keychain["BearerToken"] else {
            print("Bearer token not found in Keychain")
            return
        }
        
        // Create a custom endpoint closure to add the Authorization header
        let endpointClosure = { (target: Service) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "Bearer \(savedBearerToken)"])
        }
        
        // Create a MoyaProvider instance with the custom endpoint closure
        let provider = MoyaProvider<Service>(endpointClosure: endpointClosure)
        let name = firstName + " " + lastName
        provider.request(.addContact(name: name, phone: phoneNumber, gps: gps)) {
            result in switch result {
            case let .success(response):
                print(response)
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getContacts() {
        // Retrieve the bearer token from Keychain
        guard let savedBearerToken = keychain["BearerToken"] else {
            print("Bearer token not found in Keychain")
            return
        }
        
        // Create a custom endpoint closure to add the Authorization header
        let endpointClosure = { (target: Service) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "Bearer \(savedBearerToken)"])
        }
        
        // Create a MoyaProvider instance with the custom endpoint closure
        let provider = MoyaProvider<Service>(endpointClosure: endpointClosure)
        
        // Make the authenticated request
        provider.request(.getContacts) { result in
            switch result {
            case let .success(response):
                do {
                    let userContacts = try response.map(UserContacts.self).contacts
                    for contact in userContacts {
                        contacts.append((contact.name, contact.phone, contact.gps))
                    }
                    print(contacts)
                    // Handle the received user information
                } catch {
                    print("Failed to parse users: \(error)")
                }
            case let .failure(error):
                print("API request failed: \(error)")
            }
        }
    }
}

struct ContactsListView: View {
    @Binding var contacts: [(String, String, Bool)]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(contacts.indices, id: \.self) { index in
                    ContactView(
                        ContactName: contacts[index].0,
                        ContactPhoneNumber: contacts[index].1,
                        gps: contacts[index].2
                    )
                    .padding(.bottom, 10) // Add spacing between contacts
                }
            }
            .padding()
        }
    }
}

struct ContactView: View {
    
    @State var ContactName: String
    @State var ContactPhoneNumber: String
    @State var gps: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(ContactName)
                    .font(Font(UIFont.semibold_18))
                Text(ContactPhoneNumber)
                    .font(Font(UIFont.regular_16))
            } // VStack
            .padding()
            
            Spacer()
            
            Button(action: {}) {
                ZStack {
                    RoundedRectangle(cornerRadius: 13)
                        .foregroundColor(Color.black)
                        .frame(width: 65, height: 35)
                    Text("Edit")
                        .foregroundColor(Color.white)
                        .font(Font(UIFont.regular_14))
                } // ZStack
                .padding()
            }
            
        } // HStack
        .padding([.leading, .trailing], 17)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .frame(width: 330, height: 70)
            .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2))
    }
}

struct MessageView: View {
    @State var address = ""
    
    var body: some View {
        VStack {
            TextField("Enter the message", text: $address, axis: .vertical)
                .textFieldStyle(.automatic)
                .frame(width: 300)
                .padding()
            Spacer()
        }
        .background(RoundedRectangle(cornerRadius: 15)
            .foregroundColor(Color.white)
            .frame(width: 330, height: 100)
            .overlay(RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 2)))
        .frame(width: 330, height: 100)
        
        Button(action: {}) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color.black)
                    .frame(width: 335, height: 45)
                Text("Save")
                    .foregroundColor(Color.white)
                    .font(Font(UIFont.medium_18))
            } // ZStack
            .padding()
        }
    }
}

struct AddContactButtonView: View {
    @Binding var isAddingContact: Bool
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var phoneNumber: String
    @Binding var gps: Bool
    var addContactAction: () -> Void // New closure for addContact action
    
    var body: some View {
        Button(action: {
            isAddingContact = true
        }) {
            Image(systemName: "plus")
                .imageScale(.large)
                .foregroundColor(Color.black)
        }
        .sheet(isPresented: $isAddingContact) {
            NewContactView(firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, gps: $gps, addContactAction: addContactAction) // Pass the addContactAction closure to NewContactView
        }
    }
}

struct NewContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var phoneNumber: String
    @Binding var gps: Bool
    var addContactAction: () -> Void // New closure for addContact action
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }
                
                Section(header: Text("Phone")) {
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                Section(header: Text("Receive Notifications")) {
                    Toggle(isOn: $gps) {
                        Text("Receive Notifications")
                    }
                }
            }
            .navigationBarTitle("New Contact")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    addContactAction() // Call the addContactAction closure
                    presentationMode.wrappedValue.dismiss()
                }
                    .disabled(firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty)
            )
        }
    }
}


struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
