//
//  SelectGallaryPhotoViewController.swift
//  GotFriends
//
//  Created by iChirag on 16/01/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//

import UIKit
import Photos

@objc protocol SelectGallaryPhotoViewControllerDelegate {
    @objc optional func dismissView(_ album: PHAssetCollection?)
}

class SelectGallaryPhotoViewController: UIViewController {
    
    
    @IBOutlet weak var containerView    : UIView!
    @IBOutlet weak var containerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var hightConstraintOfContainerView: NSLayoutConstraint!
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var tableView: UITableView!
    var delegate: SelectGallaryPhotoViewControllerDelegate?
    
    var selectedIndex = 0
    var selectedAlbum: PHAssetCollection?
    var selectedTitle = ""
    
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    
    internal init(source: [PHFetchResult<PHAssetCollection>], configuration: ImagePickerConfigurable? = nil) {
        self.source = source
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.source = []
        self.configuration = nil
        super.init(coder: aDecoder)
    }
    
    var configuration: ImagePickerConfigurable?
    
    var source: [PHFetchResult<PHAssetCollection>]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.containerViewConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.containerView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    //MARK: - setup
    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        setUpTableView()
                
        // Set dynamic height of screen
        hightConstraintOfContainerView.constant = screenHeight * 0.6
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: containerView)
        
        if panGesture.state == .began {
            originalPosition = containerView.center
            currentPositionTouched = panGesture.location(in: containerView)
        } else if panGesture.state == .changed {
            
            if translation.y > 0 {
                let value = (originalPosition?.x ?? 0) + translation.y + 140
                containerView.frame.origin = CGPoint(
                    x: 0,
                    y: value
                )
            }
        } else if panGesture.state == .ended {
            
            if translation.y >= screenHeight * 0.2 {
                self.dismiss()
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.containerView.center = self.originalPosition!
                })
            }
        }
    }
    
    func dismiss() {
        if selectedAlbum == nil {
            selectedAlbum = source[0][0]
        }
        
        self.delegate?.dismissView?(selectedAlbum)
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
