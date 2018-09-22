//
//  DayConstructorService.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 24.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol DayConstructorServiceProtocol {
    
    var apiService: APIServiceProtocol { get }
    
    var even: Bool { get set }
    func setEven(_ to: Bool)
    
    var days: [Bool: [LessonsDayProtocol?]] { get set }
    var group: LessonsGroupProtocol? { get set }
    
    func day(atIndex: Int) -> LessonsDayProtocol?
    func section(atIndex: Int, atDay: Int) -> LessonsSectionProtocol?
    
    func lesson(atIndex: IndexPath, atDay: Int) -> LessonProtocol?
    func lessonCell(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell?
    func lessonFrame(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell?
    
    func lessonsCount(atSection: Int, atDay: Int) -> Int
    func daySectionsCount(atDay: Int) -> Int
    
    func sectionHeaderTitle(atIndex: Int, atDay: Int) -> String?
    func sectionHeaderFrame(atIndex: Int, atDay: Int) -> UIView?
    
    func dayFrame(atIndex: Int) -> UIImage?
    func dayFrame(atIndex: Int, setFrame: UIImage?)
    func dayFrame(atIndex: Int, setScrollOffset: CGFloat, setScrolledFrame: UIImage?)
    
    func dayScrollOffset(atIndex: Int) -> CGFloat?
    
    func constructCells()
    
}

class DayConstructorService: DayConstructorServiceProtocol {
    
    let apiService: APIServiceProtocol
    
    var even: Bool = false
    
    func setEven(_ to: Bool) {
        even = to
    }
    
    var days = [Bool: [LessonsDayProtocol?]]()
    var group: LessonsGroupProtocol?
    
    func day(atIndex: Int) -> LessonsDayProtocol? {
        
        guard let days = self.days[self.even] else { return nil }
        guard let day = days.filter( { $0?.id == atIndex } ).first else { return nil }
        
        return day
    }
    
    func section(atIndex: Int, atDay: Int) -> LessonsSectionProtocol? {
        guard let day = day(atIndex: atDay) else { return nil }
        guard let section = day.sections.filter( { $0?.id == atIndex } ).first else { return nil }
        
        return section
    }
    
    func lesson(atIndex: IndexPath, atDay: Int) -> LessonProtocol? {
        guard let section = section(atIndex: atIndex.section, atDay: atDay) else { return nil }
        guard let lesson = (section.lessons.filter { $0?.id == atIndex.item }).first else { return nil }
        
        return lesson
    }
    
    func lessonCell(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell? {
        
        guard let lesson = self.lesson(atIndex: atIndex, atDay: atDay) else { return nil }
        
        let timeLabel = UILabel(frame: CGRect(origin: CGPoint(x: 16, y: 16), size: CGSize(width: lesson.time.width(withConstrainedHeight: 22, font: .systemFont(ofSize: 18, weight: .bold)), height: 22)))
        timeLabel.text = lesson.time
        timeLabel.font = .systemFont(ofSize: 18, weight: .bold)
        timeLabel.textColor = .white
        
        let rightX = (UIScreen.main.bounds.width / 2) + 16
        let rightWidth = (UIScreen.main.bounds.width / 2) - 32
        
        var height = CGFloat(0)
        
        height += 16
        
        let titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: rightX, y: height), size: CGSize(width: rightWidth, height: lesson.title.height(withConstrainedWidth: rightWidth, font: .systemFont(ofSize: 12, weight: .semibold)))))
        titleLabel.numberOfLines = 0
        titleLabel.text = lesson.title
        titleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textColor = .white
        
        height += titleLabel.frame.size.height + 4
        
        let subtitleLabel = UILabel(frame: CGRect(origin: CGPoint(x: rightX, y: height), size: CGSize(width: rightWidth, height: lesson.subtitle.height(withConstrainedWidth: rightWidth, font: .systemFont(ofSize: 12)))))
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = lesson.subtitle
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .lightGray
        
        height += subtitleLabel.frame.size.height + 8
        
        let separator = UIView(frame: CGRect(origin: CGPoint(x: rightX, y: height), size: CGSize(width: rightWidth, height: 1)))
        separator.backgroundColor = UIColor(white: 0.13, alpha: 1)
        
        height += separator.frame.size.height + 8
        
        let typeLabel = UILabel(frame: CGRect(origin: CGPoint(x: rightX, y: height), size: CGSize(width: rightWidth, height: lesson.type.height(withConstrainedWidth: rightWidth, font: .systemFont(ofSize: 12, weight: .semibold)))))
        typeLabel.numberOfLines = 0
        typeLabel.text = lesson.type
        typeLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        typeLabel.textColor = UIColor(red: 0, green: 0.869, blue: 0.717, alpha: 1)
        
        height += typeLabel.frame.size.height + 4
        
        let professorLabel = UILabel(frame: CGRect(origin: CGPoint(x: rightX, y: height), size: CGSize(width: rightWidth, height: lesson.professor.height(withConstrainedWidth: rightWidth, font: .systemFont(ofSize: 12)))))
        professorLabel.numberOfLines = 0
        professorLabel.text = lesson.professor
        professorLabel.font = .systemFont(ofSize: 12)
        professorLabel.textColor = .lightGray
        
        height += professorLabel.frame.size.height
        
        height += 16
        
        let lessonCell = TimetableLessonTableViewCell()
        
        lessonCell.frame.size = CGSize(width: UIScreen.main.bounds.width, height: height)
        lessonCell.backgroundColor = UIColor(white: 0.05, alpha: 1)
        
        lessonCell.addSubview(timeLabel)
        lessonCell.addSubview(titleLabel)
        lessonCell.addSubview(subtitleLabel)
        lessonCell.addSubview(separator)
        lessonCell.addSubview(typeLabel)
        lessonCell.addSubview(professorLabel)
        lessonCell.isUserInteractionEnabled = false
        
        if lesson.separator {
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = UIColor(white: 0.13, alpha: 1).cgColor
            border.frame = CGRect(x: 16, y: lessonCell.frame.size.height - width, width: lessonCell.frame.size.width - 16, height: lessonCell.frame.size.height)
            
            border.borderWidth = width
            lessonCell.layer.addSublayer(border)
            lessonCell.layer.masksToBounds = true
        }
        
        return lessonCell
    }
    
    func lessonFrame(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell? {
        guard let lesson = lesson(atIndex: atIndex, atDay: atDay) else { return nil }

        return lesson.frame
    }
    
    func lessonsCount(atSection: Int, atDay: Int) -> Int {
        guard let section = section(atIndex: atSection, atDay: atDay) else { return 0 }
        
        return section.lessons.count
    }
    
    func daySectionsCount(atDay: Int) -> Int {
        guard let sections = day(atIndex: atDay)?.sections else { return 0 }
        
        return sections.count
    }
    
    func sectionHeaderTitle(atIndex: Int, atDay: Int) -> String? {
        guard let section = section(atIndex: atIndex, atDay: atDay) else { return nil }
        
        return section.header.title
    }
    
    func sectionHeaderFrame(atIndex: Int, atDay: Int) -> UIView? {
        guard let title = sectionHeaderTitle(atIndex: atIndex, atDay: atDay) else { return nil }
        
        let headerView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: 68)))
        headerView.backgroundColor = UIColor(white: 0.05, alpha: 1)
        
        let titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: 16, y: 19), size: CGSize(width: 1, height: 30)))
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        headerView.addSubview(titleLabel)
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(white: 0.13, alpha: 1).cgColor
        border.frame = CGRect(x: 16, y: headerView.frame.size.height - width, width: headerView.frame.size.width - 16, height: headerView.frame.size.height)
        
        border.borderWidth = width
        headerView.layer.addSublayer(border)
        headerView.layer.masksToBounds = true
        
        return headerView
    }
    
    func dayFrame(atIndex: Int) -> UIImage? {
        guard let day = day(atIndex: atIndex) else { return nil }
        
        return day.scrollOffset < 10 ? day.frame : day.scrolledFrame
    }
    
    func dayFrame(atIndex: Int, setFrame frame: UIImage?) {
        
        guard let days = self.days[self.even] else { return }
        
        if atIndex < days.count {
            days[atIndex]!.frame = frame
        }
        
    }
    
    func dayFrame(atIndex: Int, setScrollOffset: CGFloat, setScrolledFrame: UIImage?) {
        
        guard let days = self.days[self.even] else { return }
        
        if atIndex < days.count {
            
            days[atIndex]!.scrollOffset = setScrollOffset
            
            days[atIndex]!.scrolledFrame = setScrolledFrame
        
        }
        
    }
    
    func dayScrollOffset(atIndex: Int) -> CGFloat? {
        
        guard let day = day(atIndex: atIndex) else { return nil }
        
        return day.scrollOffset
        
    }
    
    func constructCells() {
        
        guard let days = self.days[self.even] else { return }
        
        for day in days {
            
            let lastSection = daySectionsCount(atDay: day!.id) - 1
            
            for section in day!.sections {
                
                guard let headerView = sectionHeaderFrame(atIndex: section!.id, atDay: day!.id) else { return }
                
                section!.header.frame = headerView
                
                for lesson in section!.lessons {
                    
                    _ = section!.id == lastSection ? lesson?.separator = false : nil

                    let indexPath = IndexPath(item: lesson!.id, section: section!.id)
                    guard let lessonCell = self.lessonCell(atIndex: indexPath, atDay: day!.id) else { return }
                    lesson!.frame = lessonCell

                }
                
            }
            
        }
        
    }
    
    init(api: APIServiceProtocol) {
        
        self.apiService = api
        
        guard let group = apiService.getGroup(atIndex: 0) else { return }
        
        guard let evenDays = group.weeks.filter( { $0!.even == true } ).first!?.days else { return }
        guard let oddDays = group.weeks.filter( { $0!.even == false } ).first!?.days else { return }
        
        self.group = group
        
        self.days[true] = evenDays
        self.days[false] = oddDays
        
        self.constructCells()
    }
    
}
