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
        get {
            var selectedIndices: [Int] = []
            for index in cardsOnScreen.indices {
                if cardsOnScreen[index].isSelected {
                    selectedIndices.append(index)
                }
            }
            return selectedIndices
        }
        set {
            for index in cardsOnScreen.indices {
                if newValue.contains(index) {
                    cardsOnScreen[index].isSelected = true
                    cardsOnScreen[index].matchingStatus = .notChecked
                }else {
                    cardsOnScreen[index].isSelected = false
                    cardsOnScreen[index].matchingStatus = .notChecked
                }
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
                print("Selecting the first card")
                cardsOnScreen[chosenIndex].isSelected = true
                threeOnlySelectedCardsIndices = [chosenIndex]
            case 1:
                guard cardsOnScreen[chosenIndex].isSelected == false else {
                    cardsOnScreen[chosenIndex].isSelected = false
                    return
                }
                print("Selecting the second card")
                cardsOnScreen[chosenIndex].isSelected = true
                threeOnlySelectedCardsIndices.append(chosenIndex)
            case 2:
                guard cardsOnScreen[chosenIndex].isSelected == false else {
                    cardsOnScreen[chosenIndex].isSelected = false
                    return
                }
                print("Selecting Third Card")
                cardsOnScreen[chosenIndex].isSelected = true
                threeOnlySelectedCardsIndices.append(chosenIndex)
                if matchingCards(
                    card1: cardsOnScreen[threeOnlySelectedCardsIndices[0]],
                    card2: cardsOnScreen[threeOnlySelectedCardsIndices[1]],
                    card3: cardsOnScreen[threeOnlySelectedCardsIndices[2]]
                ) {
                    print("Cards are Matched!")
                    cardsOnScreen[threeOnlySelectedCardsIndices[0]].matchingStatus = .checkedMatched
                    cardsOnScreen[threeOnlySelectedCardsIndices[1]].matchingStatus = .checkedMatched
                    cardsOnScreen[threeOnlySelectedCardsIndices[2]].matchingStatus = .checkedMatched
                    
                } else {
                    print("Cards are not matched :(")
                    cardsOnScreen[threeOnlySelectedCardsIndices[0]].matchingStatus = .checkedNotMatched
                    cardsOnScreen[threeOnlySelectedCardsIndices[1]].matchingStatus = .checkedNotMatched
                    cardsOnScreen[threeOnlySelectedCardsIndices[2]].matchingStatus = .checkedNotMatched
                }
            case 3:
                guard cardsOnScreen[chosenIndex].isSelected == false else {
                    guard !cardsAreMatched() else { return }
                        print("Selecting the first card ... after non matching")
                        threeOnlySelectedCardsIndices = [chosenIndex]
                    return
                }
                print("Selecting the first card")
                if cardsAreMatched() {
                    if cards.count >= 3 {
                        for index in threeOnlySelectedCardsIndices {
                            cardsOnScreen[index] = cards.removeLast()
                        }
                        print("Selecting first Card ... after matching")
                        threeOnlySelectedCardsIndices = [chosenIndex]
                        
                    } else {
                        let selectedCardId = cardsOnScreen[chosenIndex].id
                        let card1 = threeOnlySelectedCardsIndices[0]
                        let card2 = threeOnlySelectedCardsIndices[1]
                        let card3 = threeOnlySelectedCardsIndices[2]
                        cardsOnScreen.removeAll { $0.id == card1 || $0.id == card2 || $0.id == card3}
                       
                        print("Selecting first Card ... after matching")
                        threeOnlySelectedCardsIndices = [
                            cardsOnScreen.firstIndex(where: {$0.id == selectedCardId})!
                        ]
                        
                        
                    }
                } else {
                    print("Selecting first card ... after Non matching")
                    cardsOnScreen[chosenIndex].isSelected = true
                    threeOnlySelectedCardsIndices = [chosenIndex]
                }
            default:
                print("There is problem with selecting cards count > 3")
            }
        
    }
    
