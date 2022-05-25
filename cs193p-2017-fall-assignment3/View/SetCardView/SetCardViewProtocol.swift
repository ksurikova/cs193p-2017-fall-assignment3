//
//  SetCardViewProtocol.swift
//  cs193p-2017-fall-assignment3
//
//  Created by Ksenia Surikova on 25.05.2022.
//

import Foundation
import UIKit

protocol SetCardViewProtocol: UIView {
    
    var card : SetCard { get set}

    func setBorderColor(at: UIColor)
    
    func clearBorder()
}
