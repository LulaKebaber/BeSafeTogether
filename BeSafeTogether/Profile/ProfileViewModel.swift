//
//  ProfileViewModel.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 31.07.2023.
//

import Foundation

class ProfileViewModel: ObservableObject {
    private let apiManager = APIManager.shared
    
    @Published var username: String = ""
    @Published var words = [UserWord]()
    
    func addWord(word: String) {
        apiManager.addWord(word: word) { [weak self] in
            self?.getWords()
        }
    }
    
    func getWords() {
        apiManager.getWords { [weak self] userWords in
            self?.words = userWords
            print(userWords)
            WordsAndContactsStorage.shared.words = .init(words: userWords)
        }
    }

    func deleteWord(wordId: String) {
        apiManager.deleteWord(wordId: wordId) { [weak self] in
            self?.getWords()
        }
    }
    
    func getUserInfo() {
        apiManager.getUserInfo { result in
            switch result {
            case let .success(userData):
                DispatchQueue.main.async {
                    self.username = userData.username
                }
            case let .failure(error):
                print("Error fetching user info: \(error.localizedDescription)")
            }
        }
    }
}
