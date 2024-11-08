//
//  SetGame.swift
//  cs193p-2017-fall-assignment3
//
//  Created by Ksenia Surikova on 25.05.2022.
//

import Foundation

struct SetGame {

    static let startFacedUpCardsCount = 12
    static let cardsToDealAndCheckCount = 3
    static let setQuessPoint = 5
    static let setNoQuessPenaltyPoint = 3
    static let removeChoisePenaltyPoint = 1

    private(set) var deck = [SetCard]()
    private(set) var cardsChosen = [SetCard]()
    private(set) var cardsOnView = [SetCard]()
    private(set) var score = 0

    var isSet: Bool? {
        if cardsChosen.count == Self.cardsToDealAndCheckCount {
            return SetCard.isSet(cardsToCheck: cardsChosen)
        } else {
            return nil
        }
    }

    private func getDeck() -> [SetCard] {
        var deck = [SetCard]()
        for i in Sign.allCases {
            for j in Sign.allCases {
                for k in Sign.allCases {
                    for l in Sign.allCases {
                        let card = SetCard(i, j, k, l)
                        deck.append(card)
                    }
                }
            }
        }
        return deck.shuffled()
    }

    init () {
        deck = getDeck()
        for _ in 0..<Self.startFacedUpCardsCount {
            cardsOnView.append(deck.removeFirst())
        }
    }

    mutating func getCardsFromDeck() -> [SetCard]? {
        guard canDealMoreCards() else {
            return nil
        }
        var cardsToDeal = [SetCard]()
        for _ in 0..<Self.cardsToDealAndCheckCount {
            cardsToDeal.append(deck.removeFirst())
        }
        return cardsToDeal
    }

    func canDealMoreCards(countToDeal: Int = Self.cardsToDealAndCheckCount) -> Bool {
        deck.count >= countToDeal
    }

    mutating func dealCards() {
        if let isMatched = isSet {
            dealCards(replaceMatchingCards: isMatched)
        } else {
            dealCards(replaceMatchingCards: false)
        }
    }

    mutating func dealCards(replaceMatchingCards: Bool) {
        if replaceMatchingCards {
            for element in cardsChosen {
                _ = cardsOnView.removeIfContains(element)
            }
            cardsChosen.removeAll()
        }
        if let existsCardsFromDeck =  getCardsFromDeck() {
            cardsOnView.append(contentsOf: existsCardsFromDeck)
        }
    }

    mutating func chooseCard(card: SetCard) {
        guard cardsOnView.contains(card) else {return }
        switch cardsChosen.count {
        case 0..<Self.cardsToDealAndCheckCount-1:
            let wasAppend = cardsChosen.appendOrRemoveIfContains(card)
            if !wasAppend { score -= Self.removeChoisePenaltyPoint }
        case Self.cardsToDealAndCheckCount-1:
            let wasAppend = cardsChosen.appendOrRemoveIfContains(card)
            if !wasAppend { score -= Self.removeChoisePenaltyPoint
            } else {
                if let changeScore = isSet {
                    score = changeScore ? score+Self.setQuessPoint: score-Self.setNoQuessPenaltyPoint
                }
            }
        case Self.cardsToDealAndCheckCount:
            if !cardsChosen.contains(card) {
                if let isMatched = isSet {
                    if isMatched {
                        dealCards(replaceMatchingCards: isMatched)
                    }
                }
                cardsChosen.removeAll()
                cardsChosen.append(card)
            }
        // else do nothing
        default:
            break
        }
    }

    mutating func shuffle() {
        cardsOnView.shuffle()
    }
}

extension Array where Element: Equatable {
    mutating func removeIfContains(_ element: Element) -> Bool {
        if let index = self.firstIndex(of: element) {
            self.remove(at: index)
            return true
        } else {
            return false
        }
    }

    mutating func appendOrRemoveIfContains(_ element: Element) -> Bool {
        if removeIfContains(element) {
            return false
        } else {
            self.append(element)
            return true
        }
    }
}
