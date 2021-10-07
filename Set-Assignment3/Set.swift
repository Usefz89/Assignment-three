//
//  Set.swift
//  Set-Assignment3
//
//  Created by yousef zuriqi on 02/10/2021.
//

import Foundation

struct Set {
    var cards: [Card]
    var cardsOnScreen: [Card]
    var selectedCardsIndices: [Int] = []
    var threeOnlySelectedCardsIndices: [Int] {
        get {return  cardsOnScreen.indices.filter({cardsOnScreen[$0].isSelected})}
        set {
            cardsOnScreen.indices.forEach {
                cardsOnScreen[$0].isSelected = newValue.contains($0)
                cardsOnScreen[$0].matchingStatus = .notChecked
            
            }
        }
    }
   
    struct Card: Equatable, Identifiable {
        var isSelected = false
        var matchingStatus: MatchedStatus = .notChecked
        var cardContent: Theme
        var id: Int
        static func ==(lhs: Self, rhs: Self) -> Bool {
            return lhs.cardContent == rhs.cardContent
        }
        enum MatchedStatus {
            case notChecked
            case checkedNotMatched
            case checkedMatched
        }
    }
    
    init(createCardContent: () -> Theme) {
        var cardsCount = 0
        cards = []
        while cardsCount < 81 {
            let cardContent = createCardContent()
            let card = Card(cardContent: cardContent, id: cards.count + 1 )
            if !cards.contains(card) {
                cards.append(card)
                cardsCount += 1
            }
        }
        cardsOnScreen = Array(cards.prefix(through: 11))
        cards.removeSubrange(0..<12)
    }
    
    mutating func choose (_ card: Card) {
        guard let chosenIndex = cardsOnScreen.firstIndex(where: {$0.id == card.id}) else {return}
        
            switch threeOnlySelectedCardsIndices.count {
            case 0:
                cardsOnScreen[chosenIndex].isSelected = true
                threeOnlySelectedCardsIndices = [chosenIndex]
            case 1:
                guard cardsOnScreen[chosenIndex].isSelected == false else {
                    cardsOnScreen[chosenIndex].isSelected = false
                    return
                }
                cardsOnScreen[chosenIndex].isSelected = true
                threeOnlySelectedCardsIndices.append(chosenIndex)
            case 2:
                guard cardsOnScreen[chosenIndex].isSelected == false else {
                    cardsOnScreen[chosenIndex].isSelected = false
                    return
                }
                cardsOnScreen[chosenIndex].isSelected = true
                threeOnlySelectedCardsIndices.append(chosenIndex)
                if matchingCards(
                    card1: cardsOnScreen[threeOnlySelectedCardsIndices[0]],
                    card2: cardsOnScreen[threeOnlySelectedCardsIndices[1]],
                    card3: cardsOnScreen[threeOnlySelectedCardsIndices[2]]
                )
                {threeOnlySelectedCardsIndices.forEach { cardsOnScreen[$0].matchingStatus = .checkedMatched}}
                else {threeOnlySelectedCardsIndices.forEach{cardsOnScreen[$0].matchingStatus = .checkedNotMatched}}
            case 3:
                guard cardsOnScreen[chosenIndex].isSelected == false else {
                    guard !cardsAreMatched() else { return }
                    threeOnlySelectedCardsIndices = [chosenIndex]
                    return
                }
                if cardsAreMatched() {
                    if cards.count >= 3 {
                        threeOnlySelectedCardsIndices.forEach {cardsOnScreen[$0] = cards.removeLast()}
                        threeOnlySelectedCardsIndices = [chosenIndex]
                    } else {
                        let selectedCardId = cardsOnScreen[chosenIndex].id
                        let card1 = cardsOnScreen[ threeOnlySelectedCardsIndices[0]]
                        let card2 = cardsOnScreen[ threeOnlySelectedCardsIndices[1]]
                        let card3 = cardsOnScreen[ threeOnlySelectedCardsIndices[2]]
                        cardsOnScreen.removeAll { $0.id == card1.id || $0.id == card2.id || $0.id == card3.id}
                        threeOnlySelectedCardsIndices = [
                            cardsOnScreen.firstIndex(where: {$0.id == selectedCardId})!
                        ]
                    }
                } else {
                    cardsOnScreen[chosenIndex].isSelected = true
                    threeOnlySelectedCardsIndices = [chosenIndex]
                }
            default:
                print("There is problem with selecting cards count > 3")
            }
    }
    
    func matchingCards(card1: Card, card2: Card, card3: Card) -> Bool {
        
            ((card1.cardContent.shape == card2.cardContent.shape &&
                card1.cardContent.shape == card3.cardContent.shape) ||
                (card1.cardContent.shape != card2.cardContent.shape &&
                    card1.cardContent.shape != card3.cardContent.shape &&
                    card2.cardContent.shape != card3.cardContent.shape))
                &&
                
                ((card1.cardContent.colorOfShape == card2.cardContent.colorOfShape &&
                    card1.cardContent.colorOfShape == card3.cardContent.colorOfShape) ||
                    (card1.cardContent.colorOfShape != card2.cardContent.colorOfShape &&
                        card1.cardContent.colorOfShape != card3.cardContent.colorOfShape &&
                        card2.cardContent.colorOfShape != card3.cardContent.colorOfShape))
                &&
                
                ((card1.cardContent.numberOfShapes == card2.cardContent.numberOfShapes &&
                    card1.cardContent.numberOfShapes == card3.cardContent.numberOfShapes) ||
                    (card1.cardContent.numberOfShapes != card2.cardContent.numberOfShapes &&
                        card1.cardContent.numberOfShapes != card3.cardContent.numberOfShapes &&
                        card2.cardContent.numberOfShapes != card3.cardContent.numberOfShapes))
                &&
                
                ((card1.cardContent.opacityOfShape == card2.cardContent.opacityOfShape &&
                    card1.cardContent.opacityOfShape == card3.cardContent.opacityOfShape) ||
                    (card1.cardContent.opacityOfShape != card2.cardContent.opacityOfShape &&
                        card1.cardContent.opacityOfShape != card3.cardContent.opacityOfShape &&
                        card2.cardContent.opacityOfShape != card3.cardContent.opacityOfShape))
        ? true : false
    }
    
    func cardsAreMatched() -> Bool {
        return cardsOnScreen.indices.filter({cardsOnScreen[$0].matchingStatus == .checkedMatched}).count >= 3
    }
    
    mutating func dealCards() {
            cardsAreMatched() ? threeOnlySelectedCardsIndices.forEach({cardsOnScreen[$0] = cards.removeLast()})
                : cardsOnScreen.add(3, from: &cards)
    }
}


