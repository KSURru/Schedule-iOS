//
//  TLReloader.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 9/22/18.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol TimetableReloaderProtocol {
    
    func reloadWeekCollectionData()
    func reloadDayTableData(animated: Bool, _ completion: @escaping (() -> Void))
    
}

extension TimetableViewController: TimetableReloaderProtocol {
    
    func reloadWeekCollectionData() {
        weekCollectionView.reloadData()
    }
    
    func reloadDayTableData(animated: Bool, _ completion: @escaping (() -> Void)) {
        
        if animated {
            
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                
                self.dayTableView.alpha = 0
                
            }) { (_) in
                
                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)
                self.dayTableView.reloadData()
                CATransaction.commit()
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                    
                    self.dayTableView.alpha = 1
                    
                })
                
            }
            
        } else {
            
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            self.dayTableView.reloadData()
            CATransaction.commit()
            
        }
        
    }
    
}
