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
    
    var even: Bool { get set }
    func setEven(_ to: Bool)
    
    var weeks: [Bool: [Day]] { get set }
    var weeksCells: [Bool: [Int: TimetableDayCollectionViewCell]] { get set }
    
    func day(atIndex: Int, even: Bool) -> Day?
    func dayCell(atIndex: Int, isActive: Bool, even: Bool) -> TimetableDayCollectionViewCell?
    
    func constructCells(active: Int)
    func updateActiveCell(toIndex: Int)
}

class WeekConstructorService: WeekConstructorServiceProtocol {
    
    var activeCell = 0
    
    var even: Bool = false
    
    func setEven(_ to: Bool) {
        even = to
    }
    
    var weeksCells: [Bool: [Int: TimetableDayCollectionViewCell]] = [:]
    
    var weeks = [Bool: [Day]]()
    
    func day(atIndex: Int, even: Bool) -> Day? {
        
        guard let week = weeks[even] else { return nil }
        
        if week.indices.contains(atIndex) {
            return week[atIndex]
        } else {
            return nil
        }
    }
    
    func dayCell(atIndex: Int, isActive: Bool, even: Bool) -> TimetableDayCollectionViewCell? {
        
        guard let day = self.day(atIndex: atIndex, even: even) else {
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
        
        for week in weeks {
            
            var i = 0
            
            let e = week.key
            
            var wc = [Int: TimetableDayCollectionViewCell]()
            
            for _ in week.value {
                
                wc[i] = dayCell(atIndex: i, isActive: (i == active ? true : false), even: e)
                
                i += 1
                
            }
            
            weeksCells[e] = wc
            
        }
    }
    
    func updateActiveCell(toIndex: Int) {
        
        if toIndex != activeCell {
            
            guard var weekCells = weeksCells[self.even] else { return }
            
            weekCells[activeCell] = self.dayCell(atIndex: activeCell, isActive: false, even: self.even)
            weekCells[toIndex] = self.dayCell(atIndex: toIndex, isActive: true, even: self.even)
            
            activeCell = toIndex
            
        }
        
    }
    
    init() {
        
        let now = Date()
        
        var startDate = Date()
        var interval: TimeInterval = 0
        
        if Calendar.current.dateInterval(of: .weekOfYear, start: &startDate, interval: &interval, for: now) {
            
            var actualWeek = [Day]()
            var nextWeek = [Day]()
            
            var i = 0
            
            while i < 5 {
                
                let titleFormatter : DateFormatter = DateFormatter()
                titleFormatter.dateFormat = "EEEE" // ex. Monday
                
                let dateFormatter : DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM" // ex. 17 Sep
                
                guard let date = Calendar.current.date(byAdding: .day, value: +i, to: startDate) else { return }
                let dateString = dateFormatter.string(from: date)
                let titleString = titleFormatter.string(from: date)
                
                let d = Day(titleString, date: dateString)
                
                
                
                 actualWeek.append(d)
                
                i += 1
                
            }
            
            i += 2
            
            while i < 12 {
                
                let titleFormatter : DateFormatter = DateFormatter()
                titleFormatter.dateFormat = "EEEE" // ex. Monday
                
                let dateFormatter : DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM" // ex. 17 Sep
                
                guard let date = Calendar.current.date(byAdding: .day, value: +i, to: startDate) else { return }
                let dateString = dateFormatter.string(from: date)
                let titleString = titleFormatter.string(from: date)
                
                let d = Day(titleString, date: dateString)
                
                
                
                nextWeek.append(d)
                
                i += 1
                
            }
            
            weeks[self.even] = actualWeek
            weeks[!self.even] = nextWeek
            
            self.constructCells(active: activeCell)
            
        }
        
    }
}
