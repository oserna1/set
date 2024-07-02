//
//  ContentView.swift
//  set
//
//  Created by Oscar Serna on 3/18/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = SetMv()
    
    var body: some View {
        VStack {
            AspectVGrid<SetGame.Card, CardView>(viewModel.dealtCards, aspectRatio: 2/3) { card in CardView(card: card, vm: viewModel) }
            HStack {
                Button("new game") {
                    viewModel.newGame()
                }
                if (viewModel.cards.filter{ !$0.isBeingPlayed && $0.select != Select.matched }.count > 0) {
                    Button("Add 3 Cards") {
                        viewModel.threeNewCards()
                    }
                }
            }
        }
    }
}

public func getColor(fromString color: String) -> Color {
    if (color == "red") {
        return Color.red
    } else if (color == "green") {
        return Color.green
    } else {
        return Color.purple
    }
}

public func getShape(fromString shape: String) -> some Shape {
    if (shape == "diamond") {
        return AnyShape(Diamond())
    } else if (shape == "capsule") {
        return AnyShape(Capsule())
    } else {
        return AnyShape(Rectangle())
    }
}

public func getBorderColor(selectType: Select) -> Color {
    switch selectType {
    case .selected(true):
        .yellow
    case .matched:
        .green
    case .invalid:
        .red
    default:
        .black
    }
}

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
            }.padding(1)
        }
        .onTapGesture {
            vm.choose(card)
        }
    }
}

struct Diamond:Shape {

    func path(in rect: CGRect) -> Path {

        var path = Path()
        // get the center of the rect
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // get the starting of our drawing the right side of our diamond
        let startingPoint = CGPoint(x: rect.maxX, y: center.y)
        // move our start of drawing to the beggining point
        path.move(to: startingPoint)
        // distance / 2 is our height
        // create all our points
        let secondPoint = CGPoint(x: center.x, y: rect.maxY)
        let thirdPoint = CGPoint(x: rect.minX , y: center.y)
        let fourthPoint = CGPoint(x: center.x, y: rect.minY)
        path.addLine(to: secondPoint)
        path.addLine(to: thirdPoint)
        path.addLine(to: fourthPoint)
        path.addLine(to: startingPoint)
        return path
    }
}

#Preview {
    ContentView()
}
