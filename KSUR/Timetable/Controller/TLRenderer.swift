//
//  TLRenderer.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 9/22/18.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol TimetableRendererProtocol {
    
    func renderWeekCollectionViewBorder()
    
    func renderSegmentedControl(even: Bool)
    
    func renderDayImage(from dayId: Int, to endDayId: Int, inversed: Bool, _ completion: @escaping (() -> Void))
    func renderWeekImages(even: Bool, _ completion: @escaping (() -> Void))
    func renderTableViewImages(even: Bool, _ completion: @escaping (() -> Void))
    
}

extension TimetableViewController: TimetableRendererProtocol {
    
    func renderWeekCollectionViewBorder() {
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(white: 0.13, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: weekCollectionView.frame.size.height - width, width: weekCollectionView.frame.size.width * 2, height: weekCollectionView.frame.size.height) // *2 for scroll
        
        border.borderWidth = width
        weekCollectionView.layer.addSublayer(border)
        weekCollectionView.layer.masksToBounds = true
        
    }
    
    func renderSegmentedControl(even: Bool) {
        
        evenSegmented.removeAllSegments()
        
        evenSegmented.alpha = 1
        
        evenSegmented.insertSegment(withTitle: "Нечетная", at: 0, animated: true)
        evenSegmented.insertSegment(withTitle: "Четная", at: 1, animated: true)
        
        evenSegmented.selectedSegmentIndex = even ? 1 : 0
        
    }
    
    func renderDayImage(from dayId: Int, to endDayId: Int, inversed: Bool, _ completion: @escaping (() -> Void)) {
        
        self.selectedDay = dayId
        
        self.reloadDayTableData(animated: false) {
            
            self.dayTableView.renderedImage(completion: { (image) in
                
                self.presenter.dayFrame(atIndex: dayId, setFrame: image)
                
                if dayId == endDayId { completion(); return }
                
                let nextDayId = inversed ? dayId - 1 : dayId + 1
                
                self.renderDayImage(from: nextDayId, to: endDayId, inversed: inversed, {
                    completion()
                })
                
            })
            
        }
        
    }
    
    func renderWeekImages(even: Bool, _ completion: @escaping (() -> Void)) {
        
        dayTableView.transform = CGAffineTransform(translationX: dayTableView.frame.size.width, y: 0)
        self.view.isUserInteractionEnabled = false
        
        presenter.setEven(even)
        
        renderDayImage(from: presenter.weekCount, to: 0, inversed: true) {
            completion()
        }
        
    }
    
    func renderTableViewImages(even: Bool, _ completion: @escaping (() -> Void)) {
        
        DispatchQueue.main.async {
            
            self.renderWeekImages(even: !even) {
                
                self.renderWeekImages(even: even, {
                    
                    self.dayTableView.alpha = 0
                    self.dayTableView.transform = CGAffineTransform(translationX: 0, y: 0)
                    
                    UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                        
                        self.dayTableView.alpha = 1
                        self.loaderView.alpha = 0
                        
                    }, completion: { (_) in
                        
                        self.loaderView.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        completion()
                        
                    })
                    
                })
                
            }
            
        }
        
    }
    
}
