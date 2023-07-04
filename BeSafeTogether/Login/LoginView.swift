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
    @State private var username = "name1"
    @State private var password = "pass1"
    let keychain = Keychain(service: "com.yourapp.service")
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Meme name", text: $username)
                .foregroundColor(Color.black)
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white))
                .padding()
            TextField("Top text", text: $password)
                .foregroundColor(Color.black)
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white))
                .padding()
            Button("Register") {
                loginUser()
            }
            //            Button("get token") {
            //                checkToken()
            //            }
            Button("get info") {
                getUserInfo()
            }
        }
    }
    
    func loginUser() {
        let provider = MoyaProvider<Service>()
        provider.request(.loginUser(username: username, password: password)) {
            result in switch result {
            case let .success(response):
                do {
                    let userToken = try response.map(UserToken.self)
                    print(userToken.access_token)
                    keychain["BearerToken1"] = userToken.access_token
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
        guard let savedBearerToken = keychain["BearerToken1"] else {
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
