//
//  ProfileView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 21.06.2023.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            ProfileInfoView()
            
            Spacer()
        }
    }
}

struct ProfileInfoView: View {
    
    let h3 = UIFont.systemFont(ofSize: 18, weight: .semibold, width: .standard)
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("purple 100"))
                .frame(width: 360.0, height: 110)
                .cornerRadius(20)
                .padding(10)
            
            HStack{
                ZStack{
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.white)
                }
                
                Text("Username")
                    .font(Font(h3))
                    .foregroundColor(Color.white)

            }
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
