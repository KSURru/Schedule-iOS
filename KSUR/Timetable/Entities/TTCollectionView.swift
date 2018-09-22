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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let tCell = cell as! TimetableDayCollectionViewCell
        
        tCell.isActive = indexPath.item == selectedDay
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tCell = weekCollectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! TimetableDayCollectionViewCell
        
        guard let dayCell = presenter.dayCell(atIndex: indexPath) else {
            return UICollectionViewCell()
        }
        
        if tCell.titleLabel == nil || tCell.dateLabel == nil {
            
            tCell.titleLabel = dayCell.titleLabel
            tCell.dateLabel = dayCell.dateLabel
            
        }
        
        tCell.frame.size = dayCell.frame.size
        tCell.layer.sublayers = [tCell.layer.sublayers![0], dayCell.layer]
        
        return tCell
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
