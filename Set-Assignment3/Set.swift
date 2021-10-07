//
//  Set.swift
//  Set-Assignment3
//
//  Created by yousef zuriqi on 02/10/2021.
//

import Foundation
// Test the factor
struct Set {
    var cards: [Card]
    var cardsOnScreen: [Card]
    var selectedCardsIndices: [Int] = []
    var threeOnlySelectedCardsIndices: [Int]?
     
    
    
    
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
    
    mutating func choose(_ card: Card) {
        guard  let chosenIndex = cardsOnScreen.firstIndex(where: {$0.id == card.id}) else {return}
        if cardsOnScreen[chosenIndex].isSelected == false {
            cardsOnScreen[chosenIndex].isSelected.toggle()
            if threeOnlySelectedCardsIndices != nil  {
                switch threeOnlySelectedCardsIndices?.count {
                case 1:
                    print("Selecting second card ...")
                    threeOnlySelectedCardsIndices?.append(chosenIndex)
                    
                case 2:
                    if matchingCards(
                        card1: cardsOnScreen[threeOnlySelectedCardsIndices![0]],
                        card2: cardsOnScreen[threeOnlySelectedCardsIndices![1]],
                        card3: cardsOnScreen[chosenIndex]
                    ) {
                        print("Selecting third card")
                        print("Cards are MATCHED!")
                        cardsOnScreen[threeOnlySelectedCardsIndices![0]].matchingStatus = .checkedMatched
                        cardsOnScreen[threeOnlySelectedCardsIndices![1]].matchingStatus = .checkedMatched
                        cardsOnScreen[chosenIndex].matchingStatus = .checkedMatched
                        threeOnlySelectedCardsIndices?.append(chosenIndex)
                        
                    } else {
                        print("Selecting third card")
                        print("Cards are non matching :(")
                        cardsOnScreen[threeOnlySelectedCardsIndices![0]].matchingStatus = .checkedNotMatched
                        cardsOnScreen[threeOnlySelectedCardsIndices![1]].matchingStatus = .checkedNotMatched
                        cardsOnScreen[chosenIndex].matchingStatus = .checkedNotMatched
                        threeOnlySelectedCardsIndices?.append(chosenIndex)
                    }
                case 3:
                    if (
                        cardsOnScreen[threeOnlySelectedCardsIndices![0]].matchingStatus == .checkedMatched &&
                            cardsOnScreen[threeOnlySelectedCardsIndices![1]].matchingStatus == .checkedMatched &&
                            cardsOnScreen[threeOnlySelectedCardsIndices![2]].matchingStatus == .checkedMatched
                    ) {
                        if  cards.count >= 3 {
                            cardsOnScreen[threeOnlySelectedCardsIndices![0]] = cards.removeLast()
                            cardsOnScreen[threeOnlySelectedCardsIndices![1]] = cards.removeLast()
                            cardsOnScreen[threeOnlySelectedCardsIndices![2]] = cards.removeLast()
                            print("Selecting first Card ... after matching")
                            threeOnlySelectedCardsIndices = [chosenIndex]
                        } else {
                            let card1 = cardsOnScreen[threeOnlySelectedCardsIndices![0]]
                            let card2 = cardsOnScreen[threeOnlySelectedCardsIndices![1]]
                            let card3 = cardsOnScreen[threeOnlySelectedCardsIndices![2]]
                            cardsOnScreen.removeAll(where: {$0.id == card1.id || $0.id == card2.id || $0.id == card3.id})
                            print("Selecting first Card ... after matching")
                            var selectedCardIndex: Int = 0
                            for index in cardsOnScreen.indices {
                                if cardsOnScreen[index].isSelected == true {
                                    selectedCardIndex = index
                                }
                            }
                            threeOnlySelectedCardsIndices = [selectedCardIndex]
                        }
                    } else {
                        cardsOnScreen[threeOnlySelectedCardsIndices![0]].isSelected = false
                        cardsOnScreen[threeOnlySelectedCardsIndices![1]].isSelected = false
                        cardsOnScreen[threeOnlySelectedCardsIndices![2]].isSelected = false
                        cardsOnScreen[threeOnlySelectedCardsIndices![0]].matchingStatus = .notChecked
                        cardsOnScreen[threeOnlySelectedCardsIndices![1]].matchingStatus = .notChecked
                        cardsOnScreen[threeOnlySelectedCardsIndices![2]].matchingStatus = .notChecked
                        print("Selecting first Card ... after not matching")
                        threeOnlySelectedCardsIndices = [chosenIndex]
                    }
                default:
                    print("Error threeAndOnlyIndices count are > 3")
                }
            } else {
                print("Selecting first Card ...")
                threeOnlySelectedCardsIndices = [chosenIndex]
            }
        } else {
            switch threeOnlySelectedCardsIndices?.count {
            case 1:
                threeOnlySelectedCardsIndices = nil
                cardsOnScreen[chosenIndex].isSelected = false
            case 2:
                threeOnlySelectedCardsIndices?.removeLast()
                cardsOnScreen[chosenIndex].isSelected = false
            case 3:
                if cardsAreMatched() {
                    threeOnlySelectedCardsIndices?.forEach {
                        cardsOnScreen[$0].isSelected = $0 == chosenIndex
                        cardsOnScreen[$0].matchingStatus = .notChecked
                    }
                    threeOnlySelectedCardsIndices = [chosenIndex]
                } else {
                    return
                }
            default:
                print("Problem selected Cards =  \(threeOnlySelectedCardsIndices?.count ?? 0)")
                threeOnlySelectedCardsIndices = nil
                cardsOnScreen[chosenIndex].isSelected = false
            }
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
        var cardsMatched: [Int] = []
        for index in cardsOnScreen.indices {
            if cardsOnScreen[index].matchingStatus == .checkedMatched {
                cardsMatched.append(index)
                }
            }
        if cardsMatched.count >= 3 {
            return false
        } else {
            return true
        }
    }
    
    mutating func dealCards() {
        if threeOnlySelectedCardsIndices != nil && !cardsAreMatched() {
            cardsOnScreen[threeOnlySelectedCardsIndices![0]] = cards.removeLast()
            cardsOnScreen[threeOnlySelectedCardsIndices![1]] = cards.removeLast()
            cardsOnScreen[threeOnlySelectedCardsIndices![2]] = cards.removeLast()
            threeOnlySelectedCardsIndices = nil 
        } else {
            cardsOnScreen.add(3, from: &cards)
        }
      
    }
}


