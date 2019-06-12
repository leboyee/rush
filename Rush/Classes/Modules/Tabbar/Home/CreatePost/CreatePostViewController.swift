//
//  CreatePostViewController.swift
//  Rush
//
//  Created by ideveloper2 on 12/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    var imageList = [UIImage]()
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        setupUI()
    }
    
    
    func setupUI() {
        setupTableView()
        imagePicker.delegate = self
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        /*
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "active-create"), style: .plain, target: self, action: #selector(createButtonAction))
        navigationItem.rightBarButtonItem = rightBarButton
        */
        
        // create the button
        let createImage  = UIImage(named: "active-create")!.withRenderingMode(.alwaysOriginal)
        let createButton = UIButton(frame: CGRect(x: 0, y: 0, width: 78, height: 36))
        createButton.setBackgroundImage(createImage, for: .normal)
//        createButton.addTarget(self, action: #selector(createButtonAction), for:.touchUpInside)
        
        // here where the magic happens, you can shift it where you like
        createButton.transform = CGAffineTransform(translationX: -5, y: 5)
        
        // add the button to a container, otherwise the transform will be ignored
        let createButtonContainer = UIView(frame: createButton.frame)
        createButtonContainer.addSubview(createButton)
        let createButtonItem = UIBarButtonItem(customView: createButtonContainer)
        
        // add button shift to the side
        navigationItem.rightBarButtonItem = createButtonItem
        
    }

}

// MARK:- Actions
extension CreatePostViewController {
    
    @IBAction func takePhotoButtonAction(_ sender: Any) {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title:Message.warning , message:Message.noCamera , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Text.okay, style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func addPhotoButtonAction(_ sender: Any) {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}

 // MARK: - Navigation
extension CreatePostViewController {
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
}
