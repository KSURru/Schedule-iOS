//
//  TLView.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 03.08.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol TimetableViewProtocol: class, TimetableRendererProtocol, TimetableGesturerProtocol, TimetableReloaderProtocol {
    
    func changeDay(toIndex: Int, transform: CGAffineTransform)
    
}

extension TimetableViewController: TimetableViewProtocol {
    
    @objc func changeDay(toIndex: Int, transform: CGAffineTransform) {
        
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
        
        renderedPrevImageView.transform = transform
        renderedNextImageView.transform = CGAffineTransform(translationX: -tableWidthTranslation + transform.tx, y: 0)
        
        renderedPrevImageView.image = presenter.dayFrame(atIndex: fromIndex)
        renderedPrevImageView.alpha = 1
        
        self.renderedNextImageView.image = presenter.dayFrame(atIndex: toIndex)
        self.renderedNextImageView.alpha = 1
        
        self.view.isUserInteractionEnabled = false
        
        presenter.dayFrame(atIndex: fromIndex, setScrollOffset: 0, setScrolledFrame: nil)
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            
            self.renderedPrevImageView.transform = CGAffineTransform(translationX: tableWidthTranslation, y: 0).scaledBy(x: 0.7, y: 0.7)
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
    
}
