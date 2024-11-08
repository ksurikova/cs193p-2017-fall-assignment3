//
//  SetCardAreaView.swift
//   cs193p-2017-fall-assignment3
//
//  Created by Ksenia Surikova on 15.03.2022.
//

import UIKit

class SetCardAreaView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        var grid = Grid(layout: Grid.Layout.aspectRatio(SetCardViewConstants.cardAspectRatio), frame: bounds)
        grid.cellCount = cardViews.count
        for row in 0..<grid.dimensions.rowCount {
            for column in 0..<grid.dimensions.columnCount {
                let index = row * grid.dimensions.columnCount + column
                guard index < cardViews.count else { continue }

                cardViews[index].frame = grid[row, column]!.insetBy(
                    dx: SetCardViewConstants.spacingDx,
                    dy: SetCardViewConstants.spacingDy
                )
            }
        }
    }

    var cardViews = [SetCardViewProtocol]() {
        willSet { removeSubviews() }
        didSet { addSubviews(); setNeedsLayout() }
    }

    private func removeSubviews() {
        for card in cardViews {
            card.removeFromSuperview()
        }
    }

    private func addSubviews() {
        for card in cardViews {
            addSubview(card)
        }
    }
}
