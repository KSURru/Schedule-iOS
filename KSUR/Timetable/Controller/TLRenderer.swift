//
//  TLRenderer.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 9/22/18.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol TimetableRendererProtocol {
    
    func renderDayTableView(_ completion: @escaping (() -> Void))
    func renderWeekCollectionView(_ completion: @escaping (() -> Void))
    func renderWeekCollectionViewBorder()
    func renderSegmentedControl(weekType: WeekType)
    
    func renderDayImage(from dayId: Int, to endDayId: Int, inversed: Bool, _ completion: @escaping (() -> Void))
    func renderWeekImages(weekType: WeekType, _ completion: @escaping (() -> Void))
    func renderTableViewImages(weekType: WeekType, _ completion: @escaping (() -> Void))
    
}

extension TimetableViewController: TimetableRendererProtocol {
    
    func renderDayTableView(_ completion: @escaping (() -> Void)) {
        
        dayTableView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).translatedBy(x: 0, y: 400)
        dayTableView.alpha = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { (_) in
            
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                
                self.dayTableView.transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: 0)
                self.dayTableView.alpha = 1
                
            }) { (_) in completion() }
            
        }
        
    }
    
    func renderWeekCollectionView(_ completion: @escaping (() -> Void)) {
        
        weekCollectionView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).translatedBy(x: 0, y: -self.weekCollectionView.frame.size.height)
        weekCollectionView.alpha = 0
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            
            self.weekCollectionView.transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: 0)
            self.weekCollectionView.alpha = 1
            
        }) { (_) in completion() }
        
    }
    
    func renderWeekCollectionViewBorder() {
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(white: 0.13, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: weekCollectionView.frame.size.height - width, width: weekCollectionView.frame.size.width * 2, height: weekCollectionView.frame.size.height) // *2 for scroll
        
        border.borderWidth = width
        weekCollectionView.layer.addSublayer(border)
        weekCollectionView.layer.masksToBounds = true
        
    }
    
    func renderSegmentedControl(weekType: WeekType) {
        
        evenSegmented.removeAllSegments()
        
        evenSegmented.alpha = 1
        
        evenSegmented.insertSegment(withTitle: "Нечетная", at: 0, animated: true)
        evenSegmented.insertSegment(withTitle: "Четная", at: 1, animated: true)
        
        evenSegmented.selectedSegmentIndex = weekType.bool ? 1 : 0
        
    }
    
    func renderDayImage(from dayId: Int, to endDayId: Int, inversed: Bool, _ completion: @escaping (() -> Void)) {
        
        self.selectedDay = dayId
        
        self.reloadDayTableData(animated: false) {
            
            self.dayTableView.renderedImage(completion: { (image) in
                
                self.presenter.dayFrame(atIndex: dayId, setFrame: image)
                
                if dayId == endDayId { completion(); return }
                
                let nextDayId = inversed ? dayId - 1 : dayId + 1
                
                self.renderDayImage(from: nextDayId, to: endDayId, inversed: inversed, { completion() })
                
            })
            
        }
        
    }
    
    func renderWeekImages(weekType: WeekType, _ completion: @escaping (() -> Void)) {
        
        dayTableView.transform = CGAffineTransform(translationX: dayTableView.frame.size.width, y: 0)
        self.view.isUserInteractionEnabled = false
        
        presenter.setWeekType(weekType)
        
        renderDayImage(from: presenter.weekCount, to: 0, inversed: true) { completion() }
        
    }
    
    func renderTableViewImages(weekType: WeekType, _ completion: @escaping (() -> Void)) {
        
        DispatchQueue.main.async {
            
            self.renderWeekImages(weekType: !weekType) {
                
                self.renderWeekImages(weekType: weekType, {
                    
                    self.loaderView.stopAnimating()
                    
                    self.reloadWeekCollectionData(animated: false, {})
                    self.renderWeekCollectionViewBorder()
                    
                    self.renderWeekCollectionView({})
                    
                    self.renderDayTableView {
                        
                        self.view.isUserInteractionEnabled = true
                        
                        completion()
                        
                    }
                    
                    self.renderSegmentedControl(weekType: weekType)
                    
                })
                
            }
            
        }
        
    }
    
}
