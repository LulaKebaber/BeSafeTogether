//
//  ProfileView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 21.06.2023.
//

import SwiftUI
import Moya
import KeychainAccess

struct ProfileView: View {
    @State var word: String = ""
    @State var words: [(String, String)] = []
    let keychain = Keychain(service: "com.BeSafeTogether.service")
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileInfoView()
                StopWordsView(word: $word, words: $words, addWordAction: addWord)
                ContactsButtonView()
                Spacer()
                
                Button(action:{getWords()}) {
                    Text("dwwd")
                }
            }
        }
    }
    
    func addWord() {
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
        
        provider.request(.addWord(word: word)) {
            result in switch result {
            case let .success(response):
                print(response)
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getWords() {
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
        provider.request(.getWords) { result in
            switch result {
            case let .success(response):
                do {
                    let userWords = try response.map(UserWords.self).words
                    for word in userWords {
                        words.append((word.word, word.timestamp))
                    }
                    print(words)
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

struct ProfileInfoView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: 360.0, height: 110)
                .cornerRadius(20)
                .padding(10)
            
            HStack {
                ZStack{
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.white)
                }
                
                Text("Username")
                    .font(Font(UIFont.medium_22))
                    .foregroundColor(Color.white)
                    .padding(.leading, 5)
                Spacer()
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 30.0, height: 30)
                    .foregroundColor(Color.white)
                
            }
            .padding(.leading, 36)
            .padding(.trailing, 45)
        }
    }
}

struct StopWordsView: View {
    @Binding var word: String
    @Binding var words: [(String, String)]
    var addWordAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Stop Words")
                .font(Font(UIFont.bold_26))
                .padding(.top, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            ScrollView {
                VStack {
                    ForEach(words.indices, id: \.self) { index in
                        WordView(word: words[index].0, date: words[index].1)
                            .padding(.horizontal, 10) // Add horizontal padding
                    }
                }
                .padding(.bottom, 20)
            }
            
            AddWordView(word: $word, addWordAction: addWordAction)
                .padding(.horizontal, 10) // Add horizontal padding
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 360, height: 380)
                .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2)
        )
        .frame(width: 360, height: 380)
    }
}

struct WordView: View {
    var word : String
    var date = "15 oct, 2022 - 10:23"
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(word)
                    .font(Font(UIFont.semibold_18))
                    .padding(.bottom, 0.01)
                Text(date)
                    .font(Font(UIFont.regular_14))
            }
            Spacer()
            Image(systemName: "trash.fill")
                .resizable()
                .frame(width: 22, height: 25)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .frame(width: 320, height: 70)
            .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2))
        .frame(width: 320, height: 70)
    }
}

struct AddWordView: View {
    @Binding var word: String
    var addWordAction: () -> Void
    
    var body: some View {
        HStack {
            TextField("Enter a word", text: $word)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {addWordAction()}){
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color.black)
                        .frame(width: 80, height: 33)
                    Text("Add")
                        .foregroundColor(Color.white)
                }
            }
            .padding(.trailing, 20)
        }
    }
}

struct ContactsButtonView: View {
    var body: some View {
        Button(action: {}) {
            NavigationLink(destination: ContactsView()) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.black)
                        .frame(width: 360, height: 80)
                    Text("My Contacts")
                        .foregroundColor(Color.white)
                        .font(Font(UIFont.medium_26))
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
