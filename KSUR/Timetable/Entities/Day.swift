//
//  Day.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 24.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol DayProtocol {
    var title: String { get }
    var date: String { get }
}

class Day: DayProtocol {
    
    let title: String
    let date: String
    
    init(_ title: String, date: String) {
        self.title = title
        self.date = date
    }
    
}
