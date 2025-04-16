//
//  ScoreKeeperTests.swift
//  ScoreKeeperTests
//
//  Created by Ege Çakmak on 5.04.2025.
//

import Testing
@testable import ScoreKeeper

struct ScoreKeeperTests {
    
    @Test("Reset player scores", arguments: [0, 10, 20])
    func resetScores(to newValue: Int) async throws {
        var scoreboard = Scoreboard(
            state: GameState.gameOver,
            doesHighestScoreWin: true,
            playerCount: 2
        )
        
        scoreboard.players.append(Player(name: "Elisha", score: 0))
        scoreboard.players.append(Player(name: "Andre", score: 5))
        
        scoreboard.resetScores(to: newValue)
        
        for player in scoreboard.players {
            #expect(player.score == newValue)
        }
    }
    
    @Test("Highest score wins")
    func highestScoreWins() {
        var scoreboard = Scoreboard(
            state: GameState.gameOver,
            doesHighestScoreWin: true,
            playerCount: 2
        )
        
        scoreboard.players = [
            Player(name: "Elisha", score: 0),
            Player(name: "Andre", score: 4)
        ]
        
        let winners = scoreboard.winners
        #expect(winners == [Player(name: "Andre", score: 4)])
    }
    
    @Test("Lowest score wins")
    func lowestScoreWins() {
        var scoreboard = Scoreboard(
            state: GameState.gameOver,
            doesHighestScoreWin: false,
            playerCount: 2
        )
        
        scoreboard.players = [
            Player(name: "Elisha", score: 0),
            Player(name: "Andre", score: 4)
        ]
        
        let winners = scoreboard.winners
        #expect(winners == [Player(name: "Elisha", score: 0)])
    }
}
