//
//  ProfileTileViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ProfileTileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var titleLable: UILabel!

    let layout = UICollectionViewFlowLayout()
    var selectedImage : UIImage? = UIImage(contentsOfFile: "")
    
    var imageArray =  ["https://tineye.com/images/widgets/mona.jpg","https://cdn1.epicgames.com/ue/product/Screenshot/UE4Editor2019-01-1606-56-33-1920x1080-b727b2460d08c22d7d4a6d5b3e8ca4d4.jpg","https://cdn1.epicgames.com/ue/product/Screenshot/UE4Editor2019-01-1606-56-33-1920x1080-b727b2460d08c22d7d4a6d5b3e8ca4d4.jpg","https://tineye.com/images/widgets/mona.jpg","https://tineye.com/images/widgets/mona.jpg","https://tineye.com/images/widgets/mona.jpg","https://tineye.com/images/widgets/mona.jpg","https://tineye.com/images/widgets/mona.jpg","https://cdn1.epicgames.com/ue/product/Screenshot/UE4Editor2019-01-1606-56-33-1920x1080-b727b2460d08c22d7d4a6d5b3e8ca4d4.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(addButtonAction))
        
        // Setup tableview
        setupCollectionView()
    }
    
    
     // MARK:- Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Setup Title
    
    func setTitle(titleStr:String) {
        titleLable.text=titleStr
    }
    
}
