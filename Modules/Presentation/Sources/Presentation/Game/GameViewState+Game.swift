//
//  File.swift
//  Presentation
//
//  Created by Michał Wolanin on 26/09/2026.
//

import DesignSystem
import Domain

extension GameViewState {

    /// Draws a game.
    ///
    /// - Parameters:
    ///   - game: The game to draw.
    ///   - turn: What the last intent did, or `nil` once it has played out.
    ///     Tiles that merged away are drawn only while it is set.
    init(game: Game, turn: Turn?) {
        let merged = Set(turn?.merges.map(\.result.id) ?? [])
        let spawned = Set(turn?.spawned.map(\.tile.id) ?? [])

        let absorbed = (turn?.merges ?? []).flatMap { merge in
            merge.sources.map { source in
                BoardTile(id: source.id, value: source.value, position: merge.position, kind: .absorbed)
            }
        }

        let onBoard = game.board.tiles.map { placed in
            let id = placed.tile.id
            let kind: BoardTile.Kind =
                if merged.contains(id) { .merged }
                else if spawned.contains(id) { .spawned }
                else { .resting }
            return BoardTile(id: id, value: placed.tile.value, position: placed.position, kind: kind)
        }

        self.init(
            boardSize: game.board.size,
            tiles: absorbed + onBoard,
            message: Message(status: game.status, score: game.score)
        )
    }
}

private extension GameViewState.Message {

    init?(status: Game.Status, score: Int) {
        switch status {
        case .playing: return nil
        case .won: self = .won
        case .over: self = .over(score: score)
        }
    }
}
