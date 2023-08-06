//
//  APIManager.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 24.07.2023.
//

import Foundation
import Moya
import KeychainAccess
import MapKit

struct APIManager {
    static let shared = APIManager()
    
    let keychain = Keychain(service: "com.BeSafeTogether.service")
    
    let provider = MoyaProvider<Service>()
    
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
                    print(userToken)
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
                } catch {
                    print("Failed to map response to JSON: \(error)")
                }
            case .failure(let error):
                print("Request failed: \(error)")
            }
        }
    }
    
    
    func getUserInfo(completion: @escaping (Result<UserData, Error>) -> Void) {
        let provider = self.bearerProvider
        
        provider.request(.getUserInfo) { result in
            switch result {
            case let .success(response):
                do {
                    let userInfo = try response.map(UserData.self)
                    completion(.success(userInfo))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    
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
                    print(userWords)
                    print(response.statusCode)
                    completion(userWords)
                } catch {
                    print("Failed to parse users: \(error)")
                }
            case let .failure(error):
                print("API request failed: \(error)")
            }
        }
    }
    
    func addContact(username: String, completion: @escaping () -> Void) {
        let provider = self.bearerProvider
        
        provider.request(.addContact(username: username)) { result in
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
                    print("00000000000000000000000000000000000000000000000000000000000000000")
                    let userContacts = try response.map(UserContacts.self).contacts
                    print(userContacts)
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
    
    func checkForThreat(completion: @escaping ([MapAnnotationItem]) -> Void) {
        let provider = self.bearerProvider
        
        provider.request(.checkForThreat) { result in
            switch result {
            case let .success(response):
                do {

                    let threats = try response.map(Threats.self).threats

                    // Create MapAnnotationItem for each threat
                    var threatLocations: [MapAnnotationItem] = []
                    for threat in threats {
                        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(threat.latitude), longitude: CLLocationDegrees(threat.longitude))
                        let annotation = MapAnnotationItem(coordinate: coordinate, title: threat.username)
                        threatLocations.append(annotation)
                    }
                    
                    completion(threatLocations)
                    
                } catch let error {
                    print("Mapping error: \(error.localizedDescription)")
                }
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func updateLocation(latitude: Float, longitude: Float) {
        let provider = self.bearerProvider
        
        provider.request(.updateLocation(latitude: latitude, longitude: longitude)) { result in
            switch result {
            case .success:
                print(result)
            case let .failure(error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
