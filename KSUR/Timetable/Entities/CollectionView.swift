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
        
        weekCollectionView.register(TimetableDayCollectionViewCell.self, forCellWithReuseIdentifier: "dayCell")
        let cell = weekCollectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath)
        
        guard let dayCell = presenter.dayCell(atIndex: indexPath) else {
            return UICollectionViewCell()
        }
        
        cell.frame.size = dayCell.frame.size
        cell.layer.addSublayer(dayCell.layer)
        
        return cell
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
