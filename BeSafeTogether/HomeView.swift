//
//  HomeView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 21.06.2023.
//

import SwiftUI

struct HomeView: View {
    
//    var isGpsEnabled = false
//    var isContactsSet = false
//    var isStopWordsSet = false
    
    let h6 = UIFont.systemFont(ofSize: 32, weight: .bold, width: .standard)
    
    var body: some View {
        VStack {
            Text("Welcome Home!")
                .font(Font(h6))
                .padding(.top, 10)
            
            MicButton()
                .padding(.top, 30)
            Spacer()
            
            RequirementsList()
                .padding(.bottom, 25)
            
        }
    }
}

struct MicButton: View {
    
    let h3 = UIFont.systemFont(ofSize: 18, weight: .semibold, width: .standard)
    
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
                    .font(Font(h3))
                    .padding(.top, 14)
                    .foregroundColor(Color("gray 50"))
            }
        }
    }
}

struct RequirementsList: View {
    
    let h5 = UIFont.systemFont(ofSize: 26, weight: .regular, width: .standard)
    let h2 = UIFont.systemFont(ofSize: 18, weight: .medium, width: .standard)
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("purple 100"))
                .frame(width: 360.0, height: 240)
                .cornerRadius(25)
                .padding(10)
            VStack {
                Text("Requieremnts to use")
                    .foregroundColor(Color.white)
                    .font(Font(h5))
                
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                                .foregroundColor(Color("purple 100"))
                                .frame(width: 23, height: 23)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color.white, lineWidth: 2.5)
                                )
                                .padding(.leading, 40)
                    Text("GPS is enabled")
                        .foregroundColor(Color.white)
                        .font(Font(h2))
                    Spacer()
                    Button(action: {}){
                        Image(systemName: "arrow.forward")
                            .foregroundColor(Color.white)
                            .font(.system(size: 25))
                            .padding(.trailing, 40)
                    }
                }.padding(.top, 5)
                
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                                .foregroundColor(Color("purple 100"))
                                .frame(width: 23, height: 23)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color.white, lineWidth: 2.5)
                                )
                                .padding(.leading, 40)
                    Text("Contacts are set")
                        .foregroundColor(Color.white)
                        .font(Font(h2))
                    Spacer()
                    Button(action: {}){
                        Image(systemName: "arrow.forward")
                            .foregroundColor(Color.white)
                            .font(.system(size: 25))
                            .padding(.trailing, 40)
                    }
                }.padding(.top, 15)

                HStack {
                    RoundedRectangle(cornerRadius: 4)
                                .foregroundColor(Color("purple 100"))
                                .frame(width: 23, height: 23)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color.white, lineWidth: 2.5)
                                )
                                .padding(.leading, 40)
                    Text("Stop words are set")
                        .foregroundColor(Color.white)
                        .font(Font(h2))
                    Spacer()
                    Button(action: {}){
                        Image(systemName: "arrow.forward")
                            .foregroundColor(Color.white)
                            .font(.system(size: 25))
                            .padding(.trailing, 40)
                    }
                }.padding(.top, 15)
            }
            .padding(.bottom, 15)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
