//
//  ProfileView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 21.06.2023.
//

import SwiftUI
import Moya
import KeychainAccess
import AVFoundation

struct ProfileView: View {
    @State var word: String = ""
    @State var words: [(String, String)] = []
    @StateObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileInfoView()
                StopWordsView(word: $word, words: $words, addWordAction: {
                    profileViewModel.addWord(word: word)
                })
                ContactsButtonView()
                Spacer()
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
    @StateObject var profileViewModel = ProfileViewModel()
    var addWordAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Stop Words")
                .font(Font(UIFont.bold_26))
                .padding(.top, 20)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 360, height: 35)
            list
            AddWordView(word: $word, addWordAction: addWordAction)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 360, height: 385)
                .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2)
        )
        .frame(width: 360, height: 385)
        .onAppear {
            profileViewModel.getWords()
        }
    }
    
    var list: some View {
        List(profileViewModel.words) { word in
            WordView(word: word.word, date: word.timestamp)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    HStack{
                        Button(action: {
                            profileViewModel.deleteWord(wordId: word.id)
                        }, label: {
                            Label("Удалить", systemImage: "trash")
                        })
                        .tint(.red)
                    }
                }
        }
        .listStyle(.plain)
        .background(.white)
    }
}

struct WordView: View {
    var word : String
    var date = ""
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(word)
                    .font(Font(UIFont.semibold_18))
                Text(date)
                    .font(Font(UIFont.regular_14))
            }
            Spacer()
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
    @StateObject var profileViewModel = ProfileViewModel()
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
        .onAppear {
            profileViewModel.getWords()
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
