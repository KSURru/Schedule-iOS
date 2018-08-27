//
//  DeserializerService.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 07.08.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import Foundation
import SwiftProtobuf

protocol DeserializerServiceProtocol: class {
    
    func deserializeGroup(_ serializedGroup: ProtoGroup) -> LessonsGroupProtocol?
    func deserializeWeek(_ serializedWeek: ProtoWeek) -> LessonsWeekProtocol?
    func deserializeDay(_ serializedDay: ProtoDay) -> LessonsDayProtocol?
    func deserializeSection(_ serializedSection: ProtoSection) -> LessonsSectionProtocol?
    func deserializeHeader(_ serializedHeader: ProtoHeader) -> LessonsSectionHeaderProtocol?
    func deserializeLesson(_ serializedLesson: ProtoLesson) -> LessonProtocol?
    
    
}

class DeserializerService: DeserializerServiceProtocol {
    
    func deserializeGroup(_ serializedGroup: ProtoGroup) -> LessonsGroupProtocol? {
        
        var weeks = [LessonsWeekProtocol]()
        
        serializedGroup.weeks.forEach { (serializedWeek) in
            
            guard let week = deserializeWeek(serializedWeek) else { return }
            
            weeks.append(week)
            
        }
        
        return LessonsGroup(id: Int(serializedGroup.id), title: serializedGroup.title, weeks: weeks)
        
    }
    
    func deserializeWeek(_ serializedWeek: ProtoWeek) -> LessonsWeekProtocol? {
        
        var days = [LessonsDayProtocol]()
        
        serializedWeek.days.forEach { (serializedDay) in
            
            guard let day = deserializeDay(serializedDay) else { return }
            
            days.append(day)
            
        }
        
        return LessonsWeek(id: Int(serializedWeek.id), even: serializedWeek.even, days: days)
        
    }
    
    func deserializeDay(_ serializedDay: ProtoDay) -> LessonsDayProtocol? {
        
        var sections = [LessonsSectionProtocol]()
        
        serializedDay.sections.forEach { (serializedSection) in
            
            guard let section = deserializeSection(serializedSection) else { return }
            
            sections.append(section)
            
        }
        
        return LessonsDay(id: Int(serializedDay.id), title: serializedDay.title, sections: sections)
        
    }
    
    func deserializeSection(_ serializedSection: ProtoSection) -> LessonsSectionProtocol? {
        
        var lessons = [LessonProtocol]()
        
        serializedSection.lessons.forEach { (serializedLesson) in
            
            guard let lesson = deserializeLesson(serializedLesson) else { return }
            
            lessons.append(lesson)
        }
        
        guard let header = deserializeHeader(serializedSection.header) else { return nil }
        
        return LessonsSection(id: Int(serializedSection.id), header: header, lessons: lessons)
    }
    
    func deserializeHeader(_ serializedHeader: ProtoHeader) -> LessonsSectionHeaderProtocol? {
        return LessonsSectionHeader(serializedHeader.title)
    }
    
    func deserializeLesson(_ serializedLesson: ProtoLesson) -> LessonProtocol? {
        return Lesson(id: Int(serializedLesson.id), title: serializedLesson.title, subtitle: serializedLesson.subtitle, time: serializedLesson.time, professor: serializedLesson.professor, type: serializedLesson.type)
    }
    
}
