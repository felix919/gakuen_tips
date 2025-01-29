//
//  NIAScoreView.swift
//  Gakuen_tips
//
//  Created by 松広登 on 2025/01/29.
//

import SwiftUI

struct NIAScoreView: View {
    @State private var first = ParameterType.VOCAL
    @State private var sencond = ParameterType.DANCE
    @State private var third = ParameterType.VISUAL

    var body: some View {
        VStack {
            HStack {
                Text("第１得意: ")
                Picker("Select a paint color", selection: $first) {
                    ForEach(ParameterType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.menu)
            }
            HStack {
                Text("第２得意: ")
                Picker("Select a paint color", selection: $sencond) {
                    ForEach(ParameterType.allCases.filter {
                        $0 != first
                    }, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.menu)
            }
            HStack {
                Text("第３得意: ")
                Picker("Select a paint color", selection: $third) {
                    ForEach(ParameterType.allCases.filter {
                        $0 != first && $0 != sencond
                    }, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.menu)
            }
            
            
            NavigationLink {
                NIAScoreDetailView(
                    first: first, second: sencond, third: third
                )
            } label: {
                Text("スコア計算")
            }.padding(
                EdgeInsets(
                    top: 16, leading: 0, bottom: 0, trailing: 0
                )
            )
        }
        .navigationTitle("得意ステータス")
    }
}

enum ParameterType: String, CaseIterable {
    case VOCAL = "Vocal"
    case DANCE = "Dance"
    case VISUAL = "Visual"
}

#Preview {
    NIAScoreView()
}
