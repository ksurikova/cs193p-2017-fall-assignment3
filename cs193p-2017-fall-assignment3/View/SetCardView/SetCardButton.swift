//
//  SetCardButton.swift
//  cs193p-2017-fall-assignment3
//
//  Created by Ksenia Surikova on 25.05.2022.
//

import UIKit

@IBDesignable class SetCardButton: UIButton, SetCardViewProtocol {
    
    @IBInspectable var borderColor : UIColor = DefaultUIConstants.borderColor {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = DefaultUIConstants.borderWidth {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = DefaultUIConstants.cornerRadius {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    let symbols = ["\u{25A0}", "\u{25B2}", "\u{25CF}"]
    let colors = [#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),  #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1),  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)]
    let alphasAndStrokes: [(alpha: CGFloat, stroke: Int)] = [(1.0, 0),(1.0, 5),(0.15, 0)]
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
    
    required init(with card: SetCard){
        self.card = card
        super.init(frame: CGRect.zero)
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var card : SetCard {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        layer.backgroundColor = DefaultUIConstants.backgroundColor
        let myAttrString = getStringContentForSetSymbols(card: card)
        // set attributed text on a UILabel
        titleLabel?.textAlignment = .center
        titleLabel?.lineBreakMode = .byWordWrapping
        setAttributedTitle(myAttrString, for: UIControl.State.normal)
    }

    func setBorderColor(at: UIColor){
        borderColor = at
        borderWidth = DefaultUIConstants.borderWidth
    }
    
    func clearBorder() {
       borderWidth=0.0
    }
    
    private func getStringContentForSetSymbols(card: SetCard) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: colors[card.secondSign.i].withAlphaComponent(alphasAndStrokes[card.thirdSign.i].alpha),
            .font: UIFont.systemFont(ofSize: 20),
            .strokeColor :colors[card.secondSign.i],
            .strokeWidth: alphasAndStrokes[card.thirdSign.i].stroke
        ]
        let separator = UIScreen.main.traitCollection.verticalSizeClass == .compact ? "" : "\n"
        let symbolsString = symbols[card.firstSign.i].repeate(n: card.fourthSign.rawValue, with: separator)
        return NSAttributedString(string: symbolsString, attributes: attributes)
    }
}

private struct DefaultUIConstants {
    static let cornerRadius : CGFloat = 8.0
    static let borderWidth : CGFloat = 2.0
    static let borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    static let backgroundColor : CGColor = #colorLiteral(red: 1, green: 0.9840470705, blue: 0.8411780624, alpha: 1)
}

extension String {
    func repeate(n: Int, with separator: String) -> String {
        guard n > 1 else {return self}
        var array = [String]()
        for _ in 0..<n {
            array.append(self)
        }
        return array.joined(separator: separator)
    }
}

