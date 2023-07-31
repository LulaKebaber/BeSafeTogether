//
//  APIManager.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 24.07.2023.
//

import Foundation
import Moya
import KeychainAccess

struct APIManager {
    static let shared = APIManager()
    
    let keychain = Keychain(service: "com.BeSafeTogether.service")
    
    var bearerProvider: MoyaProvider<Service> {
        // Retrieve the bearer token from Keychain
        guard let savedBearerToken = keychain["BearerToken"] else {
            print("Bearer token not found in Keychain")
            fatalError("Bearer token not found in Keychain")
        }
        
        // Create a custom endpoint closure to add the Authorization header
        let endpointClosure = { (target: Service) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "Bearer \(savedBearerToken)"])
        }
        
        // Create a MoyaProvider instance with the custom endpoint closure
        return MoyaProvider<Service>(endpointClosure: endpointClosure)
    }
    
    let provider = MoyaProvider<Service>()
    
    func registerNewUser(username: String, name: String, phone: String, password: String) {
        let provider = self.provider
        
        provider.request(.registerNewUser(username: username, name: name, phone: phone, password: password)) { result in
            switch result {
            case .success:
                print(result)
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func loginUser(username: String, password: String, completion: (() -> Void)? = nil) {
        let provider = self.provider
        
        provider.request(.loginUser(username: username, password: password)) { result in
            switch result {
            case let .success(response):
                do {
                    print(response)
                    let userToken = try response.map(UserToken.self)
                    self.keychain["BearerToken"] = userToken.access_token
                } catch {
                    print("Failed to parse UserToken: \(error)")
                }
                completion?()
            case let .failure(error):
                // Handle error, display alert, etc.
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func sendTranscriptionRequest(audioFileURL: URL) {
        let provider = self.bearerProvider
        provider.request(.transcribe(audioFile: audioFileURL, model: "whisper-1")) { result in
            switch result {
            case .success(let response):
                do {
                    let jsonResponse = try response.mapJSON()
                    print(jsonResponse)
//                    print(response)
                } catch {
                    print("Failed to map response to JSON: \(error)")
                }
            case .failure(let error):
                print("Request failed: \(error)")
            }
        }
    }

    
//    func getUserInfo() {
//
//        let provider = self.bearerProvider
//        
//        provider.request(.getUserInfo) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    let users = try response.map(UserData.self)
//                } catch {
//                    print("Failed to parse users: \(error)")
//                }
//            case let .failure(error):
//                print("API request failed: \(error)")
//            }
//        }
//    }
    
    func addWord(word: String, completion: @escaping () -> Void) {
        let provider = self.bearerProvider
        
        provider.request(.addWord(word: word)) { result in
            switch result {
            case .success:
                completion()
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getWords(completion: @escaping ([UserWord]) -> Void) {
        let provider = self.bearerProvider
        
        provider.request(.getWords) { result in
            switch result {
            case let .success(response):
                do {
                    let userWords = try response.map(UserWords.self).words
                    print(response)
                    completion(userWords)
                } catch {
                    print("Failed to parse users: \(error)")
                }
            case let .failure(error):
                print("API request failed: \(error)")
            }
        }
    }
    
    func addContact(firstName: String, lastName: String, phoneNumber: String, gps: Bool, completion: @escaping () -> Void) {
        let provider = self.bearerProvider
        let name = firstName + " " + lastName
        
        provider.request(.addContact(name: name, phone: phoneNumber, gps: gps)) { result in
            switch result {
            case .success:
                completion()
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getContacts(completion: @escaping ([UserContact]) -> Void) {
        let provider = self.bearerProvider
        
        provider.request(.getContacts) { result in
            switch result {
            case let .success(response):
                do {
                    print(response)
                    let userContacts = try response.map(UserContacts.self).contacts
                    completion(userContacts)
                } catch {
                    print("Failed to parse users: \(error)")
                }
            case let .failure(error):
                print("API request failed: \(error)")
            }
        }
    }
    
    func deleteContact(contactId: String, completion: @escaping () -> Void) {
        let provider = self.bearerProvider

        provider.request(.deleteContact(contactId: contactId)) { result in
            switch result {
            case .success:
                completion()
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteWord(wordId: String, completion: @escaping () -> Void) {
        let provider = self.bearerProvider

        provider.request(.deleteWord(wordId: wordId)) { result in
            switch result {
            case .success:
                completion()
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
