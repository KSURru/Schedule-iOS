//
//  TimetableViewControllerProtocol.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 03.08.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

extension TimetableViewController: TimetableViewProtocol {
    
    
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
    
    func addBorderToWeekCollectionView() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(white: 0.13, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: weekCollectionView.frame.size.height - width, width: weekCollectionView.frame.size.width, height: weekCollectionView.frame.size.height)
        
        border.borderWidth = width
        weekCollectionView.layer.addSublayer(border)
        weekCollectionView.layer.masksToBounds = true
    }
    
    @objc func changeDay(toIndex: Int, translation: CGFloat) {
        
        let fromIndex = selectedDay
        
        let activeCell = weekCollectionView.cellForItem(at: IndexPath(item: self.selectedDay, section: 0)) as? TimetableDayCollectionViewCell
        let selectedCell = weekCollectionView.cellForItem(at: IndexPath(item: toIndex, section: 0)) as? TimetableDayCollectionViewCell
        
        if activeCell != nil { activeCell!.isActive = false }
        if selectedCell != nil { selectedCell!.isActive = true }
        
        weekCollectionView.scrollToItem(at: .init(item: toIndex, section: 0), at: .right, animated: true)
        
        var tableWidthTranslation = selectedDay < toIndex ? -(self.dayTableView.frame.size.width) : (self.dayTableView.frame.size.width)
        tableWidthTranslation = selectedDay == toIndex ? 0 : tableWidthTranslation
        
        selectedDay = toIndex
        dayTableView.alpha = 0
        reloadDayTableData(animated: false, {})
        
        renderedPrevImageView.transform = CGAffineTransform(translationX: translation, y: 0)
        renderedNextImageView.transform = CGAffineTransform(translationX: -tableWidthTranslation + translation, y: 0)
        
        renderedPrevImageView.image = presenter.dayFrame(atIndex: fromIndex)
        renderedPrevImageView.alpha = 1
        
        self.renderedNextImageView.image = presenter.dayFrame(atIndex: toIndex)
        self.renderedNextImageView.alpha = 1
        
        self.view.isUserInteractionEnabled = false
        
        presenter.dayFrame(atIndex: fromIndex, setScrollOffset: 0, setScrolledFrame: nil)
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            
            self.renderedPrevImageView.transform = CGAffineTransform(translationX: tableWidthTranslation, y: 0)
            self.renderedNextImageView.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }) { (_) in
            
            self.renderedPrevImageView.alpha = 0
            self.renderedPrevImageView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.renderedNextImageView.alpha = 0
            self.renderedNextImageView.transform = CGAffineTransform(translationX: 0, y: 0)
            
            self.dayTableView.alpha = 1
            self.view.isUserInteractionEnabled = true
        }
    }
    
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
    
    func onDayScroll() {
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (_) in
        
            let scrollOffset = self.dayTableView.contentOffset.y
            
            self.dayTableView.renderedImage(completion: { (image) in
                self.presenter.dayFrame(atIndex: self.selectedDay, setScrollOffset: scrollOffset, setScrolledFrame: image)
            })
            
//            guard let renderedTableViewImage = self.dayTableView.renderedImage else { return }
            
//            self.presenter.dayFrame(atIndex: self.selectedDay, setScrollOffset: scrollOffset, setScrolledFrame: renderedTableViewImage)
            
        }
    
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
                    
                    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                        
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