//
//  ContentView.swift
//  set
//
//  Created by Oscar Serna on 3/18/24.
//

import SwiftUI

struct SetGameView: View {
    typealias Card = SetGame.Card
    @ObservedObject var viewModel = SetMv()
    
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    private let dealInterval: TimeInterval = 0.15
    private let deckWidth: CGFloat = 50
        
    var body: some View {
        VStack {
            cards
            HStack {
                Button("new game") {
                    viewModel.newGame()
                }
                deck.foregroundColor(.red)
            }
        }
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                view(for: card)
                    .onTapGesture {
                        choose(card)
                    }
            }
        }
    }
    
    private func view(for card: Card) -> some View {
        CardView(card: card, vm: viewModel)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .transition(.asymmetric(insertion: .identity, removal: .identity))
    }
    
    private func choose(_ card: Card) {
        withAnimation {
//            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
//            let scoreChange = viewModel.score - scoreBeforeChoosing
//            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    // MARK: - Dealing from a Deck

    @State private var dealt = Set<Card.ID>()

    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }

    @Namespace private var dealingNamespace

    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                view(for: card)
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            deal()
        }
    }

    private func deal() {
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
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

#Preview {
    SetGameView()
}
