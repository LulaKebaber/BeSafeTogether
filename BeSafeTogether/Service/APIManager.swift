// APIManager.swift

import Foundation
import Moya
import KeychainAccess

struct APIManager {
    static let shared = APIManager()
    
    let keychain = Keychain(service: "com.BeSafeTogether.service") // Changed access level to 'internal'
    
    // Removed the access modifier for 'provider' to make it 'internal'
    var provider: MoyaProvider<Service> {
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
    
    func addWord(word: String, completion: @escaping () -> Void) {
            let provider = self.provider

            provider.request(.addWord(word: word)) { result in
                switch result {
                case .success:
                    // Call the completion handler after successfully adding the word
                    completion()
                case let .failure(error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    
    func getWords(completion: @escaping ([UserWord]) -> Void) {
            let provider = self.provider
            
            provider.request(.getWords) { result in
                switch result {
                case let .success(response):
                    do {
                        let userWords = try response.map(UserWords.self).words
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
            let provider = self.provider
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
            let provider = self.provider

            provider.request(.getContacts) { result in
                switch result {
                case let .success(response):
                    do {
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
}

