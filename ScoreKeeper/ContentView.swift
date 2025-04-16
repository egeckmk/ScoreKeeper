//
//  ContentView.swift
//  ScoreKeeper
//
//  Created by Ege Çakmak on 4.04.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var scoreboard = Scoreboard(state: .setup, doesHighestScoreWin: true, playerCount: 2)
    
    @State private var startingPoints = 0
    @FocusState private var focusedPlayerIndex: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Score Keeper")
                .font(.title)
                .bold()
                .padding(.bottom)
            
            SettingsView(startingPoints: $startingPoints, doesHighestScoreWin: $scoreboard.doesHighestScoreWin, playerCount: $scoreboard.playerCount)
                .disabled(scoreboard.state != .setup)
                .onChange(of: scoreboard.playerCount) { oldValue, newValue in
                    if scoreboard.state == .setup {
                        let oldCount = scoreboard.players.count
                        scoreboard.updatePlayerCount()
                        
                        // Eğer oyuncu eklendiyse, yeni eklenen ilk oyuncuya odaklan
                        if scoreboard.players.count > oldCount && focusedPlayerIndex == nil {
                            focusedPlayerIndex = oldCount
                        }
                        
                        // Eğer odaklanılan oyuncu silindiyse, focus'u güncelle
                        if let focused = focusedPlayerIndex, focused >= scoreboard.players.count {
                            focusedPlayerIndex = scoreboard.players.count - 1
                        }
                    }
                }
            
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
                
                ForEach(Array(scoreboard.players.indices), id: \.self) { index in
                    GridRow {
                        HStack {
                            if scoreboard.winners.contains(scoreboard.players[index]) {
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(Color.yellow)
                            }
                            
                            TextField("Name", text: $scoreboard.players[index].name)
                                .autocorrectionDisabled()
                                .focused($focusedPlayerIndex, equals: index)
                                .submitLabel(index == scoreboard.players.count - 1 ? .done : .next)
                                .onSubmit {
                                    if index < scoreboard.players.count - 1 {
                                        focusedPlayerIndex = index + 1
                                    } else {
                                        focusedPlayerIndex = nil
                                    }
                                }
                        }
                        
                        Text("\(scoreboard.players[index].score)")
                            .opacity(scoreboard.state == .setup ? 0 : 1.0)
                        
                        Stepper("\(scoreboard.players[index].score)", value: $scoreboard.players[index].score)
                            .labelsHidden()
                            .opacity(scoreboard.state == .setup ? 0 : 1.0)
                    }
                    Divider()
                }
            }
            .padding(.vertical)
            
//            Button("Add Player", systemImage: "plus") {
//                scoreboard.players.append(Player(name: "", score: 0))
//            }
//            .opacity(scoreboard.state == .setup ? 1.0 : 0)
//            
            Spacer()
            
            HStack {
                Spacer()
                
                switch scoreboard.state {
                case .setup:
                    Button("Start Game", systemImage: "play.fill") {
                        scoreboard.updatePlayerCount()
                        if !scoreboard.checkMinPlayerCount() {
                            scoreboard.resetScores(to: startingPoints)
                            scoreboard.state = .playing
                            focusedPlayerIndex = nil
                        }
                    }
                case .playing:
                    Button("End Game", systemImage: "stop.fill") {
                        scoreboard.state = .gameOver
                    }
                case .gameOver:
                    Button("Reset Game", systemImage: "arrow.counterclockwise") {
                        scoreboard.state = .setup
                        focusedPlayerIndex = nil
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
