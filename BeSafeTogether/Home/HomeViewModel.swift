//
//  HomeViewModel.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 21.06.2023.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    
        @Published var isGpsEnabled = true
    @Published var isContactsSet = true
    @Published var isStopWordsSet = true
    
//        var isContactsSet: Bool {
//            guard let userWords = WordsAndContactsStorage.shared.contacts else { return false }
//            return !userWords.contacts.isEmpty
//        }
//    
//        var isStopWordsSet: Bool {
//            guard let userWords = WordsAndContactsStorage.shared.words else { return false }
//            return !userWords.words.isEmpty
//        }
    
        var isRequirementsMet: Bool {
            return isGpsEnabled && isContactsSet && isStopWordsSet
        }
}
