
//
//  TLDayCollectionViewCell.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 24.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

class TimetableWeekdayCollectionViewCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    
    override var isHighlighted: Bool {
        didSet { highlight(isHighlighted) }
    }
    
    private func highlight(_ highlight: Bool) {
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.15, animations: { self.alpha = highlight ? 0.25 : 1 })
        }
        
    }
    
    var isActive: Bool! {
        didSet { active(isActive) }
    }
    
    private func active(_ active: Bool) {
        
        guard let titleLabel = self.titleLabel else { return }
        guard let dateLabel = self.dateLabel else { return }
        
        let activeColor = UIColor(red: 0, green: 0.869, blue: 0.717, alpha: 1)
        let regularColor = UIColor(white: 1, alpha: 1)
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.34, animations: {
                
                titleLabel.textColor = active ? activeColor : regularColor
                dateLabel.textColor = active ? activeColor : regularColor
                
            })
            
        }
        
    }
    
}
