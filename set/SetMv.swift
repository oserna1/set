//
//  SetMv.swift
//  set
//
//  Created by Oscar Serna on 3/21/24.
//

import SwiftUI
// TODO: add Observable and change model view model names
class SetMv : ObservableObject {
    
    init() {
        let options = SetGameOptions();
        setGame = SetGame(shapes: options.shapes, opacities: options.opacities, colors: options.colors)
    }
    
    @Published private var setGame: SetGame
    
    var cards: Array<SetGame.Card> {
        return setGame.cards
    }
    
    var dealtCards: Array<SetGame.Card>
    {
        return setGame.cards.filter { $0.isBeingPlayed }
    }
    
    private struct SetGameOptions {
        var shapes: Set<String> = ["diamond", "capsule", "rectangle"]
        var opacities: Set<Double> = [0, 0.3, 1.0]
        var colors: Set<String> = ["red", "green", "purple"]
    }
    
    public func choose(_ card: SetGame.Card) {
        setGame.choose(card)
    }
    
    public func threeNewCards() {
        setGame.makeUnplayedCardsPlayable(isThreeNewCards: true)
    }
    
    public func makeCardPlayable(_ card: SetGame.Card) {
        setGame.makeCardPlayable(card)
    }
    
    public func newGame() {
        let options = SetGameOptions();
        setGame = SetGame(shapes: options.shapes, opacities: options.opacities, colors: options.colors)
    }
}
