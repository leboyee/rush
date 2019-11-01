//
//  CreateEventViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos
import IQKeyboardManagerSwift
import UnsplashPhotoPicker
import PanModal

class CreateEventViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var clubHeader: ClubHeader!
    @IBOutlet weak var backgroundView: RBackgoundView!
    @IBOutlet weak var heightConstraintOfHeader: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButtonConstraint: NSLayoutConstraint!

    var imageDataTask: URLSessionDataTask?
    static var cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "unsplash")

    var imageList = [Any]()
//    var imagePicker = UIImagePickerController()
    var picker = ImagePickerController()
    var nameEvent = ""
    var eventDescription = ""
    var address = ""
    var university: University?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var eventImage: UIImage?
    var startDate = Date()
    var endDate = Date()
    var startTime = "01:00 PM"
    var endTime = "02:00 PM"
    var startTimeDate =  Date()//.parse(dateString: "01:00 PM", format: "hh:mm a") ?? Date()
    var endTimeDate =  Date()//.parse(dateString: "02:00 PM", format: "hh:mm a") ?? Date()
    var calendarHeight: CGFloat = 352.0
    var isStartDate: Bool = false
    var isEndDate: Bool = false
    var isStartTime: Bool = false
    var isEndTime: Bool = false
    var isCreateGroupChat = true
    var peopleList = [Invite]()
    var isEditEvent: Bool = false
    var eventId: String = ""
    let headerFullHeight: CGFloat = 367
    let headerSmallWithDateHeight: CGFloat = 182
    let headerSmallWithoutDateHeight: CGFloat = 114
    var event: Event?
    var interestList = [Interest]()
    var countryCode = [[String: Any]]()
    var rsvpArray = [String]()
    var searchTextFiled: UITextField?
    var eventType: EventType = .publik
    
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
                
        // Setup tableview
        setupTableView()
        fillImageHeader()
        loadCountryJson()
        deleteButton.isHidden = true
        self.startTimeDate = Date().setCurrentTimeWithAddingTimeInterval(additionalSeconds: 900)
        self.endTimeDate = Date().setCurrentTimeWithAddingTimeInterval(additionalSeconds: 4500)
        self.startTime = self.startTimeDate.toString(format: "hh:mm a")
        self.endTime = self.endTimeDate.toString(format: "hh:mm a")

        if isEditEvent == true {
            setupEventEdit()
        }
    }
}

// MARK: - Actions
extension CreateEventViewController {
    @IBAction func cancelButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction() {
        if isEditEvent == true {
            updateEventApi(eventId: String(event?.id ?? 0))
        } else {
            createEventAPI()
        }
    }
    
    @IBAction func deleteEventButtonAction() {
        Utils.alert(message: "Are you sure you want to delete this event?", title: nil, buttons: ["Yes"], cancel: "No", type: .actionSheet) { [weak self] (index) in
                  guard let uwself = self else { return }
                  if index == 0 {
                    uwself.deleteEventAPI(id: String(uwself.event?.id ?? 0))
                  }
                  
              }
        
    }
    
    @IBAction func addImageButtonAction() {
        self.performSegue(withIdentifier: Segues.selectEventPhoto, sender: self)
    }
}

