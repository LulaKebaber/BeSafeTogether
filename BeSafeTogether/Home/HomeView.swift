//
//  HomeView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 21.06.2023.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel = HomeViewModel()
        
    var body: some View {
        VStack {
            Text("Welcome Home!")
                .font(Font(UIFont.bold_32))
                .padding(.top, 10)
            
            MicButton()
                .padding(.top, 60)
            
            Spacer()
            
            RequirementsList()
                .padding(.bottom, 25)
            
        }
    }
}

struct MicButton: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color("gray 25"))
                .frame(width: 220)
            VStack {
                Image(systemName: "mic.fill")
                    .resizable()
                    .frame(width: 55, height: 80)
                    .foregroundColor(Color("gray 50"))
                Text("Start scanning")
                    .font(Font(UIFont.semibold_18))
                    .padding(.top, 14)
                    .foregroundColor(Color("gray 50"))
            }
        }
    }
}

struct RequirementsList: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("purple 100"))
                .frame(width: 360.0, height: 220)
                .cornerRadius(25)
                .padding(10)
            VStack {
                Text("Requieremnts to use")
                    .foregroundColor(Color.white)
                    .font(Font(UIFont.regular_26))
                    .padding(.bottom, 10)
                
                OptionVIew(text: "Gps is enabled")
                OptionVIew(text: "Contacts are set")
                OptionVIew(text: "Stop words are set")
            }
        }
    }
}

struct OptionVIew: View {
    var text: String
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color("purple 100"))
                        .frame(width: 23, height: 23)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.white, lineWidth: 2.5)
                        )
                        .padding(.leading, 50)
            Text(text)
                .foregroundColor(Color.white)
                .font(Font(UIFont.medium_18))
                .padding(.leading, 4)
            Spacer()
            Button(action: {}){
                Image(systemName: "arrow.forward")
                    .foregroundColor(Color.white)
                    .font(.system(size: 25))
                    .padding(.trailing, 50)
            }
        }.padding(.bottom, 15)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
