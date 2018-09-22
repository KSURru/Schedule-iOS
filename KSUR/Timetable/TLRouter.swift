//
//  TLRouter.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 22.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol TimetableRouterProtocol: class {
    func closeCurrentViewController()
}

class TimetableRouter: TimetableRouterProtocol {
    
    weak var viewController: TimetableViewController!
    
    init(viewController: TimetableViewController) {
        self.viewController = viewController
    }
    
    func closeCurrentViewController() {
        viewController.dismiss(animated: true, completion: nil)
    }
}