// MARK: - Other Function
extension CreateEventViewController {
    func setupEventEdit() {
        nameEvent = event?.title ?? ""
        cancelButton.setImage(#imageLiteral(resourceName: "back-arrow"), for: .normal)
        saveButtonConstraint.constant = 60
        deleteButton.isHidden = false
        cancelButton.setTitle("", for: .normal)
        eventDescription = event?.desc ?? ""
        address = event?.address ?? ""
        if let eventLat = event?.latitude, let lat = Double(eventLat) {
            latitude = lat
        }
        if let eventLong = event?.longitude, let long = Double(eventLong) {
            longitude = long
        }
        
        //eventImage = event?.photo?.main
        startDate = event?.start ?? Date()
        endDate = event?.end ?? Date()
        startTime = "01:00 PM"
         endTime = "02:00 PM"
        startTimeDate =  Date.parse(dateString: "01:00 PM", format: "hh:mm a") ?? Date()
        endTimeDate =  Date.parse(dateString: "02:00 PM", format: "hh:mm a") ?? Date()
        isCreateGroupChat = event?.isChatGroup ?? true
        eventId = String(event?.id ?? 1)
        university = event?.university?[0]
        //self.university = event.un
//        for invites in event?.invitee ?? [Invitee]() {
//            let invite = Invite()
//            invite.profile = invites.user
//        }
        interestList = event?.interests ?? [Interest]()
        for rsvpQuestion in event?.rsvp ?? [RSVPQuestion]() {
            guard let question = rsvpQuestion.que else { return }
            rsvpArray.append(question)
        }
        guard let url = event?.photo?.main else { return }
        clubHeader.setup(url: URL(string: url))
    }
    
}
// MARK: - Mediator
extension CreateEventViewController {
    func selectedCell(_ indexPath: IndexPath) {
        if indexPath.section == 0 && self.isEditEvent == true {
                    guard let eventCategoryFilter = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "EventCateogryFilterViewController") as? EventCateogryFilterViewController & PanModalPresentable else { return }
                    eventCategoryFilter.dataArray = Utils.eventTypeArray()
                    eventCategoryFilter.delegate = self
                    eventCategoryFilter.isEventTypeModel = true
                    eventCategoryFilter.selectedIndex = self.event?.eventType == .publik ? 0 : self.event?.eventType == .closed ? 1 : 2
                    eventCategoryFilter.headerTitle = "Choose event type:"
                    let rowViewController: PanModalPresentable.LayoutType = eventCategoryFilter
                    self.presentPanModal(rowViewController)
        } else if indexPath.section == 0 || indexPath.section == 1 {
            
        } else if indexPath.section == 2 {
               DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.addRSVP, sender: self)
            }
        } else if indexPath.section == 3 {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.addLocation, sender: self)
            }
        } else if indexPath.section == 4 {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.addUniversitySegue, sender: self)
            }
        } else if indexPath.section == 8 {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.createEventInterestSegue, sender: self)
            }
        } else if indexPath.section == 9 {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.createEventInviteSegue, sender: self)
            }
        }
        
    }
    
    func addImageFunction() {
        self.performSegue(withIdentifier: Segues.selectEventPhoto, sender: self)
    }
    
    func updatedEventSuccesssully() {
        navigationController?.viewControllers.forEach({ (vc) in
            if vc.isKind(of: EventDetailViewController.self) {
                (vc as? EventDetailViewController)?.loadAllData()
            }
        })
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Navigation
extension CreateEventViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.selectEventPhoto {
            if let vc = segue.destination as? SelectEventTypeViewController {
                vc.type = .photo
                vc.delegate = self
            }
        } else if segue.identifier == Segues.addRSVP {
            if let vc = segue.destination as? AddRSVPViewController {
                vc.delegate = self
            }
        } else if segue.identifier == Segues.addLocation {
            if let vc = segue.destination as? AddLocationViewController {
                vc.delegate = self
            }
        } else if segue.identifier == Segues.addUniversitySegue {
            if let vc = segue.destination as? ChooseUniversityViewController {
                vc.delegate = self
                vc.addUniversityType = .createEvent
            }
        } else if segue.identifier == Segues.createEventInviteSegue {
            if let vc = segue.destination as? CreateEventInviteViewController {
                vc.delegate = self
            }
        } else if segue.identifier == Segues.createEventInterestSegue {
            if let vc = segue.destination as? CreateEventInterestViewController {
                vc.delegate = self
                vc.selectedArray = interestList
            }
        }
        
    }
}

// MARK: - Imagepicker fuctions
extension CreateEventViewController: ImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: ImagePickerController, didFinishPickingImageAssets assets: [PHAsset]) {
        imageList = assets
        picker.dismiss(animated: false, completion: nil)
        DispatchQueue.main.async {
            self.setEventImage(imageAsset: self.imageList[0])
            self.validateAllFields()
            self.tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Capture Image
    func openCameraOrLibrary(type: UIImagePickerController.SourceType, isFromUnsplash: Bool) {
        DispatchQueue.main.async {
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
                    unself.eventImage = image.squareImage()
                    unself.clubHeader.setup(image: unself.eventImage)
                }
            }
        } else if let image = imageAsset as? UIImage {
            eventImage = image
            clubHeader.setup(image: eventImage)
        }
        validateAllFields()
    }
}
