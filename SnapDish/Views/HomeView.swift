//
//  HomeView.swift
//  SnapDish
//
//  Created by Lucas Santos on 22/11/24.
//

import SwiftUI

struct HomeView: View {
    @State private var items: [Item] = []
    @State private var showingCamera = false

    var body: some View {
        NavigationView {
            List(items) { item in
                HStack {
                    Image(uiImage: item.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    Text(item.name)
                }
            }
            .navigationTitle("Alimentos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCamera = true
                    }) {
                        Image(systemName: "camera")
                    }
                }
            }
            .sheet(isPresented: $showingCamera) {
                CameraView(items: $items)
            }
        }
    }
}



#Preview {
    HomeView()
}
