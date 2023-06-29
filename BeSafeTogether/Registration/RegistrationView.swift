//
//  RegistrationView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 28.06.2023.
//

import SwiftUI
import Moya

struct RegistrationView: View {
    @State private var username = "name111"
    @State private var password = "pass"
    
    var body: some View {
        NavigationView {
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

//                Button("tftt") {
//                    registerUser()
//                }
                
                Button("Register Norm") {
                    registerUser()
                }

                Button(action:{}) { // ne rabotaet
                    NavigationLink(destination: LoginView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.black)
                                .frame(width: 360, height: 50)
                            Text("registration")
                                .foregroundColor(Color.white)
                                .font(Font(UIFont.medium_26))
                        }
                    }
                }.onTapGesture {
                    registerUser()
                }
            }
        }
    }
    
    func registerUser() {
        let provider = MoyaProvider<Service>()
        
        provider.request(.registerNewUser(username: username, password: password)) {
            result in switch result {
                case let .success(response):
                    print(response)
                    let userInfo = try? response.map(UserInfo.self)
                    print(userInfo?.email as Any)
                
                case let .failure(error):
                    // Handle error, display alert, etc.
                    print("Error: \(error.localizedDescription)")
                }
        }
    }
}

//struct RegistrationView: View {
//    var body: some View {
//
//    }
//}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
