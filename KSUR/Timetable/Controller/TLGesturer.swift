//
//  TLGesturer.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 9/22/18.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol TimetableGesturerProtocol {
    
    func leftSwipe(_ prevTransform: CGAffineTransform, _ nextTransform: CGAffineTransform)
    func rightSwipe(_ prevTransform: CGAffineTransform, _ nextTransform: CGAffineTransform)
    func createPanGestureRecognizer()
    
}

extension TimetableViewController: TimetableGesturerProtocol {
    
    @objc func leftSwipe(_ prevTransform: CGAffineTransform, _ nextTransform: CGAffineTransform) {
        _ = selectedDay == presenter.weekCount - 1 ? changeDay(toIndex: 0, animation: .manual, prevTransform: prevTransform, nextTransform: nextTransform) : changeDay(toIndex: selectedDay + 1, animation: .manual, prevTransform: prevTransform, nextTransform: nextTransform)
    }
    
    @objc func rightSwipe(_ prevTransform: CGAffineTransform, _ nextTransform: CGAffineTransform) {
        _ = selectedDay == 0 ? changeDay(toIndex: presenter.weekCount - 1, animation: .manual, prevTransform: prevTransform, nextTransform: nextTransform) : changeDay(toIndex: selectedDay - 1, animation: .manual, prevTransform: prevTransform, nextTransform: nextTransform)
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
        
        let translationX = self.renderedPrevImageView.transform.tx + translation.x
        
        let ratio = abs( translationX / dayTableView.frame.size.width )
        
        let prevScale = 1.0 - 0.3 * ratio
        
        let transform = CGAffineTransform(translationX: translationX, y: 0).scaledBy(x: prevScale, y: prevScale)
        
        self.renderedPrevImageView.image = presenter.dayFrame(atIndex: fromIndex)
        self.renderedPrevImageView.transform = transform
        self.renderedPrevImageView.alpha = 1
        
        if self.renderedPrevImageView.transform.tx > -10 && self.renderedPrevImageView.transform.tx < 10 {
            
            direction = 0
            
        }
        
        var isCorner = false
        
        if translation.x > 0 {
            
            toIndex = selectedDay == 0 ? presenter.weekCount - 1 : selectedDay - 1
            
            if direction == 0 {
                
                direction = -1
                
                isCorner = selectedDay == 0
                
                if isCorner {
                    
                    let r = Int.random(in: 0..<cornerStickers[.left]!.count)
                    
                    self.renderedNextImageView.image = cornerStickers[.left]![r]
                    self.renderedNextImageView.backgroundColor = .clear
                    renderedNextImageView.contentMode = .center
                    self.renderedNextImageView.transform = CGAffineTransform(translationX: self.dayTableView.frame.size.width * CGFloat(direction), y: 0).scaledBy(x: 0.7, y: 0.7)
                    self.renderedNextImageView.alpha = 1
                    
                } else {
                    
                    self.renderedNextImageView.image = presenter.dayFrame(atIndex: toIndex)
                    renderedNextImageView.backgroundColor = UIColor(white: 0.05, alpha: 1)
                    renderedNextImageView.contentMode = .top
                    self.renderedNextImageView.transform = CGAffineTransform(translationX: self.dayTableView.frame.size.width * CGFloat(direction), y: 0).scaledBy(x: 0.7, y: 0.7)
                    self.renderedNextImageView.alpha = 1
                    
                }
                
            }
            
        } else if translation.x < 0 {
            
            toIndex = selectedDay == presenter.weekCount - 1 ? 0 : selectedDay + 1
            
            if direction == 0 {
                
                direction = 1
                
                isCorner = selectedDay == presenter.weekCount - 1
                
                if isCorner {
                    
                    let r = Int.random(in: 0..<cornerStickers[.right]!.count)
                    
                    self.renderedNextImageView.image = cornerStickers[.right]![r]
                    self.renderedNextImageView.backgroundColor = .clear
                    renderedNextImageView.contentMode = .center
                    self.renderedNextImageView.transform = CGAffineTransform(translationX: self.dayTableView.frame.size.width * CGFloat(direction), y: 0).scaledBy(x: 0.7, y: 0.7)
                    self.renderedNextImageView.alpha = 1
                    
                } else {
                    
                    self.renderedNextImageView.image = presenter.dayFrame(atIndex: toIndex)
                    renderedNextImageView.backgroundColor = UIColor(white: 0.05, alpha: 1)
                    renderedNextImageView.contentMode = .top
                    self.renderedNextImageView.transform = CGAffineTransform(translationX: self.dayTableView.frame.size.width * CGFloat(direction), y: 0).scaledBy(x: 0.7, y: 0.7)
                    self.renderedNextImageView.alpha = 1
                    
                }
                
            }
            
        }
        
        let nextTranslationX = self.renderedNextImageView.transform.tx + translation.x
        let nextTranslationY = CGFloat(0) //400 - 400 * ratio
        
        let nextScale = isCorner ? 1.0 : 0.7 + 0.3 * ratio
        
        self.renderedNextImageView.transform = CGAffineTransform(translationX: nextTranslationX, y: nextTranslationY).scaledBy(x: nextScale, y: nextScale)
        
        recognizer.setTranslation(.zero, in: recognizer.view!)
        
    }
    
    func onTablePanXEnd(recognizer: UIPanGestureRecognizer) {
        
        self.view.isUserInteractionEnabled = false
        
        isPanX = false
        
        if abs(self.renderedPrevImageView.transform.tx) > (UIScreen.main.bounds.size.width / 5) && !(selectedDay == presenter.weekCount - 1 && direction == 1) && !(selectedDay == 0 && direction != 1) {
            if direction == 1 { leftSwipe(self.renderedPrevImageView.transform, self.renderedNextImageView.transform) } else { rightSwipe(self.renderedPrevImageView.transform, self.renderedNextImageView.transform) }
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
