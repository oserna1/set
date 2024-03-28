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
                        id += 1;
                        cards.append(Card(shape: shape, shapecount: shapeCount, opacity: opacity, color: color, id: id))
                    }
                }
            }
        }
        print(cards)
    }
    
    struct Card: Identifiable , CustomDebugStringConvertible {
        var debugDescription: String {
            "\(id) \(shapecount) \(shape) \(opacity) \(color)"
        }
        var shape: String
        var shapecount: Int
        var opacity: Double
        var color: String
        var id: Int
    }
}
