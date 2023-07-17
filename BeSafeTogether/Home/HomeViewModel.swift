//
//  HomeViewModel.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 21.06.2023.
//

import Foundation


class HomeViewModel: ObservableObject {
    @Published var isGpsEnabled = true
    @Published var isContactsSet = true
    @Published var isStopWordsSet = true
    @Published var recordings: [String] = []
    
    var isRequirementsMet: Bool {
        return isGpsEnabled && isContactsSet && isStopWordsSet
    }
}
