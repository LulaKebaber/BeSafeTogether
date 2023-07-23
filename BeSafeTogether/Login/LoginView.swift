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
        let provider = MoyaProvider<Service>()
        provider.request(.loginUser(username: username, password: password)) {
            result in switch result {
            case let .success(response):
                do {
                    let userToken = try response.map(UserToken.self)
                    print(userToken.access_token)
                    keychain["BearerToken"] = userToken.access_token
                } catch {
                    print("Failed to parse UserToken: \(error)")
                }
            case let .failure(error):
                // Handle error, display alert, etc.
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getUserInfo() {
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
        provider.request(.getUserInfo) { result in
            switch result {
            case let .success(response):
                do {
                    let users = try response.map(UserData.self)
                    print(users)
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
                Text("Sign Up")
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
