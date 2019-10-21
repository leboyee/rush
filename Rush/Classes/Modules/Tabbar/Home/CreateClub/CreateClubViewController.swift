//
//  CreateClubViewController.swift
//  Rush
//
//  Created by ideveloper on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos
import IQKeyboardManagerSwift
import UnsplashPhotoPicker
import PanModal

protocol CreateClubProtocol: class {
    func updateClubSuccess()
}

class CreateClubViewController: UIViewController {
    
    
    var imageDataTask: URLSessionDataTask?
    static var cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "unsplash")
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clubHeader: ClubHeader!
    @IBOutlet weak var backgroundView: RBackgoundView!
    @IBOutlet weak var heightConstraintOfHeader: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    //    @IBOutlet weak var containerView: UIView!
    //    @IBOutlet weak var photoSelectionView: UIView!
    //    @IBOutlet weak var heightConstraintOfContainerView: NSLayoutConstraint!
    //    @IBOutlet weak var bottomConstraintOfContainerView: NSLayoutConstraint!
    //    @IBOutlet weak var radiusView: UIView!
    
    var imageList = [Any]()
    //      var imagePicker = UIImagePickerController()
    var picker = ImagePickerController()
    var selectedContactList = [Contact]()
    var nameClub = ""
    var clubDescription = ""
    var clubImage: UIImage?
    var isCreateGroupChat = true
    
    let headerFullHeight: CGFloat = 367
    let headerSmallWithDateHeight: CGFloat = 182
    let headerSmallWithoutDateHeight: CGFloat = 114
    
    var interestList = [Interest]()
    var peopleList = [Invite]()
    var removePeopleIds = [String]()
    var newPeopleIds = [String]()
    var newContacts = [String]()
    var selectedUniversity: University?
    
    var clubInfo: Club?
    
    weak var delegate: CreateClubProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        // set all data for manage(edit) club
        setupData()
        
        // Setup tableview
        setupTableView()
        
        // validate default fields
        validateAllFields()
        
        // Setup header
        fillImageHeader()
    }
    
    func setupData() {
        if let club = clubInfo {
            nameClub = club.clubName ?? ""
            clubDescription = club.clubDesc ?? ""
            isCreateGroupChat = (club.clubIsChatGroup) == 1 ? true : false
            
            if let invitees = club.invitees {
                var peoples = [Invite]()
                for invitee in invitees {
                    let invite = Invite()
                    invite.profile = invitee.user
                    invite.isFriend = true
                    peoples.append(invite)
                }
                peopleList = peoples
            }
            
            if let interests = club.clubInterests {
                interestList = interests
            }
            
            validateAllFields()
        }
    }
}

// MARK: - Actions
extension CreateClubViewController {
    @IBAction func cancelButtonAction() {
        if clubInfo != nil {
            dismiss(animated: false, completion: nil)
        } else {
            navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func saveButtonAction() {
        if saveButton.isEnabled {
            if clubInfo != nil {
                // Update club info
                updateClubAPI()
            } else {
                // Create club info
                createClubAPI()
            }
        }
    }
    
    /*  @IBAction func addImageButtonAction() {
     
     self.performSegue(withIdentifier: Segues.selectEventPhoto, sender: nil)
     /*  Utils.alert(message: nil, title: nil, buttons: ["Take Photo", "Photo Gallery"], cancel: "Cancel", type: .actionSheet) { [weak self] (index) in
     guard let unself = self else { return }
     if index != 2 {
     unself.openCameraOrLibrary(type: index == 0 ? .camera : .photoLibrary)
     }
     } */
     }*/
    
    // MARK: - Capture Image
    func openCameraOrLibrary(type: UIImagePickerController.SourceType, isFromUnsplash: Bool) {
        DispatchQueue.main.async { [weak self] () in
            if type == .photoLibrary {
                Utils.authorizePhoto(completion: { [weak self] (status) in
                    guard let unsafe = self else { return }
                    if status == .alreadyAuthorized || status == .justAuthorized {
                        if isFromUnsplash == true {
                            let configuration = UnsplashPhotoPickerConfiguration(
                                accessKey: "f7e7cafb83c5739502f5d7e3be980bb1271ed748464773180a32a7391d6414a2",
                                secretKey: "cd923567347c3e433dc7173686c1e5a01dfc8de44b4cff4f2519e494fa9c7b35",
                                allowsMultipleSelection: false
                            )
                            let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: configuration)
                            unsplashPhotoPicker.photoPickerDelegate = self
                            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                            (UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]) ).defaultTextAttributes =   [NSAttributedString.Key.foregroundColor: UIColor.white]
                            unsafe.present(unsplashPhotoPicker, animated: true, completion: nil)
                        } else {
                            DispatchQueue.main.async {
                                unsafe.picker = ImagePickerController()
                                unsafe.picker.delegate = self
                                unsafe.picker.isSingleSelection = true
                                unsafe.picker.navigationBar.isTranslucent = false
                                var assets = [PHAsset]()
                                for img in unsafe.imageList {
                                    if let value = img as? PHAsset { assets.append(value) }
                                }
                                unsafe.picker.updateSelectedAssets(with: assets)
                                unsafe.present(unsafe.picker, animated: false, completion: nil)
                            }
                        }
                        
                    } else {
                        if status != .justDenied {
                            Utils.photoLibraryPermissionAlert()
                        }
                    }
                })
            } else {
                let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                guard status == .authorized else {
                    Utils.alertCameraAccessNeeded()
                    return
                }
            }
        }
    }
    
    func setEventImage(imageAsset: Any) {
        if let asset = imageAsset as? PHAsset {
            let imageSize = CGSize(
                width: screenWidth * UIScreen.main.scale,
                height: screenWidth * UIScreen.main.scale
            )
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.resizeMode = .exact
            requestOptions.isNetworkAccessAllowed = true
            
            PHCachingImageManager.default().requestImage(
                for: asset,
                targetSize: imageSize,
                contentMode: .aspectFill,
                options: requestOptions
            ) { [weak self] image, _ in
                guard let unself = self else { return }
                if let image = image {
                    unself.clubImage = image.squareImage()
                    unself.clubHeader.setup(image: unself.clubImage)
                }
            }
        } else if let image = imageAsset as? UIImage {
            clubImage = image
            clubHeader.setup(image: clubImage)
        }
        //validateAllFields()
    }
}

// MARK: - Navigation
extension CreateClubViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.myClub {
            guard let vc = segue.destination as? MyClubViewController else { return }
            vc.clubImage = clubImage
        } else if segue.identifier == Segues.clubDetailSegue {
            guard let vc = segue.destination as? ClubDetailViewController else { return }
            vc.clubInfo = sender as? Club
            vc.isFromCreateClub = true
        } else if segue.identifier == Segues.createEventInterestSegue {
            if let vc = segue.destination as? CreateEventInterestViewController {
                vc.delegate = self
                // *C
                //vc.selectedArray = interestList
            }
        } else if segue.identifier == Segues.createEventInviteSegue {
            if let vc = segue.destination as? CreateEventInviteViewController {
                vc.delegate = self
                vc.selectedInvitee = peopleList
            }
        } else if segue.identifier == Segues.selectEventPhoto {
            if let vc = segue.destination as? SelectEventTypeViewController {
                vc.type = .photo
                vc.delegate = self
            }
        } else if segue.identifier == Segues.addUniversitySegue {
            if let vc = segue.destination as? ChooseUniversityViewController {
                vc.delegate = self
                vc.addUniversityType = .createEvent
            }
        }
    }
}
