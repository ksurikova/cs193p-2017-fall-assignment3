//
//  SetGameViewController.swift
//  cs193p-2017-fall-assignment3
//
//  Created by Ksenia Surikova on 25.02.2022.
//

import UIKit

class SetGameViewController: UIViewController {

    private var game: SetGame!

    @IBOutlet weak var testModeCheckbox: UIButton!
    @IBOutlet weak var dealCardsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var setCardsView: SetCardAreaView! {
        didSet {
            getReadyToStart()
            let swipe = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(handleSwipe))
            swipe.direction = .down
            setCardsView.addGestureRecognizer(swipe)
            let rotate = UIRotationGestureRecognizer(target: self,
                                                     action: #selector(reshuffle))
            setCardsView.addGestureRecognizer(rotate)
        }
    }

    @IBAction func touchTestMode(_ sender: UIButton) {
        game.toggleTestMode()
        sender.isSelected.toggle()
        updateCheckbox(isChecked: sender.isSelected)
        updateCardsState()
    }

    @IBAction func dealMoreCards() {
       game.dealCards()
        updateViewFromModel()
    }

    @IBAction func playAgain(_ sender: UIButton) {
        getReadyToStart()
        updateScore()
        updateDealCardsButtonState()
        updateCheckbox(isChecked: false)
    }

    private func getReadyToStart() {
        game = SetGame()
        resetCardViews()
    }

    private func updateCheckbox(isChecked: Bool) {
        let symbolName = isChecked ? "checkmark.square" : "square"
        testModeCheckbox.setImage(UIImage(systemName: symbolName), for: .normal)
    }

    private func resetCardViews() {
        var initialCards = [SetCardViewProtocol]()
        for i in 0..<game.cardsOnView.count {
            let button = SetCardView(with: game.cardsOnView[i])
            addTapGestureRecognizer(for: button)
            initialCards.append(button)
        }
        setCardsView.cardViews = initialCards
    }

    @objc private func handleSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            dealMoreCards()
        }
    }

    @objc private func reshuffle(_ gestureRecognizer: UIRotationGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            game.shuffle()
            resetCardViews()
            updateCardsState()
        }
    }

    private func addTapGestureRecognizer(for cardView: SetCardViewProtocol) {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(tapCard(recognizedBy: )))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        cardView.addGestureRecognizer(tap)
    }

    @objc private func tapCard(recognizedBy recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if  let cardView = recognizer.view! as? SetCardViewProtocol {
                game.chooseCard(card: cardView.card)
                updateViewFromModel()
            }
        }
    }

    private func updateViewFromModel() {
        updateCardViewsFromModel()
        updateScore()
        updateDealCardsButtonState()
    }

    private func updateDealCardsButtonState() {
        dealCardsButton.isHidden = !game.canDealMoreCards()
    }

    private func updateScore() {
        scoreLabel.text = "Score: \(game.score)"
    }

    private func updateCardViewsFromModel() {
        if setCardsView.cardViews.count == game.cardsOnView.count {
            let changedCards = setCardsView.cardViews.filter { !game.cardsOnView.contains($0.card) }
            for index in 0..<changedCards.count {
                // we append new dealed cards at the end of cardsOnView array, so we can find it there
                changedCards[index].card = game.cardsOnView[game.cardsOnView.count - index - 1]
            }
        } else {
            resetCardViews()
        }
        updateCardsState()
    }

    private func updateCardsState() {
        // set borders depends on matching or simply selected
        if let isMatched = game.isSet {
            for index in 0..<setCardsView.cardViews.count {
                let card = setCardsView.cardViews[index].card
                if game.cardsChosen.contains(card) {
                    setCardsView.cardViews[index].setBorderColor(
                        at: isMatched ? SetGameUIConstants.matchedCardColor : SetGameUIConstants.mismatchedCardColor)
                }
            }
        } else {
            // else borders for chosen cards
            for index in 0..<setCardsView.cardViews.count {
                let card = setCardsView.cardViews[index].card
                if game.cardsChosen.contains(card) {
                    setCardsView.cardViews[index].setBorderColor(at: SetGameUIConstants.chosenCardColor)
                } else { setCardsView.cardViews[index].clearBorder()}
            }
        }
    }
}

private struct SetGameUIConstants {
    static let chosenCardColor: UIColor = #colorLiteral(red: 0.05665164441, green: 0.2764216363, blue: 1, alpha: 1)
    static let matchedCardColor: UIColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
    static let mismatchedCardColor: UIColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
}
