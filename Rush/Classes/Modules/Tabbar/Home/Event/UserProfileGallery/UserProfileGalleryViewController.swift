//
//  UserProfileGalleryViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 04/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class UserProfileGalleryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var titleLable: UILabel!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    
    var selectedIndex: Int? = -1
    var currentIndex: Int = 1
    let layout = UICollectionViewFlowLayout()
    var selectedImage: UIImage? = UIImage(contentsOfFile: "")
    var list = [Image]()
    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "whiteMore"), style: .plain, target: self, action: #selector(moreButtonAction))
        
//        navigationItem.titleView = Utils.getNavigationBarTitle(title: titleName, textColor: UIColor.white)

        // Setup tableview
        setupCollectionView()
        fillBottomProfile()
        setTitle(titleStr: "\(currentIndex + 1) of \(list.count)")
        setupDateAndTimeOfPhoto(index: currentIndex)
    }
    
    // MARK: - Set Profile Data
    func fillBottomProfile() {
        userNameLable.text = user.name
        guard let imageStr = user.photo?.thumb else { return } //"https://tineye.com/images/widgets/mona.jpg"
        profilePicImageView.sd_setImage(with: URL(string: imageStr), completed: nil)
    }
    
     // MARK: - Actions
    @objc func moreButtonAction() {
        self.openShareSheet()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreButtonAction(_ sender: Any) {
        openShareSheet()
      }
    
    // MARK: - Setup Title
    func setTitle(titleStr: String) {
        titleLable.text = titleStr
    }
    
    func setupDateAndTimeOfPhoto(index: Int) {
         let image = list[index]
        print(image.date)
        if let date = image.date {
            if date.isSameDate(Date()) {
                timeLable.text = date.toString(format: "hh:mm a")
            } else {
                timeLable.text = date.toString()
            }
        }
    }
    
}
