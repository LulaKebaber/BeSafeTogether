//
//  GetStartedView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 04.07.2023.
// test

import SwiftUI
import KeychainAccess

struct GetStartedView: View {
    
    let keychain = Keychain(service: "com.BeSafeTogether.service")
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                RegistrationButtonView()
                LoginButtonView()
                    .padding(.bottom, 40)
            }.navigationBarHidden(true)
                .onAppear {
                    print(232323)
                }
        }
        .onAppear {
            self.keychain["BearerToken"] = ""
        }
    }
}


struct LoginButtonView: View {
    var body: some View {
        Button(action:{}) {
            NavigationLink(destination: LoginView()) {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(Color.white)
                        .frame(width: 360, height: 60)
                    Text("Sign In")
                        .foregroundColor(Color.black)
                        .font(Font(UIFont.medium_18))
                }
            }
        }
    }
}

struct RegistrationButtonView: View {
    var body: some View {
        Button(action:{}) {
            NavigationLink(destination: RegistrationView()) {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(Color.black)
                        .frame(width: 360, height: 60)
                    Text("Create account")
                        .foregroundColor(Color.white)
                        .font(Font(UIFont.medium_18))
                }
            }
        }
    }
}

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView()
    }
}
