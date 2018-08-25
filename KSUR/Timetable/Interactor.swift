//
//  TimetableInteractor.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 22.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol TimetableInteractorProtocol: class {
    
    var weekCells: [Int: TimetableDayCollectionViewCell] { get }
    func updateActiveDayCell(toIndex: Int)
    
    func lessonFrame(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell?
    func lessonCell(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell?
    
    func lessonsCount(atSection: Int, atDay: Int) -> Int
    func daySectionsCount(atDay: Int) -> Int
    
    func sectionHeaderFrame(atIndex: Int, atDay: Int) -> UIView?
    
    func dayFrame(atIndex: Int) -> UIImage?
    func dayFrame(atIndex: Int, setFrame: UIImage?)
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
    
    var weekCells: [Int: TimetableDayCollectionViewCell] {
        get {
            return weekConstructorService.weekCells
        }
    }
    
    func updateActiveDayCell(toIndex: Int) {
        weekConstructorService.updateActiveCell(toIndex: toIndex)
    }
    
    func lessonFrame(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell? {
        return dayConstructorService.lessonFrame(atIndex: atIndex, atDay: atDay)
    }
    
    func lessonCell(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell? {
        return dayConstructorService.lessonCell(atIndex: atIndex, atDay: atDay)
    }
    
    func lessonsCount(atSection: Int, atDay: Int) -> Int {
        return dayConstructorService.lessonsCount(atSection: atSection, atDay: atDay)
    }
    
    func daySectionsCount(atDay: Int) -> Int {
        return dayConstructorService.daySectionsCount(atDay: atDay)
    }
    
    func sectionHeaderFrame(atIndex: Int, atDay: Int) -> UIView? {
        return dayConstructorService.sectionHeaderFrame(atIndex: atIndex, atDay: atDay)
    }
    
    func dayFrame(atIndex: Int) -> UIImage? {
        return dayConstructorService.dayFrame(atIndex: atIndex)
    }
    
    func dayFrame(atIndex: Int, setFrame: UIImage?) {
        dayConstructorService.dayFrame(atIndex: atIndex, setFrame: setFrame)
    }
    
}
