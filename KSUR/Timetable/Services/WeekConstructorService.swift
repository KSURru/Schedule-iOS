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
    
    var weeks: [WeekPeriod: [Weekday]] { get set }
    
    func weekCount(weekPeriod: WeekPeriod) -> Int
    
    func weekday(atIndex: Int, weekPeriod: WeekPeriod) -> Weekday?
    func weekdayCell(atIndex: Int, isActive: Bool, weekPeriod: WeekPeriod) -> TimetableWeekdayCollectionViewCell?
    func weekdayFrame(atIndex: Int, weekPeriod: WeekPeriod) -> TimetableWeekdayCollectionViewCell?
    
    func constructCells(active: Int)
    func updateActiveCell(toIndex: Int, weekPeriod: WeekPeriod)
    
}

class WeekConstructorService: WeekConstructorServiceProtocol {
    
    var activeCell = 0
    
    var weeks = [WeekPeriod: [Weekday]]()
    
    func weekCount(weekPeriod: WeekPeriod) -> Int {
        
        guard let weeks = weeks[weekPeriod] else { return 0 }
        
        return weeks.count
        
    }
    
    func weekday(atIndex: Int, weekPeriod: WeekPeriod) -> Weekday? {
        
        guard let week = weeks[weekPeriod] else { return nil }
        
        if week.indices.contains(atIndex) {
            
            return week[atIndex]
            
        } else {
            
            return nil
            
        }
        
    }
    
    func weekdayCell(atIndex: Int, isActive: Bool, weekPeriod: WeekPeriod) -> TimetableWeekdayCollectionViewCell? {
        
        guard let weekday = self.weekday(atIndex: atIndex, weekPeriod: weekPeriod) else { return nil }
        
        let activeTextColor = UIColor(red: 0, green: 0.869, blue: 0.717, alpha: 1)
        
        let titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: 16, y: 16), size: CGSize(width: weekday.title.width(withConstrainedHeight: 16, font: .systemFont(ofSize: 13, weight: .bold)), height: 16)))
        titleLabel.text = weekday.title
        titleLabel.font = .systemFont(ofSize: 13, weight: .bold)
        titleLabel.textColor = isActive ? activeTextColor : .white
        
        let dateLabel = UILabel(frame: CGRect(origin: CGPoint(x: 16, y: 35), size: CGSize(width: weekday.date.width(withConstrainedHeight: 17, font: .systemFont(ofSize: 14)), height: 17)))
        dateLabel.text = weekday.date
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = isActive ? activeTextColor : .white
        
        let width = titleLabel.frame.size.width > dateLabel.frame.size.width ? titleLabel.frame.size.width : dateLabel.frame.size.width
        
        let weekdayCell = TimetableWeekdayCollectionViewCell()
        
        weekdayCell.frame.size = CGSize(width: width + 32, height: 68)
        weekdayCell.backgroundColor = UIColor(white: 0.05, alpha: 1)
        
        weekdayCell.titleLabel = titleLabel
        weekdayCell.dateLabel = dateLabel
        
        weekdayCell.addSubview(titleLabel)
        weekdayCell.addSubview(dateLabel)
        weekdayCell.isUserInteractionEnabled = false
        
        return weekdayCell
    }
    
    func weekdayFrame(atIndex: Int, weekPeriod: WeekPeriod) -> TimetableWeekdayCollectionViewCell? {
        guard let weekday = weekday(atIndex: atIndex, weekPeriod: weekPeriod) else { return nil }
        
        return weekday.frame
        
    }
    
    func constructCells(active: Int) {
        
        for w in weeks {
            
            var i = 0
            
            let weekPeriod = w.key
            
            guard let week = weeks[weekPeriod] else { return }
            
            for _ in w.value {
                
                guard let weekdayCell = weekdayCell(atIndex: i, isActive: (i == active ? true : false), weekPeriod: weekPeriod) else { return }
                
                week[i].frame = weekdayCell
                
                i += 1
                
            }
            
        }
    }
    
    func updateActiveCell(toIndex: Int, weekPeriod: WeekPeriod) {
        
        if toIndex != activeCell {
            
            guard var week = weeks[weekPeriod] else { return }
            
            week[activeCell].frame = self.weekdayCell(atIndex: activeCell, isActive: false, weekPeriod: weekPeriod)
            week[toIndex].frame = self.weekdayCell(atIndex: toIndex, isActive: true, weekPeriod: weekPeriod)
            
            activeCell = toIndex
            
        }
        
    }
    
    init() {
        
        let now = Date()
        
        var startDate = Date()
        var interval: TimeInterval = 0
        
        var calendar = Calendar.current
            calendar.locale = Locale(identifier: "ru_RU")
        
        if calendar.dateInterval(of: .weekOfYear, start: &startDate, interval: &interval, for: now) {
            
            var currentWeek = [Weekday]()
            var nextWeek = [Weekday]()
            
            let titleFormatter : DateFormatter = DateFormatter()
            titleFormatter.locale = Locale(identifier: "ru_RU")
            titleFormatter.dateFormat = "EEEE" // ex. Monday
            
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "dd MMM" // ex. 17 Sep
            
            var i = 0
            
            while i < 5 {
                
                guard let date = Calendar.current.date(byAdding: .day, value: +i, to: startDate) else { return }
                let dateString = dateFormatter.string(from: date)
                let titleString = titleFormatter.string(from: date).capitalized
                
                let wd = Weekday(titleString, date: dateString)
                
                
                
                 currentWeek.append(wd)
                
                i += 1
                
            }
            
            i += 2
            
            while i < 12 {
                
                guard let date = Calendar.current.date(byAdding: .day, value: +i, to: startDate) else { return }
                let dateString = dateFormatter.string(from: date)
                let titleString = titleFormatter.string(from: date).capitalized
                
                let wd = Weekday(titleString, date: dateString)
                
                
                
                nextWeek.append(wd)
                
                i += 1
                
            }
            
            weeks[.current] = currentWeek
            weeks[.next] = nextWeek
            
            self.constructCells(active: activeCell)
            
        }
        
    }
}
