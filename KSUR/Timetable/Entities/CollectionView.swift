//
//  TimetableViewControllerCollectionView.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 30.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

extension TimetableViewController: UICollectionViewDelegate { }

extension TimetableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.weekCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = weekCollectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! TimetableDayCollectionViewCell
        
        guard let dayCell = presenter.dayCell(atIndex: indexPath) else {
            return UICollectionViewCell()
        }
        
        if cell.titleLabel == nil || cell.dateLabel == nil {
            
            cell.titleLabel = dayCell.titleLabel
            cell.dateLabel = dayCell.dateLabel
            
        }
        
        cell.frame.size = dayCell.frame.size
        cell.layer.sublayers = [cell.layer.sublayers![0], dayCell.layer]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        guard let dayCell = presenter.dayCell(atIndex: indexPath) else { return }
        
        UIView.animate(withDuration: 1.0) {
            
            dayCell.titleLabel.textColor = .init(white: 1.0, alpha: 0.5)
            dayCell.dateLabel.textColor = .init(white: 1.0, alpha: 0.5)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        guard let dayCell = presenter.dayCell(atIndex: indexPath) else { return }
        
        UIView.animate(withDuration: 1.0) {
            
            dayCell.titleLabel.textColor = .init(white: 1.0, alpha: 1.0)
            dayCell.dateLabel.textColor = .init(white: 1.0, alpha: 1.0)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeDay(toIndex: indexPath.item, translation: 0)
    }
}

extension TimetableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return presenter.sizeForDayCell(atIndex: indexPath)
    }
}
