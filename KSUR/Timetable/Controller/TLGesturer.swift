//
//  TLGesturer.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 9/22/18.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol TimetableGesturerProtocol {
    
    func leftSwipe(_ translation: CGFloat)
    func rightSwipe(_ translation: CGFloat)
    func createPanGestureRecognizer()
    
}

extension TimetableViewController: TimetableGesturerProtocol {
    
    @objc func leftSwipe(_ translation: CGFloat) {
        _ = selectedDay == presenter.weekCount - 1 ? changeDay(toIndex: 0, translation: -translation) : changeDay(toIndex: selectedDay + 1, translation: -translation)
    }
    
    @objc func rightSwipe(_ translation: CGFloat) {
        _ = selectedDay == 0 ? changeDay(toIndex: presenter.weekCount - 1, translation: translation) : changeDay(toIndex: selectedDay - 1, translation: translation)
    }
    
    func createPanGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(recognizer:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        dayTableView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let state = recognizer.state
        let translation = recognizer.translation(in: self.dayTableView)
        
        switch state {
        case .began:
            _ = abs(translation.x) > abs(translation.y) ? onTablePanXBegin(recognizer: recognizer) : nil
            break
        case .changed:
            _ = isPanX ? onTablePanXChange(recognizer: recognizer) : nil
        case .ended:
            _ = isPanX ? onTablePanXEnd(recognizer: recognizer) : nil
        case .cancelled:
            isPanX = false
            break
        default:
            break
        }
    }
    
    func onTablePanXBegin(recognizer: UIPanGestureRecognizer) {
        
        direction = 0
        isPanX = true
        
    }
    
    func onTablePanXChange(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.dayTableView)
        
        dayTableView.alpha = 0
        
        let fromIndex = selectedDay
        var toIndex = selectedDay
        
        self.renderedPrevImageView.image = presenter.dayFrame(atIndex: fromIndex)
        self.renderedPrevImageView.transform = CGAffineTransform(translationX: self.renderedPrevImageView.transform.tx + translation.x, y: 0)
        self.renderedPrevImageView.alpha = 1
        
        if self.renderedPrevImageView.transform.tx > -10 && self.renderedPrevImageView.transform.tx < 10 {
            
            direction = 0
            
        }
        
        if translation.x > 0 {
            
            toIndex = selectedDay == 0 ? presenter.weekCount - 1 : selectedDay - 1
            
            if direction == 0 {
                direction = -1
                self.renderedNextImageView.image = presenter.dayFrame(atIndex: toIndex)
                self.renderedNextImageView.transform = CGAffineTransform(translationX: self.dayTableView.frame.size.width * CGFloat(direction), y: 0)
                self.renderedNextImageView.alpha = 1
            }
            
        } else if translation.x < 0 {
            
            toIndex = selectedDay == presenter.weekCount - 1 ? 0 : selectedDay + 1
            
            if direction == 0 {
                direction = 1
                self.renderedNextImageView.image = presenter.dayFrame(atIndex: toIndex)
                self.renderedNextImageView.transform = CGAffineTransform(translationX: self.dayTableView.frame.size.width * CGFloat(direction), y: 0)
                self.renderedNextImageView.alpha = 1
            }
            
        }
        
        self.renderedNextImageView.transform = CGAffineTransform(translationX: self.renderedNextImageView.transform.tx + translation.x, y: 0)
        
        recognizer.setTranslation(.zero, in: recognizer.view!)
        
    }
    
    func onTablePanXEnd(recognizer: UIPanGestureRecognizer) {
        
        self.view.isUserInteractionEnabled = false
        
        isPanX = false
        
        if abs(self.renderedPrevImageView.transform.tx) > (UIScreen.main.bounds.size.width / 5) {
            if direction == 1 { leftSwipe(abs(self.renderedPrevImageView.transform.tx)) } else { rightSwipe(abs(self.renderedPrevImageView.transform.tx)) }
        } else {
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                
                self.renderedPrevImageView.transform = CGAffineTransform(translationX: 0, y: 0)
                let w = self.dayTableView.frame.size.width
                self.renderedNextImageView.transform = CGAffineTransform(translationX: CGFloat(self.direction) * w, y: 0)
                
            }) { (_) in
                
                self.renderedPrevImageView.alpha = 0
                self.renderedNextImageView.alpha = 0
                self.direction = 0
                self.dayTableView.alpha = 1
                self.view.isUserInteractionEnabled = true
            }
            
        }
        
    }
    
}
