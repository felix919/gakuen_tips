//
//  ContentView.swift
//  Gakuen_tips
//
//  Created by 松広登 on 2025/01/29.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("gakuen")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
