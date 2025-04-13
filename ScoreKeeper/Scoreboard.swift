//
//  Scoreboard.swift
//  ScoreKeeper
//
//  Created by Ege Çakmak on 4.04.2025.
//

import Foundation

struct Scoreboard {
    var players: [Player] = []
    
    var state = GameState.setup
    var doesHighestScoreWin = true
    var playerCount = 2
    var showingPlayerCountAlert = false

    init() {
        // Başlangıçta playerCount kadar boş oyuncu ekle
        for _ in 0..<playerCount {
            players.append(Player(name: "", score: 0))
        }
    }

    var winners: [Player] {
        guard state == .gameOver else  { return [] }
        
        var winnnigScore = 0
        
        if doesHighestScoreWin {
            winnnigScore = Int.min
            for player in players {
                winnnigScore = max(player.score, winnnigScore)
            }
        } else {
            winnnigScore = Int.max
            for player in players {
                winnnigScore = min(player.score, winnnigScore)
            }
        }
        
        return players.filter { player in
            player.score == winnnigScore
        }
    }
    
    mutating func resetScores(to newValue: Int){
        for index in 0..<players.count {
            players[index].score = newValue
        }
    }
    
    mutating func checkMinPlayerCount() -> Bool {
        showingPlayerCountAlert = false
        
        if players.count != playerCount
        {
            showingPlayerCountAlert = true
        }
        
        return showingPlayerCountAlert
    }
    
    mutating func updatePlayerCount() {
        if players.count < playerCount {
            // Yeni oyuncular ekle
            let playersToAdd = playerCount - players.count
            for _ in 0..<playersToAdd {
                players.append(Player(name: "", score: 0))
            }
        } else if players.count > playerCount {
            // Fazla oyuncuları kaldır
            players = Array(players.prefix(playerCount))
        }
    }
}