//    mutating func choose(_ card: Card) {
//        guard  let chosenIndex = cardsOnScreen.firstIndex(where: {$0.id == card.id}) else {return}
//        if cardsOnScreen[chosenIndex].isSelected == false {
//            cardsOnScreen[chosenIndex].isSelected.toggle()
//            if threeOnlySelectedCardsIndices != nil  {
//                switch threeOnlySelectedCardsIndices?.count {
//                case 1:
//                    print("Selecting second card ...")
//                    threeOnlySelectedCardsIndices?.append(chosenIndex)
//
//                case 2:
//                    if matchingCards(
//                        card1: cardsOnScreen[threeOnlySelectedCardsIndices![0]],
//                        card2: cardsOnScreen[threeOnlySelectedCardsIndices![1]],
//                        card3: cardsOnScreen[chosenIndex]
//                    ) {
//                        print("Selecting third card")
//                        print("Cards are MATCHED!")
//                        cardsOnScreen[threeOnlySelectedCardsIndices![0]].matchingStatus = .checkedMatched
//                        cardsOnScreen[threeOnlySelectedCardsIndices![1]].matchingStatus = .checkedMatched
//                        cardsOnScreen[chosenIndex].matchingStatus = .checkedMatched
//                        threeOnlySelectedCardsIndices?.append(chosenIndex)
//
//                    } else {
//                        print("Selecting third card")
//                        print("Cards are non matching :(")
//                        cardsOnScreen[threeOnlySelectedCardsIndices![0]].matchingStatus = .checkedNotMatched
//                        cardsOnScreen[threeOnlySelectedCardsIndices![1]].matchingStatus = .checkedNotMatched
//                        cardsOnScreen[chosenIndex].matchingStatus = .checkedNotMatched
//                        threeOnlySelectedCardsIndices?.append(chosenIndex)
//                    }
//                case 3:
//                    if (
//                        cardsOnScreen[threeOnlySelectedCardsIndices![0]].matchingStatus == .checkedMatched &&
//                            cardsOnScreen[threeOnlySelectedCardsIndices![1]].matchingStatus == .checkedMatched &&
//                            cardsOnScreen[threeOnlySelectedCardsIndices![2]].matchingStatus == .checkedMatched
//                    ) {
//                        if  cards.count >= 3 {
//                            cardsOnScreen[threeOnlySelectedCardsIndices![0]] = cards.removeLast()
//                            cardsOnScreen[threeOnlySelectedCardsIndices![1]] = cards.removeLast()
//                            cardsOnScreen[threeOnlySelectedCardsIndices![2]] = cards.removeLast()
//                            print("Selecting first Card ... after matching")
//                            threeOnlySelectedCardsIndices = [chosenIndex]
//                        } else {
//                            let card1 = cardsOnScreen[threeOnlySelectedCardsIndices![0]]
//                            let card2 = cardsOnScreen[threeOnlySelectedCardsIndices![1]]
//                            let card3 = cardsOnScreen[threeOnlySelectedCardsIndices![2]]
//                            cardsOnScreen.removeAll(where: {$0.id == card1.id || $0.id == card2.id || $0.id == card3.id})
//                            print("Selecting first Card ... after matching")
//                            var selectedCardIndex: Int = 0
//                            for index in cardsOnScreen.indices {
//                                if cardsOnScreen[index].isSelected == true {
//                                    selectedCardIndex = index
//                                }
//                            }
//                            threeOnlySelectedCardsIndices = [selectedCardIndex]
//                        }
//                    } else {
//                        cardsOnScreen[threeOnlySelectedCardsIndices![0]].isSelected = false
//                        cardsOnScreen[threeOnlySelectedCardsIndices![1]].isSelected = false
//                        cardsOnScreen[threeOnlySelectedCardsIndices![2]].isSelected = false
//                        cardsOnScreen[threeOnlySelectedCardsIndices![0]].matchingStatus = .notChecked
//                        cardsOnScreen[threeOnlySelectedCardsIndices![1]].matchingStatus = .notChecked
//                        cardsOnScreen[threeOnlySelectedCardsIndices![2]].matchingStatus = .notChecked
//                        print("Selecting first Card ... after not matching")
//                        threeOnlySelectedCardsIndices = [chosenIndex]
//                    }
//                default:
//                    print("Error threeAndOnlyIndices count are > 3")
//                }
//            } else {
//                print("Selecting first Card ...")
//                threeOnlySelectedCardsIndices = [chosenIndex]
//            }
//        } else {
//            switch threeOnlySelectedCardsIndices?.count {
//            case 1:
//                threeOnlySelectedCardsIndices = nil
//                cardsOnScreen[chosenIndex].isSelected = false
//            case 2:
//                threeOnlySelectedCardsIndices?.removeLast()
//                cardsOnScreen[chosenIndex].isSelected = false
//            case 3:
//                if cardsAreMatched() {
//                    threeOnlySelectedCardsIndices?.forEach {
//                        cardsOnScreen[$0].isSelected = $0 == chosenIndex
//                        cardsOnScreen[$0].matchingStatus = .notChecked
//                    }
//                    threeOnlySelectedCardsIndices = [chosenIndex]
//                } else {
//                    return
//                }
//            default:
//                print("Problem selected Cards =  \(threeOnlySelectedCardsIndices?.count ?? 0)")
//                threeOnlySelectedCardsIndices = nil
//                cardsOnScreen[chosenIndex].isSelected = false
//            }
//        }
//    }
    
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
            return true
        } else {
            return false
        }
    }
    
    mutating func dealCards() {
        if cardsAreMatched() {
            
            for index in threeOnlySelectedCardsIndices {
                cardsOnScreen[index] = cards.removeLast()
            }
        } else {
            cardsOnScreen.add(3, from: &cards)
        }
      
    }
}


