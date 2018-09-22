//
//  TimetablePresenter.swift
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
    var weekCells: [Int: TimetableDayCollectionViewCell] { get }
    
    func dayCell(atIndex: IndexPath) -> TimetableDayCollectionViewCell?
    func sizeForDayCell(atIndex: IndexPath) -> CGSize
    func updateActiveDayCell(toIndex: Int)
    
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
    
    func setEven(_ to: Bool)
}

class TimetablePresenter: TimetablePresenterProtocol {
    
    weak var view: TimetableViewProtocol!
    var interactor: TimetableInteractorProtocol!
    var router: TimetableRouterProtocol!
    
    var weekCount: Int {
        return weekCells.count
    }
    
    var weekCells: [Int: TimetableDayCollectionViewCell] {
        get {
            return interactor!.weekCells
        }
    }
    
    func dayCell(atIndex: IndexPath) -> TimetableDayCollectionViewCell? {
        guard let dayCell = weekCells[atIndex.item] else {
            return nil
        }
        
        return dayCell
    }

    func sizeForDayCell(atIndex: IndexPath) -> CGSize {
        guard let dayCell = weekCells[atIndex.item] else {
            return CGSize.zero
        }
        
        return dayCell.frame.size
    }
    
    func updateActiveDayCell(toIndex: Int) {
        interactor.updateActiveDayCell(toIndex: toIndex)
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
    
    func setEven(_ to: Bool) {
        interactor.setEven(to)
    }
    
    required init(view: TimetableViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        interactor.apiService.isEven { (e) in
            
            self.view.renderTableViewImages(even: e, {
                // Do smth after rendering
            })
            
        }
        view.reloadWeekCollectionData()
        view.addBorderToWeekCollectionView()
        view.createPanGestureRecognizer()
    }
}
