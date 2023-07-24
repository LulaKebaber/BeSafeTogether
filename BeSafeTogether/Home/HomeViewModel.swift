//
//  HomeViewModel.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 21.06.2023.
//

import Foundation


class HomeViewModel: ObservableObject {
    @Published var isGpsEnabled = false
    @Published var isContactsSet = false
    var isStopWordsSet: Bool {
        guard let userWords = WordsAndContactsStorage.shared.words else { return false }
        return !userWords.words.isEmpty
    }
    @Published var recordings: [String] = []
    
    var isRequirementsMet: Bool {
        return isGpsEnabled && isContactsSet && isStopWordsSet
    }
}
