//
//  ContentView.swift
//  ScoreKeeper
//
//  Created by Ege Çakmak on 4.04.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var scoreboard = Scoreboard()
    @State private var startingPoints = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Score Keeper")
                .font(.title)
                .bold()
                .padding(.bottom)
            
            SettingsView(startingPoints: $startingPoints, doesHighestScoreWin: $scoreboard.doesHighestScoreWin, playerCount: $scoreboard.playerCount)
                .disabled(scoreboard.state != .setup)
            //                .opacity(scoreboard.state != .setup ? 0 : 1.0)
            
            Grid {
                GridRow {
                    Text("Player")
                        .gridColumnAlignment(.leading)
                        .fontWeight(.black)
                    Text("Score")
                        .opacity(scoreboard.state == .setup ? 0 : 1.0)
                        .fontWeight(.black)
                }
                .font(.headline)
                
                Divider()
                
                ForEach($scoreboard.players) { $player in
                    GridRow {
                        HStack {
                            if scoreboard.winners.contains(player) {
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(Color.yellow)
                            }
                            
                            TextField("Name", text: $player.name)
                                .autocorrectionDisabled()
                        }
                        
                        Text("\(player.score)")
                            .opacity(scoreboard.state == .setup ? 0 : 1.0)
                        
                        Stepper("\(player.score)", value: $player.score)
                            .labelsHidden()
                            .opacity(scoreboard.state == .setup ? 0 : 1.0)
                    }
                    Divider()
                }
            }
            .padding(.vertical)
            
            Button("Add Player", systemImage: "plus") {
                scoreboard.players.append(Player(name: "", score: 0))
            }
            .opacity(scoreboard.state == .setup ? 1.0 : 0)
            
            Spacer()
            
            HStack {
                Spacer()
                
                switch scoreboard.state {
                case .setup:
                    Button("Start Game", systemImage: "play.fill") {
                        if !scoreboard.checkMinPlayerCount() {
                            scoreboard.resetScores(to: startingPoints)
                            scoreboard.state = .playing
                        }
                    }
                case .playing:
                    Button("End Game", systemImage: "stop.fill") {
                        scoreboard.state = .gameOver
                    }
                case .gameOver:
                    Button("Reset Game", systemImage: "arrow.counterclockwise") {
                        scoreboard.state = .setup
                    }
                }
                
                Spacer()
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .tint(.blue)
            
        }
        .padding()
        .alert(isPresented: $scoreboard.showingPlayerCountAlert) {
            Alert(
                title: Text("Uyarı"),
                message: Text("Oyuna başlamak için en az \(scoreboard.playerCount) oyuncu olmalı."),
                dismissButton: .default(Text("Tamam"))
            )
        }
    }
}

#Preview {
    ContentView()
} 