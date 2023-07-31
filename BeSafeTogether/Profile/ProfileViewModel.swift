//
//  ProfileViewModel.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 31.07.2023.
//

import Foundation

class ProfileViewModel: ObservableObject {
    private let apiManager = APIManager.shared
    
    @Published var words = [UserWord]()
    
    func addWord(word: String) {
        apiManager.addWord(word: word) { [weak self] in
            self?.getWords()
        }
    }
    
    func getWords() {
        apiManager.getWords { [weak self] userWords in
            self?.words = userWords
            WordsAndContactsStorage.shared.words = .init(words: userWords)
        }
    }

    func deleteWord(wordId: String) {
        apiManager.deleteWord(wordId: wordId) { [weak self] in
            self?.getWords()
        }
    }
}
