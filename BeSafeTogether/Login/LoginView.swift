//
//  LoginView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 28.06.2023.
//

import SwiftUI
import Moya

struct LoginView: View {
    @State private var username = "name1"
    @State private var password = "pass1"
    
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
        }
    }
    
    func loginUser() {
        let provider = MoyaProvider<Service>()

        provider.request(.loginUser(username: username, password: password)) {
            result in switch result {
                case let .success(response):
                    print(response)
                    let userToken = try? response.map(UserToken.self)
                    print(userToken?.access_token as Any)
                case let .failure(error):
                    // Handle error, display alert, etc.
                    print("Error: \(error.localizedDescription)")
                }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
