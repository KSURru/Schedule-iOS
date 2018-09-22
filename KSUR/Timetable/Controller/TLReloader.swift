//
//  TLReloader.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 9/22/18.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol TimetableReloaderProtocol {
    
    func reloadWeekCollectionData(animated: Bool, _ completion: @escaping (() -> Void))
    func reloadDayTableData(animated: Bool, _ completion: @escaping (() -> Void))
    
}

extension TimetableViewController: TimetableReloaderProtocol {
    
    func reloadWeekCollectionData(animated: Bool, _ completion: @escaping (() -> Void)) {
        
        if animated {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                
                self.weekCollectionView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).translatedBy(x: 0, y: -self.weekCollectionView.frame.size.height)
                self.weekCollectionView.alpha = 0
                
            }) { (_) in
                
                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)
                self.weekCollectionView.reloadData()
                CATransaction.commit()
                
                UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                    
                    self.weekCollectionView.transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: 0)
                    self.weekCollectionView.alpha = 1
                    
                })
                
                self.renderWeekCollectionViewBorder()
                
            }
            
        } else {
            
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            self.weekCollectionView.reloadData()
            CATransaction.commit()
            
        }
        
    }
    
    func reloadDayTableData(animated: Bool, _ completion: @escaping (() -> Void)) {
        
        if animated {
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                
                self.dayTableView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).translatedBy(x: 0, y: 400)
                self.dayTableView.alpha = 0
                
            }) { (_) in
                
                CATransaction.begin()
                CATransaction.setCompletionBlock(completion)
                self.dayTableView.reloadData()
                CATransaction.commit()
                
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                    
                    self.dayTableView.transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: 0)
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
