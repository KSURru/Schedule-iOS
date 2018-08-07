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
    
    func deserializeWeek(_ serializedWeek: Week) -> [LessonsDayProtocol?]?
    
}

class DeserializerService: DeserializerServiceProtocol {
    
    func deserializeWeek(_ serializedWeek: Week) -> [LessonsDayProtocol?]? {
        
        var days = [LessonsDayProtocol]()
        
        serializedWeek.days.forEach { (serializedDay) in
            
            var sections = [LessonsSectionProtocol]()
            
            serializedDay.sections.forEach({ (serializedSection) in
                
                var lessons = [LessonProtocol]()
                
                serializedSection.lessons.forEach({ (serializedLesson) in
                    
                    lessons.append(Lesson(id: Int(serializedLesson.id), title: serializedLesson.title, subtitle: serializedLesson.subtitle, time: serializedLesson.time, professor: serializedLesson.professor, type: serializedLesson.type))
                    
                })
                
                let header = LessonsSectionHeader(serializedSection.header.title)
                
                sections.append(LessonsSection(id: Int(serializedSection.id), header: header, lessons: lessons))
                
            })
            
            days.append(LessonsDay(id: Int(serializedDay.id), title: serializedDay.title, sections: sections))
            
        }
        
        return days
        
    }
    
}
