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
    static let clubName             = "ClubNameCell"
    static let clubManage           = "ClubManageCell"
    static let createUserPost       = "CreateUserPostCell"
    static let tag                  = "TagCell"
    static let user                 = "UserCell"
    static let profileImage         = "ProfileImageCell"
    static let profileInformation   = "ProfileInformationCell"
    static let friendList           = "FriendListCell"
    static let friendClub           = "FriendClubCell"
    static let userName             = "UserNameTableViewCell"
    static let userPostText         = "UserPostTextTableViewCell"
    static let userPostImage        = "UserPostImageTableViewCell"
    static let listCell             = "ListCell"
    static let selectGallaryPhoto   = "SelectGallaryPhotoCell"
    static let universityCell       = "UniversityCell"
    static let addMajorsCell        = "AddMajorsCell"
    static let postLikeCell         = "PostLikeCell"
    static let postCommentCell      = "PostCommentCell"
    static let classesCell          = "ClassesCell"
    static let singleButtonCell     = "SingleButtonCell"
    static let searchClubCell       = "SearchClubCell"
    static let timeSlot             = "TimeSlotCell"
    static let chooseTagCell        = "ChooseTagCell"
    static let exploreCell          = "ExploreCell"
    static let peopleCell           = "PeopleCell"
}

struct ReusableView {

    static let seeAllFooter   = "SeeAllFooter"
    static let textHeader     = "TextHeader"
    static let userImagesHeader = "UserImagesHeaderView"
    static let classesHeader = "ClassesHeader"

    
}

struct ViewControllerId {
    static let customPickerViewController        = "CustomPickerViewController"
    static let createPostViewController          = "CreatePostViewController"
    static let searchClubViewController          = "SearchClubViewController"
}

/* Create the struct for Section wise */
struct Segues {

    static let selectEventType             = "SelectEventTypeSegue"
    static let createClub                  = "createClubSegue"
    static let enterEmail                  = "EnterEmailViewSegue"
    static let enterPassword               = "EnterPasswordSegue"
    static let enterPhoneNo                = "EnterPhoneSegue"
    static let enterPhoneVerification      = "EnterVerificationSegue"
    static let myClub                      = "MyClubSegue"
    static let otherUserProfile            = "OtherUserProfileSegue"
    static let notificationAlert           = "NotificationAlertSegue"
    static let friendList                  = "FriendListSegue"
    static let enterUserNameSegue          = "EnterUserNameSegue"
    static let addProfilePictureSegue      = "AddProfilePictureSegue"
    static let openPostScreen              = "SegueOpenPostScreen"
    static let profileInformation          = "ProfileInformationSegue"
    static let chooseLevelSegue            = "ChooseLevelSegue"
    static let chooseYearSegue             = "ChooseYearSegue"
    static let chooseUniverSitySegueFromLevelView             = "ChooseUniverSitySegueFromLevelView"

    static let chooseUniversitySegue       = "ChooseUniversitySegue"
    static let addMajorViewSegue           = "AddMajorViewSegue"
    static let addMinorViewSegue           = "AddMinorViewSegue"
    static let chooseClassesViewSegue           = "ChooseClassesViewSegue"
    static let postSegue                   = "PostSegue"
    static let sharePostSegue              = "sharePostSegue"
    static let clubListSegue               = "ClubListSegue"
    static let clubDetailSegue             = "ClubDetailSegue"
    static let searchClubSegue             = "SearchClubSegue"
    static let classDetailSegue            = "ClassDetailSegue"
    static let chooseInterestViewSegue             = "ChooseInterestViewSegue"

    
}

struct StoryBoard {
    static let main                      =     "Main"
    static let customPicker              =     "CustomPicker"
    static let tabbar                    =     "Tabbar"
    static let home                      =     "Home"
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
    static let phoneNoTitleRegister  = "Add phone number to increase security"
    static let phoneNoTitleLogin  = "Enter your phone number"
    static let userNameTitleRegister  = "Profile setup"

    
    static let show  = "show"
    static let hide  = "hide"
    static let next  = "Next"
    static let login = "Login"
    static let receiveCodeButtonTitle = "Receive confirmation code"
    static let createAccount = "Create account"
    static let changeImage = "Change image"
    static let okay = "OK"

    

    

    static let addInterest              = "Add interests"
    static let addAnotherInterest       = "Add another interest"
    static let invitePeople             = "Invite people"
    static let inviteOtherPeople        = "Invite other people"
    static let nameClub                 = "Name club"
    static let addDesc                  = "Add description"
    static let createGroupChat          = "Create group chat"
    static let joined                   = "Joined"
    static let interestTag              = "Interest tags"
    static let posts                    = "Posts"
    static let images                   = "Images"
    static let friends                  = "Friends"
    static let events                   = "Events"
    static let clubs                    = "Clubs"
    static let classes                  = "Classes"
    static let manage                   = "Manage"
    static let groupChat                = "Group chat"
    static let messages                 = "Messages"
    static let friend                   = "Friend"
    static let viewAll                  = "View all"
    static let accept                   = "Accept "
    static let reject                   = "Reject "
    static let requested                = "Requested"
    static let dateOfBirth              = "Date of birth"
    static let relationship             = "Relationship"
    static let university               = "University"
    static let level                    = "Level"
    static let year                     = "Year"
    static let UpcomingEvents           = "Upcoming events"
    static let createEventAndOpenClub   = "Create events and open clubs"
    static let saysomething             = "Say something"
    static let comments                 = "Comments"
    static let myClubs                  = "My clubs"
    static let organizer                = "Organizer"
    static let popularPost              = "Popular posts"
    static let readLess                 = "Read less..."
    static let readMore                 = "Read more..."
    static let exploreTopics            = "Explore topics:"
    static let searchClubs              = "Search clubs"
    static let searchClasses            = "Search classes"
    static let myClasses                = "My classes"
    static let rosters                  = "Rosters"
    static let exploreIn                = "Explore in"
    static let todayEvent               = "Today's events"
    static let clubsMightLike           = "Clubs you might like"
    static let classesYouMightLike      = "Classes you might like"
}

public struct Message {
    static let tryAgainErrorMessage            = "Try again, please."
    static let phPhotoLibraryAuthorizedMesssage  = "Photo library access is required to add photo."
    static let cameraAuthorizedMesssage = "Camera access is required to capture photo."
    static let joinEventsAndClassses = "Join events and classes to see your schedule in Calendar."
    static let noCamera = "You don't have camera"
    static let warning = "Warning"
    static let skipSavedImageMessage = "You skipped previous step. Don’t worry, \nyour image was saved!"

}

public struct Icons {
    static let searchWhite    = "search-white"

}

public struct UserDefaultKey {
    static let searchFilter = "searchFilterData"

}

enum EventCategoryType {
    case none
    case upcoming
    case clubs
    case clubsJoined
    case classes
    
}

enum EventType {
    case none
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

enum ExploreSearchType {
    case none
    case event
    case club
    case classes
    case people
}

