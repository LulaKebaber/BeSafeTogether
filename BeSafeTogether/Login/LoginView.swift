//
//  LoginView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 28.06.2023.
//

import SwiftUI
import Moya
import KeychainAccess

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State var isActive = false
    let keychain = Keychain(service: "com.BeSafeTogether.service")
    
    var body: some View {
        VStack() {
            SignInUsernameInputView(username: $username)
            SignInPasswordInputView(password: $password)
            SignInButtonView(action: loginUser, isActive: $isActive)
                .padding(.top, 28)
            HStack() {
                ForgotPasswordButtonView()
                    .padding(.leading, 30)
                Spacer()
                PrivacyPolicyButtonView()
                    .padding(.trailing, 30)
            }.padding(.top, 10)
        }
        .navigationBarTitle("Sign In")
        .background(
            NavigationLink(destination: TabBarView(), isActive: $isActive) {
                EmptyView()
            }
        )
    }
    
    func loginUser() {
        APIManager.shared.loginUser(username: username, password: password) {
            ()
//            APIManager.shared.getWords { words in
//                WordsAndContactsStorage.shared.words = .init(words: words)
//            }
//            APIManager.shared.getContacts { contacts in
//                WordsAndContactsStorage.shared.contacts = .init(contacts: contacts)
//            }
        }
    }
}

class WordsAndContactsStorage: ObservableObject {
    static let shared: WordsAndContactsStorage = WordsAndContactsStorage()
    
    @Published var words: UserWords?
    @Published var contacts: UserContacts?
}

struct SignInUsernameInputView: View {
    @Binding var username: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Username or Phone")
                .font(Font(UIFont.medium_18))
            VStack {
                TextField("Enter your username", text: $username)
                    .textFieldStyle(.automatic)
                    .frame(width: 300)
                    .padding(.top, 13)
                Spacer()
            }
            .background(RoundedRectangle(cornerRadius: 3)
                .foregroundColor(Color.white)
                .frame(width: 330, height: 50)
                .overlay(RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.black, lineWidth: 1.3)))
            .frame(width: 330, height: 50)
        }.padding(.top, 10)
    }
}

struct SignInPasswordInputView: View {
    @Binding var password: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Password")
                .font(Font(UIFont.medium_18))
            VStack {
                TextField("Enter your password", text: $password)
                    .textFieldStyle(.automatic)
                    .frame(width: 300)
                    .padding(.top, 13)
                Spacer()
            }
            .background(RoundedRectangle(cornerRadius: 3)
                .foregroundColor(Color.white)
                .frame(width: 330, height: 50)
                .overlay(RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.black, lineWidth: 1.3)))
            .frame(width: 330, height: 50)
        }.padding(.top, 10)
    }
}

struct SignInButtonView: View {
    
    var action: () -> Void
    @Binding var isActive: Bool
    
    var body: some View {
        Button(action: {
            action()
            isActive = true
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(Color.black)
                    .frame(width: 330, height: 55)
                Text("Sign In")
                    .foregroundColor(Color.white)
                    .font(Font(UIFont.medium_18))
            }
        }
    }
}

struct ForgotPasswordButtonView: View {
    var body: some View {
        Button(action:{}) {
            Text("Forgot password?")
                .font(Font(UIFont.regular_14))
        }
    }
}

struct PrivacyPolicyButtonView: View {
    var body: some View {
        Button(action:{}) {
            Text("Privacy and Policy")
                .font(Font(UIFont.regular_14))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
