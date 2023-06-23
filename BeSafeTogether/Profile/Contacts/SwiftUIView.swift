//
//  SwiftUIView.swift
//  BeSafeTogether
//
//  Created by Danial Baizak on 23.06.2023.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        VStack {
            Text("My Contacts")
                .font(Font(UIFont.bold_32))
                .padding()
            Spacer()
        }
    }
}

struct ContactsView: View {
    var body: some View {
        Text("m")
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
