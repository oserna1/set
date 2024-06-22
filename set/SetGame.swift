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
        var shuffledCardIds = Array(0...cards.count-1).shuffled()
        for _ in 1...12 {
            if let index = shuffledCardIds.popLast() {
                cards[index].isBeingPlayed = true
            }
        }
    }
    
    mutating func choose(_ card: Card) {
        let selectedDealtCards = cards.filter { $0.isSelected && $0.isBeingPlayed}
        if let selectedIndex = cards.findFirst(card) {
            if (selectedDealtCards.count < 3) {
                if (selectedDealtCards.count == 2 && !cards[selectedIndex].isSelected) {
                    //TODO matched logic
                    selectedDealtCards.forEach { card in
                        cards[card.id].isMatched = true
                    }
                    cards[selectedIndex].isMatched = true
                }
                cards[selectedIndex].isSelected.toggle()
            } else if (!cards[selectedIndex].isSelected) {
                // TODO matched logic
                cards[selectedIndex].isSelected.toggle()
                selectedDealtCards.forEach { card in
                    cards[card.id].isSelected = false
                    cards[card.id].isBeingPlayed = false
                }
            } else if (!cards[selectedIndex].isMatched) {
                cards[selectedIndex].isSelected.toggle()
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
