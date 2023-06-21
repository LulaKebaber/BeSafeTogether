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
    @Published var isStopWordsSet = false
}

