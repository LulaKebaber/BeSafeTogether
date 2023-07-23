//
//  RegistrationView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 28.06.2023.
//

import SwiftUI
import Moya

struct RegistrationView: View {
    @State var username = ""
    @State var name = ""
    @State var phone = ""
    @State var password = ""
    @State var repeat_password = ""
    @State var checkState = false
    @State var isActive = false
    
    var body: some View {
        VStack {
            SignUpUsernameInputView(username: $username)
                .padding(.top, 20)
            SignUpNameInputView(name: $name)
            SignUpPhoneInputView(phone: $phone)
            SignUpPasswordInputView(password: $password, repeat_password: $repeat_password)
            Spacer()
            SignUpTermsInputView(checkState: $checkState)
            SignUpButtonView(action: registerUser, isActive: $isActive)
                .padding(.bottom, 30)
        }
        .navigationBarTitle("Registration")
        .background(
            NavigationLink(destination: LoginView(), isActive: $isActive) {
                EmptyView()
            }
        )
    }
    
    func registerUser() {
        let provider = MoyaProvider<Service>()
        
        provider.request(.registerNewUser(username: name, name: name, phone: phone, password: password)) {
            result in switch result {
            case let .success(response):
                print(result)
                print(response)
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

struct SignUpUsernameInputView: View {
    @Binding var username: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Username")
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

struct SignUpNameInputView: View {
    @Binding var name: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Full Name")
                .font(Font(UIFont.medium_18))
            VStack {
                TextField("Enter your full name", text: $name)
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

struct SignUpPhoneInputView: View {
    @Binding var phone: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("Phone Number")
                .font(Font(UIFont.medium_18))
            VStack {
                TextField("Enter your phone number", text: $phone)
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

struct SignUpPasswordInputView: View {
    @Binding var password: String
    @Binding var repeat_password: String
    
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
        }
        .padding(.top, 10)
        
        VStack(alignment: .leading) {
            Text("Repeat Password")
                .font(Font(UIFont.medium_18))
            VStack {
                TextField("Repeat your password", text: $password)
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
        }
        .padding(.top, 10)
    }
}

struct SignUpButtonView: View {
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

struct SignUpTermsInputView: View {
    @Binding var checkState: Bool
    var body: some View {
        HStack {
            Button(action: { self.checkState.toggle() }) {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: checkState ? "checkmark.square.fill" : "square")
                        .foregroundColor(Color.black)
                        .font(.system(size: 22))
                }
            }
            Text("I agree with terms and conditions")
                .font(Font(UIFont.regular_18))
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
