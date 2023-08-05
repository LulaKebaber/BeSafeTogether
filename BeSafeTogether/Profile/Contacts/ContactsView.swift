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
    @StateObject var contactsViewModel = ContactsViewModel() // Create the ContactsViewModel instance
    
    @State var isAddingContact = false
    @State var username = ""
    @State var phoneNumber = ""
    @State var gps = false
    @State var isLoad = false
    
    var body: some View {
        VStack {
            Text("My Contacts")
                .font(Font(UIFont.bold_32))
            list
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
            Button("dwdw") {
                contactsViewModel.getContacts()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: AddContactButtonView(isAddingContact: $isAddingContact, username: $username, phoneNumber: $phoneNumber, gps: $gps, addContactAction: {
            contactsViewModel.addContact(username: username)
        })
        )
        .onAppear {
            contactsViewModel.getContacts()
        }
    }
    
    var list: some View {
        List(contactsViewModel.contacts) { contact in
            ContactView(contactUsername: contact.username, contactPhoneNumber: contact.phone, contactName: contact.name)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    HStack{
                        Button(action: {
                            contactsViewModel.deleteContacts(contactId: contact.id)
                        }, label: {
                            Label("Удалить", systemImage: "trash")
                        })
                        .tint(.red)
                    }
                }
        }
        .listStyle(.plain)
        .background(.white)
        .onAppear {
            contactsViewModel.getContacts()
        }
    }
    
}

struct ContactView: View {
    @State var contactUsername: String
    @State var contactPhoneNumber: String
    @State var contactName: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(contactName)
                    .font(Font(UIFont.semibold_18))
                Text(contactPhoneNumber)
                    .font(Font(UIFont.regular_16))
            } // VStack
            .padding()
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(contactUsername)
                    .font(Font(UIFont.regular_16))
            } // VStack
            .padding()
        } // HStack
        .padding([.leading, .trailing], 17)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .frame(width: 330, height: 70)
            .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2))
    }
}



struct AddContactButtonView: View {
    @Binding var isAddingContact: Bool
    @Binding var username: String
    @Binding var phoneNumber: String
    @Binding var gps: Bool
    var addContactAction: () -> Void // Closure without arguments
    
    var body: some View {
        Button(action: {
            isAddingContact = true
        }) {
            Image(systemName: "plus")
                .imageScale(.large)
                .foregroundColor(Color.black)
        }
        .sheet(isPresented: $isAddingContact) {
            NewContactView(username: $username, phoneNumber: $phoneNumber, gps: $gps, addContactAction: addContactAction) // Pass the addContactAction closure to NewContactView
        }
    }
}

struct NewContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var username: String
    @Binding var phoneNumber: String
    @Binding var gps: Bool
    var addContactAction: () -> Void // New closure for addContact action
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Username")) {
                    TextField("Username", text: $username)
                }
                
                Section(header: Text("Phone")) {
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
                Section(header: Text("Receive location")) {
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
                    .disabled(username.isEmpty || phoneNumber.isEmpty)
            )
        }
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


struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
