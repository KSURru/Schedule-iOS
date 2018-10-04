//
//  TLCollectionView.swift
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let tCell = cell as! TimetableWeekdayCollectionViewCell
        
        tCell.isActive = indexPath.item == selectedDay
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tCell = weekCollectionView.dequeueReusableCell(withReuseIdentifier: "weekdayCell", for: indexPath) as! TimetableWeekdayCollectionViewCell
        
        guard let dayCell = presenter.weekdayFrame(atIndex: indexPath.item) else { return UICollectionViewCell() }
        
        if tCell.titleLabel != dayCell.titleLabel && tCell.dateLabel != dayCell.dateLabel {
            
            tCell.titleLabel = dayCell.titleLabel
            tCell.dateLabel = dayCell.dateLabel
            
        }
        
        tCell.frame.size = dayCell.frame.size
        tCell.layer.sublayers = [tCell.layer.sublayers![0], dayCell.layer]
        
        return tCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        changeDay(toIndex: indexPath.item, animation: .auto, prevTransform: CGAffineTransform(), nextTransform: CGAffineTransform())
        
    }
}

extension TimetableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return presenter.sizeForWeekdayCell(atIndex: indexPath.item)
    }
}
