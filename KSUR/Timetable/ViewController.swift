//
//  TimetableViewController.swift
//  KSUR
//
//  Created by Nikita Arutyunov on 22.07.2018.
//  Copyright © 2018 Nikita Arutyunov. All rights reserved.
//

import UIKit

protocol TimetableViewProtocol: class {
    func reloadWeekCollectionData()
    func reloadDayTableData(animated: Bool)
    func addBorderToWeekCollectionView()
    func changeDay(toIndex: Int, translation: CGFloat)
    func leftSwipe(_ translation: CGFloat)
    func rightSwipe(_ translation: CGFloat)
    func createPanGestureRecognizer()
    func renderWeekImages(even: Bool, completion: @escaping (() -> Void))
    func renderTableViewImages()
}

class TimetableViewController: UIViewController {
    
    @IBOutlet weak var dayTableView: UITableView!
    @IBOutlet weak var weekCollectionView: UICollectionView!
    @IBOutlet weak var renderedPrevImageView: UIImageView!
    @IBOutlet weak var renderedNextImageView: UIImageView!
    @IBOutlet weak var prevView: UIView!
    @IBOutlet weak var nextView: UIView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    @IBOutlet weak var evenSegmented: UISegmentedControl!
    
    var presenter: TimetablePresenterProtocol!
    let configurator: TimetableConfiguratorProtocol = TimetableConfigurator()
    
    var selectedDay = 0
    var isPanX = false
    let maxX = UIScreen.main.bounds.size.width
    var direction = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        presenter.configureView()
        
        view.backgroundColor = UIColor(white: 0.05, alpha: 1)
        
        weekCollectionView.delegate = self
        weekCollectionView.dataSource = self
        weekCollectionView.register(TimetableDayCollectionViewCell.self, forCellWithReuseIdentifier: "dayCell")
        weekCollectionView.backgroundColor = UIColor(white: 0.05, alpha: 1)
        
        renderedPrevImageView.backgroundColor = UIColor(white: 0.05, alpha: 1)
        renderedNextImageView.backgroundColor = UIColor(white: 0.05, alpha: 1)
        
        dayTableView.delegate = self
        dayTableView.dataSource = self
//        dayTableView.register(TimetableLessonTableViewCell.self, forCellReuseIdentifier: "dayCell")
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        dayTableView.tableHeaderView = UIView(frame: frame)
        dayTableView.backgroundColor = UIColor(white: 0.05, alpha: 1)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    
    @IBAction func evenSegmentedValueChanged(_ sender: Any) {
        
        let isEven = evenSegmented.selectedSegmentIndex == 1
        
        presenter.setEven(isEven)
        
        UIView.animate(
            withDuration: 0.45,
            delay: 0,
            usingSpringWithDamping: 0.45,
            initialSpringVelocity: 0.45,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: { self.evenSegmented.tintColor = isEven ? UIColor(red: 0, green: 0.869, blue: 0.717, alpha: 1) : UIColor(white: 1, alpha: 1) },
            completion: nil
        )
        
        reloadDayTableData(animated: true)
        
    }
    
}

extension TimetableViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
