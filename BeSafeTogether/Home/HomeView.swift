//
//  HomeView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 21.06.2023.
//

import SwiftUI

enum MicButtonView {
    case noRequirements
    case requirementsMet
}

struct HomeView: View {
    
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Text("Welcome Home!")
                .font(Font(UIFont.bold_32))
                .padding(.top, 30)
            //            Text(homeViewModel.isStopWordsSet)
            MicButton(homeViewModel: homeViewModel)
                .padding(.top, 60)
            
            Spacer()
            
            RequirementsList(homeViewModel: homeViewModel)
                .padding(.bottom, 25)
        }
    }
}

struct MicButton: View {
    @ObservedObject var homeViewModel: HomeViewModel
    @State private var selectedView: MicButtonView = .noRequirements
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color("gray 25"))
                .frame(width: 220)
            
            VStack {
                switch selectedView {
                case .noRequirements:
                    Image(systemName: "mic.fill")
                        .resizable()
                        .frame(width: 55, height: 80)
                        .foregroundColor(Color("gray 50"))
                    Text("No requirements")
                        .font(Font(UIFont.semibold_18))
                        .padding(.top, 14)
                        .foregroundColor(Color("gray 50"))
                case .requirementsMet:
                    Image(systemName: "mic.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.green)
                    Text("Requirements met")
                        .font(Font(UIFont.semibold_18))
                        .padding(.top, 14)
                        .foregroundColor(.green)
                }
            }
        }
    }
}


struct RequirementsList: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: 360.0, height: 220)
                .cornerRadius(25)
                .padding(10)
            VStack {
                Text("Requieremnts to use")
                    .foregroundColor(Color.white)
                    .font(Font(UIFont.regular_26))
                    .padding(.bottom, 10)
                
                OptionView(text: "Gps is enabled", checkState: homeViewModel.isGpsEnabled)
                OptionView(text: "Contacts are set", checkState: homeViewModel.isContactsSet)
                OptionView(text: "Stop words are set", checkState: homeViewModel.isStopWordsSet)
            }
        }
    }
}

struct OptionView: View {
    var text: String
    @State var checkState: Bool
    
    var body: some View {
        HStack {
            Button(action: { self.checkState.toggle() }) {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: checkState ? "checkmark.square.fill" : "square")
                        .foregroundColor(Color.white)
                        .font(.system(size: 30))
                }
            }
            Text(text)
                .foregroundColor(Color.white)
                .font(Font(UIFont.medium_18))
            Spacer()
            Button(action: {}){
                Image(systemName: "arrow.forward")
                    .foregroundColor(Color.white)
                    .font(.system(size: 25))
            }
        }
        .padding([.leading, .trailing], 47)
        .padding(.bottom, 3)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
