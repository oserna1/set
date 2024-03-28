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
        AspectVGrid(viewModel.cards, aspectRatio: 2/3) { card in CardView(card: card) }.padding()
    }
    
    struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
        let items: [Item]
        var aspectRatio: CGFloat = 1
        let content: (Item) -> ItemView
        
        init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
            self.items = items
            self.aspectRatio = aspectRatio
            self.content = content
        }
        
        var body: some View {
            GeometryReader { geometry in
                let gridItemSize = gridItemWidthThatFits(
                    count: items.count,
                    size: geometry.size,
                    atAspectRatio: aspectRatio
                )
                LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                    ForEach(items) { item in
                        content(item)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
            }
            .padding(.horizontal)
        }
        
        private func gridItemWidthThatFits(
            count: Int,
            size: CGSize,
            atAspectRatio aspectRatio: CGFloat
        ) -> CGFloat {
            let count = CGFloat(count)
            var columnCount = 1.0
            repeat {
                let width = size.width / columnCount
                let height = width / aspectRatio
                
                let rowCount = (count / columnCount).rounded(.up)
                if rowCount * height < size.height {
                    return (size.width / columnCount).rounded(.down)
                }
                columnCount += 1
            } while columnCount < count
            return min(size.width / count, size.height * aspectRatio).rounded(.down)
        }
    }
}

func getColor(fromString color: String) -> Color {
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
        return AnyShape(Circle())
    } else if (shape == "capsule") {
        return AnyShape(Capsule())
    } else {
        return AnyShape(Rectangle())
    }
}

struct CardView: View {
    let card: SetGame.Card
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            let shape = card.shape
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                VStack {
                    ForEach(1...card.shapecount, id: \.self) { id in
                        getShape(fromString:shape).fill(getColor(fromString: card.color)).frame(width: 20, height: 10).opacity(card.opacity)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
