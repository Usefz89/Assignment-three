//
//  SetGameView.swift
//  Set-Assignment3
//
//  Created by yousef zuriqi on 02/10/2021.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var game: SetGame
    
    var body: some View {
        ZStack {
            Image("green")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                AspectVGrid(items: game.cardsOnScreen, aspectRatio: 2/3) { card  in
                    CardView(card: card)
                        .padding(5)
                        .foregroundColor( game.colorOfShape(card: card))
                        .onTapGesture {
                            game.choose(card: card)
                    }
                }
                .padding()
                   
                HStack {
                    Button(action: {game.dealCards()}) {
                        Text("DEAL CARDS")
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            
                    }
                    .disabled(game.cards.isEmpty)
                    Button(action: {game.newGame()}) {
                        Text("NEW GAME")
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    
                }
                
            }
        }
        
    }
}

struct CardView: View {
    
    let card: Set.Card
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                    .stroke(lineWidth: card.isSelected ? 10 : 1 )
                    .foregroundColor(getBorderColor(of: card))
                RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                    .fill()
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                getCardContent(in: geometry.size, from: card)
            }
        }
    }

    func getBorderColor(of card: Set.Card) -> Color {
        switch card.matchingStatus {
        case .notChecked: return Color.yellow
        case .checkedNotMatched: return Color.red
        case .checkedMatched: return Color.green
            
        }
    }
 
    @ViewBuilder
    func getCardContent(in size: CGSize, from card: Set.Card) -> some View {
        VStack {
            ForEach(0..<card.cardContent.numberOfShapes.rawValue, id: \.self) { _ in
                switch card.cardContent.shape {
                case .oval :
                    ZStack {
                        RoundedRectangle(cornerRadius: min(size.width, size.height) / 2)
                            .stroke(lineWidth: DrawingConstants.lineWidth)
                            .frameThatFits(in: size)
                        RoundedRectangle(cornerRadius: min(size.width, size.height) / 2)
                            .frameThatFits(in: size)
                            .opacity(card.cardContent.opacityOfShape.rawValue)
                    }
                    
                case .rectangle:
                    ZStack {
                        Rectangle()
                            .stroke(lineWidth: DrawingConstants.lineWidth)
                            .frameThatFits(in: size)
                            

                        Rectangle()
                            .frameThatFits(in: size)
                            .opacity(card.cardContent.opacityOfShape.rawValue)
                    }
                    
                case .diamond:
                    ZStack {
                        Diamond()
                            .stroke(lineWidth: DrawingConstants.lineWidth)
                            .frameThatFits(in: size)
                         

                        Diamond()
                            .frameThatFits(in: size)
                            .opacity(card.cardContent.opacityOfShape.rawValue)
                    }
                }
            }
        }
    }
   
    struct DrawingConstants {
        static var cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 1.5
        static let selectedLineWidth: CGFloat = 10

    }
}







struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        SetGameView(game: game)
    }
}


