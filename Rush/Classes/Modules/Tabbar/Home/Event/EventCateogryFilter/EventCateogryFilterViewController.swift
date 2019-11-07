//
//  EventCateogryFilterViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 28/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import PanModal

protocol EventCategoryFilterDelegate: class {
    func selectedIndex(_ type: String, _ selectedIndex: IndexPath)
}

class EventCateogryFilterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: EventCategoryFilterDelegate?

    var isShortFormEnabled = false
    var dataArray = [String]()
    var detailArray = [String]()
    var selectedIndex: Int = 0
    var headerTitle: String = "Sort by:"
    var isEventTypeModel = false
    var isEventType: EventType = .publik
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        panModalSetNeedsLayoutUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isEventTypeModel == true {
            delegate?.selectedIndex("\(selectedIndex)", IndexPath(row: selectedIndex, section: 0))
            dismiss(animated: true, completion: nil)
        } else {
            if dataArray.count > selectedIndex {
                let name = dataArray[selectedIndex]
                           delegate?.selectedIndex(name, IndexPath(row: selectedIndex, section: 0))
                           dismiss(animated: true, completion: nil)
            }
           
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //panModalSetNeedsLayoutUpdate()
    }

    func setup() {
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
    }
    
    @IBAction func handleTapGesture(gesture: UITapGestureRecognizer) {
       
        panModalWillDismiss()
    }
    
}

// MARK: - Pan Model
extension EventCateogryFilterViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return tableView
    }
    
      var longFormHeight: PanModalHeight {
        if isEventTypeModel == true {
            return .contentHeight(CGFloat((self.dataArray.count * 123) + 50))
        } else {
            return .contentHeight(CGFloat((self.dataArray.count * 64) + 50))
        }
    }

    var backgroundAlpha: CGFloat {
        return 0.5
    }
    
    var shouldRoundTopCorners: Bool {
        return true
    }
    
    var showDragIndicator: Bool {
        return true
    }
    
    var cornerRadius: CGFloat {
           return 24.0
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
    
    var isUserInteractionEnabled: Bool {
        return true
    }
    
    var scrollIndicatorInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
    }

    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let location = panModalGestureRecognizer.location(in: view)
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.eventCategoryFilterHeader) as? EventCategoryFilterHeader else { return false }

        return headerView.frame.contains(location)
    }

    func willTransition(to state: PanModalPresentationController.PresentationState) {
        panModalSetNeedsLayoutUpdate()
    }
}
