//
//  Weekay.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 24.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol WeekdayProtocol {
    
    var title: String { get }
    var date: String { get }
    
    var frame: TimetableWeekdayCollectionViewCell? { get set }
    
}

class Weekday: WeekdayProtocol {
    
    let title: String
    let date: String
    
    var frame: TimetableWeekdayCollectionViewCell?
    
    init(_ title: String, date: String) {
        
        self.title = title
        self.date = date
        
    }
    
}
