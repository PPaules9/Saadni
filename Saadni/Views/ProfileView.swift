//
//  ProfileView.swift
//  Saadni
//
//  Created by Pavly Paules on 06/02/2026.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                Text("Profile")
                    .foregroundStyle(.white)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
