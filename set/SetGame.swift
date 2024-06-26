//
//  SetGame.swift
//  set
//
//  Created by Oscar Serna on 3/21/24.
//

import Foundation

struct SetGame {
    private(set) var cards: Array<Card>
    
    init(shapes: Set<String>, opacities: Set<Double>, colors: Set<String>) {
        cards = Array<Card>()
        var id = 0;
        for shapeCount in 1...shapes.count {
            for opacity in opacities {
                for shape in shapes {
                    for color in colors {
                        cards.append(Card(shape: shape, shapecount: shapeCount, opacity: opacity, color: color, id: id))
                        id += 1;
                    }
                }
            }
        }
        makeUnplayedCardsPlayable()
    }
    
    private func isSet(_ cards: Array<Card>) -> Bool {
        if (cards.count == 3) {
            let colors = Set(cards.map { $0.color }).count % 3
            let shapes = Set(cards.map { $0.shape }).count % 3
            let shapeCounts = Set(cards.map { $0.shapecount }).count % 3
            let shades = Set(cards.map { $0.opacity }).count % 3
            
            return (colors + shapes + shapeCounts + shades) <= 4
        }
        return false;
    }
    
    private func isPlayable (_ card: Card) -> Bool {
        return !card.isSelected && !card.isSelected && !card.isMatched && !card.isBeingPlayed
    }
    
    public mutating func makeUnplayedCardsPlayable(isThreeNewCards: Bool = false) {
        var shuffledPlayableCards = cards.filter(isPlayable).shuffled()
        if (!shuffledPlayableCards.isEmpty) {
            for _ in 1...(isThreeNewCards ? 3 : (12 - (cards.filter { $0.isBeingPlayed }.count))) {
                if let lastShuffledCard = shuffledPlayableCards.popLast() {
                    if let index = cards.findFirst(lastShuffledCard) {
                        cards[index].isBeingPlayed = true
                    }
                }
            }
        }
    }
    
    public mutating func choose(_ card: Card) {
        let selectedDealtCards = cards.filter { $0.isSelected && $0.isBeingPlayed}
        if let selectedIndex = cards.findFirst(card) {
            if (selectedDealtCards.count < 3) {
                if (selectedDealtCards.count == 2 && !cards[selectedIndex].isSelected) {
                    var selectedCards = selectedDealtCards;
                    selectedCards.append(cards[selectedIndex])
                    if (isSet(selectedCards)) {
                        selectedDealtCards.forEach { card in
                            if let index = cards.findFirst(card){
                                cards[index].isMatched = true
                            }
                        }
                        cards[selectedIndex].isMatched = true
                    }
                }
                cards[selectedIndex].isSelected.toggle()
            } else {
                if (selectedDealtCards.allSatisfy {$0.isMatched} && selectedDealtCards.allSatisfy {$0.id != cards[selectedIndex].id}) {
                    selectedDealtCards.forEach { card in
                        if let index = cards.findFirst(card) {
                            cards[index].isSelected = false
                            cards[index].isBeingPlayed = false
                        }
                    }
                    cards[selectedIndex].isSelected = true
                } else if (selectedDealtCards.allSatisfy {$0.id != cards[selectedIndex].id}) {
                    selectedDealtCards.forEach { card in
                        if let index = cards.findFirst(card) {
                            cards[index].isSelected = false
                        }
                    }
                    cards[selectedIndex].isSelected.toggle()
                } else if (!cards[selectedIndex].isMatched) {
                    cards[selectedIndex].isSelected.toggle()
                }
            }
        }
    }
    
    struct Card: Identifiable,Equatable {
        var debugDescription: String {
            "\(id) \(shapecount) \(shape) \(opacity) \(color)"
        }
        var shape: String
        var shapecount: Int
        var opacity: Double
        var color: String
        var id: Int
        var isSelected = false
        var isBeingPlayed = false
        var isMatched = false
    }
}

extension Array where Element : Equatable {
    var only: Element? {
        count == 1 ? first : nil
    }
    
    func findFirst(_ item: Element) -> Int? {
        self.firstIndex {$0 == item}
    }
}
