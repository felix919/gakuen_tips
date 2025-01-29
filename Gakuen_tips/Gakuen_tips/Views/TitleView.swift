//
//  ContentView.swift
//  Gakuen_tips
//
//  Created by 松広登 on 2025/01/29.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "dollarsign")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                
                NavigationLink {
                    NIAScoreView()
                } label: {
                    Text("NIA Score計算")
                }.padding(
                    EdgeInsets(
                        top: 16, leading: 0, bottom: 0, trailing: 0
                    )
                )
            }
            .padding()
        }
    }
}

#Preview {
    TitleView()
}
