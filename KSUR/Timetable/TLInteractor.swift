//
//  TLInteractor.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 22.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol TimetableInteractorProtocol: class {
    
    var apiService: APIServiceProtocol { get }
    
    var currentWeekType: WeekType { set get }
    var weekType: WeekType { set get }
    
    var weekCount: Int { get }
    
    func weekdayFrame(atIndex: Int) -> TimetableWeekdayCollectionViewCell?
    func updateActiveWeekdayCell(toIndex: Int)
    
    func lessonFrame(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell?
    func lessonCell(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell?
    
    func lessonsCount(atSection: Int, atDay: Int) -> Int
    func daySectionsCount(atDay: Int) -> Int
    
    func sectionHeaderFrame(atIndex: Int, atDay: Int) -> UIView?
    
    func dayFrame(atIndex: Int) -> UIImage?
    func dayFrame(atIndex: Int, setFrame: UIImage?)
    func dayFrame(atIndex: Int, setScrollOffset: CGFloat, setScrolledFrame: UIImage?)
    
    func dayScrollOffset(atIndex: Int) -> CGFloat?
    
    func setWeekType(_ to: WeekType)
}

class TimetableInteractor: TimetableInteractorProtocol {
    
    weak var presenter: TimetablePresenterProtocol!
    
    let deserializerService: DeserializerServiceProtocol
    let apiService: APIServiceProtocol
    let weekConstructorService: WeekConstructorServiceProtocol
    let dayConstructorService: DayConstructorServiceProtocol
    
    required init(presenter: TimetablePresenterProtocol) {
        self.presenter = presenter
        
        deserializerService = DeserializerService()
        apiService = APIService(host: "34.218.231.22", port: 8081, version: 1, deserializer: deserializerService)
//        apiService = APIService(host: "0.0.0.0", port: 8081, version: 1, deserializer: deserializerService) // local
        weekConstructorService = WeekConstructorService()
        dayConstructorService = DayConstructorService(api: apiService)
        
    }
    
    func weekdayFrame(atIndex: Int) -> TimetableWeekdayCollectionViewCell? {
        return weekConstructorService.weekdayFrame(atIndex: atIndex, weekPeriod: (weekType && currentWeekType))
    }
    
    func updateActiveWeekdayCell(toIndex: Int) {
        weekConstructorService.updateActiveCell(toIndex: toIndex, weekPeriod: (weekType && currentWeekType))
    }
    
    var currentWeekType: WeekType = .none
    var weekType: WeekType = .none
    
    var weekCount: Int {
        return weekConstructorService.weekCount(weekPeriod: (weekType && currentWeekType))
    }
    
    func lessonFrame(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell? {
        return dayConstructorService.lessonFrame(atIndex: atIndex, atDay: atDay, weekType: weekType)
    }
    
    func lessonCell(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell? {
        return dayConstructorService.lessonCell(atIndex: atIndex, atDay: atDay, weekType: weekType)
    }
    
    func lessonsCount(atSection: Int, atDay: Int) -> Int {
        return dayConstructorService.lessonsCount(atSection: atSection, atDay: atDay, weekType: weekType)
    }
    
    func daySectionsCount(atDay: Int) -> Int {
        return dayConstructorService.daySectionsCount(atDay: atDay, weekType: weekType)
    }
    
    func sectionHeaderFrame(atIndex: Int, atDay: Int) -> UIView? {
        return dayConstructorService.sectionHeaderFrame(atIndex: atIndex, atDay: atDay, weekType: weekType)
    }
    
    func dayFrame(atIndex: Int) -> UIImage? {
        return dayConstructorService.dayFrame(atIndex: atIndex, weekType: weekType)
    }
    
    func dayFrame(atIndex: Int, setFrame: UIImage?) {
        dayConstructorService.dayFrame(atIndex: atIndex, setFrame: setFrame, weekType: weekType)
    }
    
    func dayFrame(atIndex: Int, setScrollOffset: CGFloat, setScrolledFrame: UIImage?) {
        dayConstructorService.dayFrame(atIndex: atIndex, setScrollOffset: setScrollOffset, setScrolledFrame: setScrolledFrame, weekType: weekType)
    }
    
    func dayScrollOffset(atIndex: Int) -> CGFloat? {
        return dayConstructorService.dayScrollOffset(atIndex: atIndex, weekType: weekType)
    }
    
    func setWeekType(_ to: WeekType) {
        
        self.weekType = to
        
    }
    
}
