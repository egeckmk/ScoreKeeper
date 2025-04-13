//
//  A.swift
//  ScoreKeeper
//
//  Created by Ege Çakmak on 8.04.2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var startingPoints: Int
    @Binding var doesHighestScoreWin: Bool
    @Binding var playerCount: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("Game Rules")
                .font(.headline)
            Divider()
            
            Picker("Min player count", selection: $playerCount) {
                Text("2 Players")
                    .tag(2)
                Text("3 Players")
                    .tag(3)
                Text("4 Players")
                    .tag(4)
                Text("5 Players")
                    .tag(5)
                Text("6 Players")
                    .tag(6)
                Text("7 Players")
                    .tag(7)
                Text("8 Players")
                    .tag(8)
                Text("9 Players")
                    .tag(9)
                Text("10 Players")
                    .tag(10)
            }
            
            Picker("Win condition", selection: $doesHighestScoreWin) {
                Text("Highest Score Wins")
                    .tag(true)
                Text("Lowest Score Wins")
                    .tag(false)
            }
            
            Picker("Starting points", selection: $startingPoints) {
                Text("0 starting points")
                    .tag(0)
                Text("10 starting points")
                    .tag(10)
                Text("20 starting points")
                    .tag(20)
            }
        }
        .padding()
        .background(.thinMaterial, in: .rect(cornerRadius: 8))
    }
}

#Preview {
    @Previewable @State var startingPoints = 10
    @Previewable @State var doesHighestScoreWin = true
    @Previewable @State var playerCount = 2
    SettingsView(startingPoints: $startingPoints, doesHighestScoreWin: $doesHighestScoreWin, playerCount: $playerCount)
}
