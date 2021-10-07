//
//  SetGame.swift
//  Set-Assignment3
//
//  Created by yousef zuriqi on 02/10/2021.
//

import SwiftUI

class SetGame: ObservableObject  {
    typealias Card = Set.Card
    
    private static var  themes: [Theme] = makeThemes()
    
    
    static func makeThemes() -> [Theme] {
        var themesCount = 0
        var themes: [Theme] = []
        while themesCount < 81 {
            let theme = Theme(
                shape: Theme.Shape.allCases.randomElement()!,
                numberOfShapes: Theme.NumberOfShapes.allCases.randomElement()!,
                colorOfShape: Theme.ColorOfShape.allCases.randomElement()!,
                opacityOfShape: Theme.OpacityOptions.allCases.randomElement()!
            )
            if !themes.contains(theme) {
                themes.append(theme)
                themesCount += 1
            }
        }
        return themes
    }
    
    static func makeModel() -> Set {
        return Set { themes.randomElement()! }
    }
    
    @Published private var model: Set = makeModel()
    
    var cards: [Set.Card] {
        model.cards
    }
    var cardsOnScreen: [Set.Card] {
        model.cardsOnScreen
    }
    
    func colorOfShape(card: Set.Card) -> Color {
        let colorString: Theme.ColorOfShape = card.cardContent.colorOfShape
        switch colorString {
        
        case .red:
            return Color.red
        case .purple:
            return Color.purple
        case .green:
            return Color.green
        }
    }
   
    
    //MARK: - INTENT:
    func choose( card: Set.Card) {
        model.choose(card)
    }
    
    func dealCards() {
        model.dealCards()
    }
    
    func newGame() {
        model =  Self.makeModel()
    }
}


  


    

