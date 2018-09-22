//
//  WeekConstructorService.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 24.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol WeekConstructorServiceProtocol {
    var activeCell: Int { get set }
    
    var week: [Day] { get set }
    var weekCells: [Int: TimetableDayCollectionViewCell] { get set }
    
    func day(atIndex: Int) -> Day?
    func dayCell(atIndex: Int, isActive: Bool) -> TimetableDayCollectionViewCell?
    
    func constructCells(active: Int)
    func updateActiveCell(toIndex: Int)
}

class WeekConstructorService: WeekConstructorServiceProtocol {
    
    var weekCells: [Int: TimetableDayCollectionViewCell] = [:]
    
    var week = [
        Day("Понедельник", date: "23 июня"),
        Day("Вторник", date: "24 июня"),
        Day("Среда", date: "25 июня"),
        Day("Четверг", date: "26 июня"),
        Day("Пятница", date: "27 июня")
    ]
    
    var activeCell = 0
    
    func day(atIndex: Int) -> Day? {
        if week.indices.contains(atIndex) {
            return week[atIndex]
        } else {
            return nil
        }
    }
    
    func dayCell(atIndex: Int, isActive: Bool) -> TimetableDayCollectionViewCell? {
        
        guard let day = self.day(atIndex: atIndex) else {
            return nil
        }
        
        let activeTextColor = UIColor(red: 0, green: 0.869, blue: 0.717, alpha: 1)
        
        let titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: 16, y: 16), size: CGSize(width: day.title.width(withConstrainedHeight: 16, font: .systemFont(ofSize: 13, weight: .bold)), height: 16)))
        titleLabel.text = day.title
        titleLabel.font = .systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = isActive ? activeTextColor : .white
        
        let dateLabel = UILabel(frame: CGRect(origin: CGPoint(x: 16, y: 35), size: CGSize(width: day.date.width(withConstrainedHeight: 17, font: .systemFont(ofSize: 14)), height: 17)))
        dateLabel.text = day.date
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = isActive ? activeTextColor : .white
        
        let width = titleLabel.frame.size.width > dateLabel.frame.size.width ? titleLabel.frame.size.width : dateLabel.frame.size.width
        
        let dayCell = TimetableDayCollectionViewCell()
        
        dayCell.frame.size = CGSize(width: width + 32, height: 68)
        dayCell.backgroundColor = UIColor(white: 0.05, alpha: 1)
        
        dayCell.titleLabel = titleLabel
        dayCell.dateLabel = dateLabel
        
        dayCell.addSubview(titleLabel)
        dayCell.addSubview(dateLabel)
        dayCell.isUserInteractionEnabled = false
        
        return dayCell
    }
    
    func constructCells(active: Int) {
        
        var i = 0
        
        for _ in week {
            
            weekCells[i] = dayCell(atIndex: i, isActive: (i == active ? true : false))
            
            i += 1
        }
    }
    
    func updateActiveCell(toIndex: Int) {
        
        if toIndex != activeCell {
            
            weekCells[activeCell] = self.dayCell(atIndex: activeCell, isActive: false)
            weekCells[toIndex] = self.dayCell(atIndex: toIndex, isActive: true)
            
            activeCell = toIndex
            
        }
        
    }
    
    init() {
        self.constructCells(active: activeCell)
    }
}
