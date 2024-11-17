//
//  ProfileView.swift
//  movapp
//
//  Created by Ajie DR on 10/11/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Image(ImageResource.myPicture)
                .resizable()
                .scaledToFit()
                .clipped()
                .clipShape(.circle)
                .frame(width: 100, height: 100)
            Text("yourname")
            Text("youremail@gmail.com")
        }
        .navigationTitle("Profile")
    }
}


#Preview {
    ProfileView()
}
