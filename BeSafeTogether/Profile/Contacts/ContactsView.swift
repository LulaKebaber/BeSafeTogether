//
//  ContactsView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 23.06.2023.
//

import SwiftUI

struct ContactsView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text("My Contacts")
                .font(Font(UIFont.bold_32))
                
            ContactsListView()
            Spacer()
            HStack {
                Text("Your default message:")
                    .font(Font(UIFont.regular_18))
                Spacer()
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
            }.padding([.leading, .trailing], 30)
            MessageView()
                .padding(.bottom, 25)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()}) {
                
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color.black)
                    Text("Back")
                        .foregroundColor(Color.black)
                
            })
    }
}

struct ContactsListView: View {
    var body: some View {
        VStack {
            ContactView(ContactName: "Даниал", ContactPhoneNumber: "+77783845500")
            ContactView(ContactName: "Алишер", ContactPhoneNumber: "+770138455232")
            ContactView(ContactName: "Абай", ContactPhoneNumber: "+77056544545")
        }
        .padding()
    }
}

struct ContactView: View {
    
    @State var ContactName: String
    @State var ContactPhoneNumber: String
    
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
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color.black)
                        .frame(width: 60, height: 33)
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
        .background(RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color.white)
                        .frame(width: 330, height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.black, lineWidth: 2.5)))
        .frame(width: 330, height: 100)
        
        Button(action: {}) {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
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
