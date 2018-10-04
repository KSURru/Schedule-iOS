//
//  Lesson.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 24.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol LessonProtocol: class {
    
    var id: Int { get }
    var title: String { get }
    var subtitle: String { get }
    var time: String { get }
    var professor: String { get }
    var type: String { get }
    var separator: Bool { get set }
    
    var frame: TimetableLessonTableViewCell? { get set }
    
}

class Lesson: LessonProtocol {
    
    let id: Int
    let title: String
    let subtitle: String
    let time: String
    let professor: String
    let type: String
    var separator: Bool
    
    var frame: TimetableLessonTableViewCell?
    
    init(id: Int, title: String, subtitle: String, time: String, professor: String, type: String) {
        
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.time = time
        self.professor = professor
        self.type = type
        self.separator = true
        
    }
    
    init(id: Int, title: String, subtitle: String, time: String, professor: String, type: String, separator: Bool) {
        
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.time = time
        self.professor = professor
        self.type = type
        self.separator = separator
        
    }
    
    
}

protocol LessonsSectionHeaderProtocol: class {
    
    var title: String { get }
    var separator: Bool { get set }
    
    var frame: UIView? { get set }
    
}

class LessonsSectionHeader: LessonsSectionHeaderProtocol {
    
    let title: String
    var separator: Bool
    
    var frame: UIView?
    
    init(_ title: String) {
        
        self.title = title
        self.separator = true
        
    }
    
    init(_ title: String, separator: Bool) {
        
        self.title = title
        self.separator = separator
        
    }
    
}

protocol LessonsSectionProtocol: class {
    
    var id: Int { get }
    var header: LessonsSectionHeaderProtocol { get }
    var lessons: [LessonProtocol?] { get }
    
}

class LessonsSection: LessonsSectionProtocol {
    
    let id: Int
    let header: LessonsSectionHeaderProtocol
    let lessons: [LessonProtocol?]
    
    init(id: Int, header: LessonsSectionHeaderProtocol, lessons: [LessonProtocol?]) {
        
        self.id = id
        self.header = header
        self.lessons = lessons
        
    }
    
}

protocol LessonsDayProtocol: class {
    
    var id: Int { get }
    var title: String { get }
    var sections: [LessonsSectionProtocol?] { get }
    
    var frame: UIImage? { get set }
    var scrollOffset: CGFloat { get set }
    var scrolledFrame: UIImage? { get set }
    
}

class LessonsDay: LessonsDayProtocol {
    
    let id: Int
    let title: String
    let sections: [LessonsSectionProtocol?]
    
    var frame: UIImage?
    var scrollOffset: CGFloat
    var scrolledFrame: UIImage?
    
    init(id: Int, title: String, sections: [LessonsSectionProtocol?]) {
        
        self.id = id
        self.title = title
        self.sections = sections
        self.scrollOffset = 0
        
    }
    
}

protocol LessonsWeekProtocol: class {
    
    var id: Int { get }
    var even: Bool { get }
    var days: [LessonsDayProtocol?] { get }
    
}

class LessonsWeek: LessonsWeekProtocol {
    
    let id: Int
    let even: Bool
    let days: [LessonsDayProtocol?]
    
    init(id: Int, even: Bool, days: [LessonsDayProtocol?]) {
        
        self.id = id
        self.even = even
        self.days = days
        
    }
    
}

protocol LessonsGroupProtocol: class {
    
    var id: Int { get }
    var title: String { get }
    var weeks: [LessonsWeekProtocol?] { get }
    
}

class LessonsGroup: LessonsGroupProtocol {
    
    let id: Int
    let title: String
    let weeks: [LessonsWeekProtocol?]
    
    init(id: Int, title: String, weeks: [LessonsWeekProtocol?]) {
        
        self.id = id
        self.title = title
        self.weeks = weeks
        
    }
    
}
