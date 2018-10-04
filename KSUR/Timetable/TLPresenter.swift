//
//  TLPresenter.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 22.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol TimetablePresenterProtocol: class {
    var router: TimetableRouterProtocol! { set get }
    func configureView()
    
    var weekCount: Int { get }
    
    var currentWeekType: WeekType! { set get }
    func setWeekType(_ to: WeekType)
    
    func weekdayFrame(atIndex: Int) -> TimetableWeekdayCollectionViewCell?
    func sizeForWeekdayCell(atIndex: Int) -> CGSize
    func updateActiveWeekdayCell(toIndex: Int)
    
    func lessonsCount(atSection: Int, atDay: Int) -> Int
    func daySectionsCount(atDay: Int) -> Int
    
    func lessonFrame(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell?
    func lessonCell(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell?
    func sizeForLessonCell(atIndex: IndexPath, atDay: Int) -> CGSize
    
    func sectionHeaderFrame(atIndex: Int, atDay: Int) -> UIView?
    func heightForSectionHeader(atIndex: Int, atDay: Int) -> CGFloat
    
    func dayFrame(atIndex: Int) -> UIImage?
    func dayFrame(atIndex: Int, setFrame: UIImage?)
    func dayFrame(atIndex: Int, setScrollOffset: CGFloat, setScrolledFrame: UIImage?)
    
    func dayScrollOffset(atIndex: Int) -> CGFloat?
    
}

class TimetablePresenter: TimetablePresenterProtocol {
    
    weak var view: TimetableViewProtocol!
    var interactor: TimetableInteractorProtocol!
    var router: TimetableRouterProtocol!
    
    var weekCount: Int {
        return interactor.weekCount
    }
    
    var currentWeekType: WeekType! {
        
        set {
            interactor.currentWeekType = newValue
        }
        
        get {
            return interactor.currentWeekType
        }
        
    }
    
    func setWeekType(_ to: WeekType) {
        interactor.setWeekType(to)
    }
    
    func weekdayFrame(atIndex: Int) -> TimetableWeekdayCollectionViewCell? {
        return interactor.weekdayFrame(atIndex: atIndex)
    }

    func sizeForWeekdayCell(atIndex: Int) -> CGSize {
        
        guard let weekdayFrame = weekdayFrame(atIndex: atIndex) else { return CGSize.zero }
        
        return weekdayFrame.frame.size
        
    }
    
    func updateActiveWeekdayCell(toIndex: Int) {
        interactor.updateActiveWeekdayCell(toIndex: toIndex)
    }
    
    func lessonsCount(atSection: Int, atDay: Int) -> Int {
        return interactor.lessonsCount(atSection: atSection, atDay: atDay)
    }
    
    func daySectionsCount(atDay: Int) -> Int {
        return interactor.daySectionsCount(atDay: atDay)
    }
    
    func lessonFrame(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell? {
        return interactor.lessonFrame(atIndex: atIndex, atDay: atDay)
    }
    
    func lessonCell(atIndex: IndexPath, atDay: Int) -> TimetableLessonTableViewCell? {
        return interactor.lessonCell(atIndex: atIndex, atDay: atDay)
    }
    
    func sizeForLessonCell(atIndex: IndexPath, atDay: Int) -> CGSize {
        guard let lessonLayer = lessonFrame(atIndex: atIndex, atDay: atDay) else { return CGSize.zero }
        
        return CGSize(width: UIScreen.main.bounds.width, height: lessonLayer.frame.size.height)
    }
    
    func sectionHeaderFrame(atIndex: Int, atDay: Int) -> UIView? {
        return interactor.sectionHeaderFrame(atIndex: atIndex, atDay: atDay)
    }
    
    func heightForSectionHeader(atIndex: Int, atDay: Int) -> CGFloat {
        guard let sectionHeaderFrame = sectionHeaderFrame(atIndex: atIndex, atDay: atDay) else { return 0 }
        
        return sectionHeaderFrame.frame.size.height
    }
    
    func dayFrame(atIndex: Int) -> UIImage? {
        return interactor.dayFrame(atIndex: atIndex)
    }
    
    func dayFrame(atIndex: Int, setFrame: UIImage?) {
        interactor.dayFrame(atIndex: atIndex, setFrame: setFrame)
    }
    
    func dayFrame(atIndex: Int, setScrollOffset: CGFloat, setScrolledFrame: UIImage?) {
        interactor.dayFrame(atIndex: atIndex, setScrollOffset: setScrollOffset, setScrolledFrame: setScrolledFrame)
    }
    
    func dayScrollOffset(atIndex: Int) -> CGFloat? {
        return interactor.dayScrollOffset(atIndex: atIndex)
    }
    
    required init(view: TimetableViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        interactor.apiService.isEven { (e) in
            
            let weekType = e ? WeekType.even : WeekType.odd
            
            let date = Date()
            
            var calendar = Calendar.current
                calendar.locale = Locale(identifier: "ru_RU")
            
            let weekday = calendar.component(.weekday, from: date)
            
            self.currentWeekType = ( weekday != 1 && weekday != 7 ) ? weekType : !weekType // if not 1 - Sunday and 7 - Saturday
            
            self.setWeekType(self.currentWeekType)
            
            self.view.renderTableViewImages(weekType: weekType, {
                
//                let wd = ( weekday != 1 && weekday != 7 ) ? weekday - 1 : 1
//
//                self.view.changeDay(toIndex: wd, animated: false, prevTransform: CGAffineTransform(), nextTransform: CGAffineTransform())
                
                self.view.createPanGestureRecognizer()
                
            })
            
        }
    }
}
