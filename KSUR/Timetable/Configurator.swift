//
//  TimetableConfigurator.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 22.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol TimetableConfiguratorProtocol: class {
    func configure(with viewController: TimetableViewController)
}

class TimetableConfigurator: TimetableConfiguratorProtocol {
    
    func configure(with viewController: TimetableViewController) {
        let presenter = TimetablePresenter(view: viewController)
        let interactor = TimetableInteractor(presenter: presenter)
        let router = TimetableRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
    
}
