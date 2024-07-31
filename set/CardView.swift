//
//  CardView.swift
//  set
//
//  Created by Oscar Serna on 7/21/24.
//

import SwiftUI

struct CardView: View {
    let card: SetGame.Card
    let vm: SetMv
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            let shape = card.shape
            let color = getColor(fromString: card.color)
            Group {
                base.fill(.white)
                base.strokeBorder(getBorderColor(selectType: card.select), lineWidth: card.select == Select.selected(false) ? 2 : 4)
                GeometryReader { geometry in
                    VStack {
                        ForEach(1...card.shapecount, id: \.self) { id in
                            if (card.opacity == 0) {
                                getShape(fromString:shape).stroke(color, lineWidth: 1).frame(width: geometry.size.width, height: geometry.size.width * 0.5)
                            } else {
                                getShape(fromString:shape).fill(color.opacity(card.opacity)).frame(width: geometry.size.width, height: geometry.size.width * 0.5)
                            }
                        }
                    }
                }.padding()
            }.padding(0.5)
        }
    }
}
