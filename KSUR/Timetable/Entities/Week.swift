//
//  Week.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 24/09/2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import Foundation

enum WeekType {
    
    case none, even, odd
    
    var bool: Bool {
        
        get {
            
            if self == .none { return false }
            else { return self == .even ? true : false }
            
        }
        
    }
    
}

enum WeekPeriod {
    
    case none, current, next
    
}

prefix func !(left: WeekType) -> WeekType {
    
    switch left {
    case .none:
        return .none
    case .even:
        return .odd
    case .odd:
        return .even
    }
    
}

prefix func !(left: WeekPeriod) -> WeekPeriod {
    
    switch left {
    case .none:
        return .none
    case .current:
        return .next
    case .next:
        return .current
    }
    
}

func &&(left: WeekType, right: WeekType) -> WeekPeriod {
    
    if left == .none || right == .none { return .none }
        
    else if left == right { return .current }
        
    else if left == !right { return .next }
        
    else { return .none }
    
}
