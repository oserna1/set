//
//  SetMv.swift
//  set
//
//  Created by Oscar Serna on 3/21/24.
//

import SwiftUI
// todo add Observable
class SetMv : ObservableObject {
    
    init() {
        let options = SetGameOptions();
        model = SetGame(shapes: options.shapes, opacities: options.opacities, colors: options.colors)
    }
    
    @Published private var model: SetGame
    
    var cards: Array<SetGame.Card> {
        return model.cards
    }
    
    var dealtCards: Array<SetGame.Card>
    {
        return model.cards.filter { $0.isBeingPlayed }
    }
    
    private struct SetGameOptions {
        var shapes: Set<String> = ["diamond", "capsule", "rectangle"]
        var opacities: Set<Double> = [0, 0.3, 1.0]
        var colors: Set<String> = ["red", "green", "purple"]
    }
    
    public func choose(_ card: SetGame.Card) {
        model.choose(card)
    }
    
    public func threeNewCards() {
        model.makeUnplayedCardsPlayable(isThreeNewCards: true)
    }
    
    public func newGame() {
        let options = SetGameOptions();
        model = SetGame(shapes: options.shapes, opacities: options.opacities, colors: options.colors)
    }
}
