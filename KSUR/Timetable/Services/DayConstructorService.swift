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
    
    var days: [LessonsDayProtocol?] { get set }
    
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
    
    func constructCells()
    
}

class DayConstructorService: DayConstructorServiceProtocol {
    
    let apiService: APIServiceProtocol
    
    var days = [LessonsDayProtocol?]()
    
    func day(atIndex: Int) -> LessonsDayProtocol? {
        guard let day = ( days.filter { $0?.id == atIndex } ).first else { return nil }
        
        return day
    }
    
    func section(atIndex: Int, atDay: Int) -> LessonsSectionProtocol? {
        guard let day = day(atIndex: atDay) else { return nil }
        guard let section = (day.sections.filter { $0?.id == atIndex }).first else { return nil }
        
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
        
        return day.frame
    }
    
    func dayFrame(atIndex: Int, setFrame: UIImage?) {
        guard let day = days[atIndex] else { return }
        
        days[atIndex]!.frame = setFrame
    }
    
    func constructCells() {
        
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
        
        guard let week = apiService.getWeek(group: 0, even: 0) else { return }
        
        days = week
        
        self.constructCells()
    }
    
//    var days: [LessonsDayProtocol?] = [
//        LessonsDay(
//            id: 0,
//            title: "Понедельник",
//            sections: [
//                LessonsSection(
//                    id: 0,
//                    header: LessonsSectionHeader("1 пара"),
//                    lessons: [
//                        Lesson(id: 0, title: "Элективные дисциплины по физической культуре и спорту", subtitle: "Спортивный зал", time: "9:00 – 10:30", professor: "Преподаватель кафедры", type: "Практика")
//                    ]
//                ),
//                LessonsSection(
//                    id: 1,
//                    header: LessonsSectionHeader("2 пара"),
//                    lessons: [
//                        Lesson(id: 0, title: "Элективные дисциплины по физической культуре и спорту", subtitle: "Спортивный зал", time: "10:40 – 12:10", professor: "Преподаватель кафедры", type: "Практика")
//                    ]
//                )
//            ]
//        ),
//        LessonsDay(
//            id: 1,
//            title: "Вторник",
//            sections: [
//                LessonsSection(
//                    id: 0,
//                    header: LessonsSectionHeader("1 пара"),
//                    lessons: [
//                        Lesson(id: 0, title: "Сетевые технологии", subtitle: "Аудитория 1611", time: "9:00 – 10:30", professor: "Стрельников Б.А.", type: "Лекция")
//                    ]
//                ),
//                LessonsSection(
//                    id: 1,
//                    header: LessonsSectionHeader("2 пара"),
//                    lessons: [
//                        Lesson(id: 0, title: "Сетевые технологии", subtitle: "Аудитория 1226", time: "10:40 – 12:10", professor: "Стрельников Б.А.", type: "Лабораторная")
//                    ]
//                ),
//                LessonsSection(
//                    id: 2,
//                    header: LessonsSectionHeader("3 пара"),
//                    lessons: [
//                        Lesson(id: 0, title: "Математические методы обработки статистических данных", subtitle: "Аудитория 1818", time: "12:40 - 14:10", professor: "Севастьянов П.А.", type: "Лекция")
//                    ]
//                )
//            ]
//        ),
//        LessonsDay(
//            id: 2,
//            title: "Среда",
//            sections: [
//                LessonsSection(
//                    id: 0,
//                    header: LessonsSectionHeader("1 пара"),
//                    lessons: [
//                        Lesson(id: 0, title: "Базы данных", subtitle: "Аудитория 1818", time: "9:00 – 10:30", professor: "Монахов В.И.", type: "Лекция")
//                    ]
//                ),
////                LessonsSection(
////                    id: 1,
////                    header: LessonsSectionHeader("2 пара"),
////                    lessons: [
////                        Lesson(id: 0, title: "Базы данных", subtitle: "Аудитория 1343", time: "10:40 – 12:10", professor: "Монахов В.И.", type: "Лабораторная")
////                    ]
////                ),
////                LessonsSection(
////                    id: 2,
////                    header: LessonsSectionHeader("3 пара"),
////                    lessons: [
////                        Lesson(id: 0, title: "Теория автоматического управления", subtitle: "Аудитория 1802", time: "12:40 - 14:10", professor: "Годунов М.В.", type: "Лекция")
////                    ]
////                )
//            ]
//        ),
//        LessonsDay(
//            id: 3,
//            title: "Четверг",
//            sections: [
//                LessonsSection(
//                    id: 0,
//                    header: LessonsSectionHeader("1 пара"),
//                    lessons: [
//                        Lesson(id: 0, title: "Информационное моделирование", subtitle: "Аудитория 1125", time: "9:00 – 10:30", professor: "Монахов В.И.", type: "Лекция")
//                    ]
//                ),
//                LessonsSection(
//                    id: 1,
//                    header: LessonsSectionHeader("2 пара"),
//                    lessons: [
//                        Lesson(id: 0, title: "Информационное моделирование", subtitle: "Аудитория 1343", time: "10:40 – 12:10", professor: "Монахов В.И.", type: "Лабораторная")
//                    ]
//                )
//            ]
//        ),
//        LessonsDay(
//            id: 4,
//            title: "Пятница",
//            sections: [
//                LessonsSection(
//                    id: 0,
//                    header: LessonsSectionHeader("1 пара"),
//                    lessons: [
//                        Lesson(id: 0, title: "Элективные дисциплины по физической культуре и спорту", subtitle: "Спортивный зал", time: "9:00 – 10:30", professor: "Преподаватель кафедры", type: "Практика")
//                    ]
//                ),
//                LessonsSection(
//                    id: 1,
//                    header: LessonsSectionHeader("2 пара"),
//                    lessons: [
//                        Lesson(id: 0, title: "ЭВМ и периферийные устройства", subtitle: "Аудитория 1125", time: "10:40 – 12:10", professor: "Беспалов М.Е.", type: "Лекция")
//                    ]
//                ),
//                LessonsSection(
//                    id: 2,
//                    header: LessonsSectionHeader("3 пара"),
//                    lessons: [
//                        Lesson(id: 0, title: "ЭВМ и периферийные устройства", subtitle: "Аудитория 1125", time: "12:40 - 14:10", professor: "Беспалов М.Е.", type: "Лабораторная")
//                    ]
//                )
//            ]
//        )
//    ]
}