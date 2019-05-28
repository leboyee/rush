//
//  Constants.swift
//  PaidMeals
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//
import UIKit

//MARK: enumration
let screenWidth: CGFloat = UIScreen.main.bounds.width
let screenHeight: CGFloat = UIScreen.main.bounds.height

//MARK: - Production Build
var isProductionBuild: Bool = true



//MARK: - App color mode
var isDarkModeOn: Bool = false


//MARK: Reachability
var isNetworkAvailable : Bool = true

struct Cell {

    static let onBoardingCollectionViewCell         = "OnBoardingCollectionViewCell"
    static let event                = "EventCell"
    static let tutorialPopUp        = "TutorialPopUpCell"
    static let eventType            = "EventTypeCell"
    static let eventByDate          = "EventByDateCell"
    static let textIcon             = "TextIconCell"
    static let textView             = "TextViewCell"
}

struct ReusableView {

    static let seeAllFooter   = "SeeAllFooter"
    static let textHeader     = "TextHeader"

}

struct ViewControllerId {
    static let customPickerViewController        = "CustomPickerViewController"
}

/* Create the struct for Section wise */
struct Segues {

    static let selectEventType             = "SelectEventTypeSegue"
    static let createClub                  = "createClubSegue"
    static let enterEmail                  = "EnterEmailViewSegue"
    static let enterPassword                 = "EnterPasswordSegue"


}

struct StoryBoard {
    static let main                      =     "Main"
    static let customPicker              =     "CustomPicker"
    static let tabbar                    =     "Tabbar"
}

public struct Text {
    static let firstOnboardTitle                = "Get Involved"
    static let firstOnboardDescription          = "In Events, Clubs, & Classes"
    static let secondOnboardTitle               = "Connect"
    static let secondOnboardDescription         = "Through Shared Interests"
    static let thirdOnboardTitle                = "Manage & Organize"
    static let thirdOnboardDescription          = "Your Social & Academic Life"
    static let forthOnboardTitle                = "Filter Your Social Media"
    static let forthOnboardDescription          = "To See Content You Want To See"
    static let searchPlaceholder  = "Name, zip, city, state"
    static let emailTitleRegister  = "Enter school email to create account"
    static let emailTitleLogin  = "Enter school email to login"
    static let passwordTitleRegister  = "Protect account with password"
    static let passwordTitleLogin  = "Enter school email to login"
    static let show  = "show"
    static let hide  = "hide"
    static let addInterest              = "Add interests"
    static let addAnotherInterest       = "Add another interest"
    static let invitePeople             = "Invite people"
    static let inviteOtherPeople        = "Invite other people"
    static let nameClub                 = "Name club"
    static let addDesc                  = "Add description"
    static let createGroupChat          = "Create group chat"
}

public struct Message {
    static let tryAgainErrorMessage            = "Try again, please."
    static let phPhotoLibraryAuthorizedMesssage  = "Photo library access is required to add photo."
    static let cameraAuthorizedMesssage = "Camera access is required to capture photo."
}

public struct Icons {
    static let searchWhite    = "search-white"

}

public struct UserDefaultKey {
    static let searchFilter = "searchFilterData"

}

enum EventCategoryType {
    case upcoming
    case clubs
    case clubsJoined
    case classes
    
}

enum EventType {
    case publik
    case closed
    case inviteOnly
}

enum LoginType {
    case Register
    case Login    
}

enum passwordFormate {
    case none
    case correct
    case wrong
}

