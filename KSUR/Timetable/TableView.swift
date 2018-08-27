//
//  TimetableViewControllerTableView.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 30.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

extension TimetableViewController: UITableViewDelegate { }

extension TimetableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.daySectionsCount(atDay: selectedDay)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.lessonsCount(atSection: section, atDay: selectedDay)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = presenter.sectionHeaderFrame(atIndex: section, atDay: selectedDay) else { return nil }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return presenter.heightForSectionHeader(atIndex: section, atDay: selectedDay)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dayTableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath)
        
        guard let lessonFrame = presenter.lessonFrame(atIndex: indexPath, atDay: selectedDay) else { return UITableViewCell() }
        lessonFrame.isUserInteractionEnabled = false
        
        cell.frame.size = lessonFrame.frame.size
        cell.layer.sublayers = [cell.layer.sublayers![0], lessonFrame.layer]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let lessonCell = presenter.lessonCell(atIndex: indexPath, atDay: selectedDay) else {
            return CGFloat.leastNormalMagnitude
        }
        
        return lessonCell.frame.size.height
    }
    
}

extension TimetableViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.onDayScroll()
    }
    
}
