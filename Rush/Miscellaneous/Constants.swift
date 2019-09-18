//
//  Constants.swift
//  PaidMeals
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//
import UIKit

// MARK: - enumration
let screenWidth: CGFloat = UIScreen.main.bounds.width
let screenHeight: CGFloat = UIScreen.main.bounds.height

let instagramAuthUrl = "https://api.instagram.com/oauth/authorize/"

// MARK: - Production Build
var isProductionBuild: Bool = true

// MARK: - App color mode
var isDarkModeOn: Bool = false

// MARK: -
let topViewRadius: CGFloat = 32.0

// MARK: - Reachability
var isNetworkAvailable: Bool = true

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
    static let postCommentCell      = "PostCommentCell"
    static let classesCell          = "ClassesCell"
    static let singleButtonCell     = "SingleButtonCell"
    static let searchClubCell       = "SearchClubCell"
    static let timeSlot             = "TimeSlotCell"
    static let chooseTagCell        = "ChooseTagCell"
    static let exploreCell          = "ExploreCell"
    static let inputCell            = "InputCell"
    static let userInfoCell         = "UserInfoCell"
    static let peopleCell           = "PeopleCell"
    static let sortingCell          = "SortingCell"
    static let chatListCell         = "ChatListCell"
    static let chatUserCell         = "ChatUserCell"
    static let calendarEvent        = "CalendarEventCell"
    static let settingsInfo         = "SettingsInfoCell"
    static let switchCell           = "SwitchCell"
    static let instagram            = "InstagramCell"
    static let checkMark            = "CheckMarkCell"
    static let notification         = "NotificationCell"
    static let text                 = "TextCell"
    static let eventAbout           = "EventAboutCell"
    static let location             = "LocationCell"
    static let createPost           = "CreatePostCell"

    static let dateAndTimeEvent     = "DateAndTimeCell"
    static let rsvpCell              = "RSVPCell"

    static let organizer            = "OrganizerCell"
    static let postLike            = "PostLikeCell"
    static let postUser            = "PostUserCell"
    static let postText            = "PostTextCell"
    static let postImages          = "PostImagesCell"
    static let postImage           = "PostImageCell"

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
    static let datePickerViewController          = "DatePickerViewController"
    static let otherUserProfileController        = "OtherUserProfileController"
    static let chatRoomViewController            = "ChatRoomViewController"
}

/* Create the struct for Section wise */
struct Segues {

    static let selectEventType                    = "SelectEventTypeSegue"
    static let createClub                         = "createClubSegue"
    static let enterEmail                         = "EnterEmailViewSegue"
    static let enterPassword                      = "EnterPasswordSegue"
    static let enterPhoneNo                       = "EnterPhoneSegue"
    static let enterPhoneVerification             = "EnterVerificationSegue"
    static let myClub                             = "MyClubSegue"
    static let otherUserProfile                   = "OtherUserProfileSegue"
    static let notificationAlert                  = "NotificationAlertSegue"
    static let friendList                         = "FriendListSegue"
    static let enterUserNameSegue                 = "EnterUserNameSegue"
    static let addProfilePictureSegue             = "AddProfilePictureSegue"
    static let openPostScreen                     = "SegueOpenPostScreen"
    static let createPost                         = "CreatePostSegue"
    static let profileInformation                 = "ProfileInformationSegue"
    static let chooseLevelSegue                   = "ChooseLevelSegue"
    static let chooseYearSegue                    = "ChooseYearSegue"
    static let chooseUniverSitySegueFromLevelView = "ChooseUniverSitySegueFromLevelView"

    static let chooseUniversitySegue              = "ChooseUniversitySegue"
    static let addMajorViewSegue                  = "AddMajorViewSegue"
    static let addMinorViewSegue                  = "AddMinorViewSegue"
    static let chooseClassesViewSegue             = "ChooseClassesViewSegue"
    static let postSegue                          = "PostSegue"
    static let sharePostSegue                     = "sharePostSegue"
    static let clubListSegue                      = "ClubListSegue"
    static let clubDetailSegue                    = "ClubDetailSegue"
    static let searchClubSegue                    = "SearchClubSegue"
    static let classDetailSegue                   = "ClassDetailSegue"
    static let chooseInterestViewSegue            = "ChooseInterestViewSegue"
    static let userInfoViewSegue                  = "UserInfoViewSegue"
    static let eventCategorySegue                 = "EventCategorySegue"
    static let loginPhoneNoSegue                  = "LoginPhoneNoSegue"
    static let universitySegue                    = "UniversitySegue"
    static let searchChatSegue                    = "SearchChatSegue"
    static let contactListSegue                   = "ContactListSegue"
    static let addInviteViewSegue                 = "AddInviteViewSegue"
    static let calendarHome                       = "CalendarHomeSegue"
    static let webViewFile                        = "WebViewFileSegue"
    static let privacySettings                    = "PrivacySettingsSegue"
    static let notificationSettings               = "NotificationSettingsSegue"
    static let inviteContactSegue                 = "InviteContactSegue"
    static let addInstagramPhotoViewSegue         = "AddInstagramPhotoViewSegue"
    static let disconnectInstagram                = "DisconnectInstagramSegue"
    static let settingsInstagramConnect           = "SettingsInstagramConnectSegue"
    static let logoutPopup                        = "LogoutPopupSegue"

    static let profileFriendProfile               = "ProfileFriendProfileSegue"
    static let chatContactListSegue               = "ChatContactListSegue"
    static let homeEventDetail                    = "HomeEventDetailSegue"
    static let rsvpJoinEvent                      = "RSVPJoinEventSegue"
    static let createEvent                         = "CreateEventSegue"
    static let selectEventPhoto                    = "SelectEventTypeViewSegue"
    static let addRSVP                             = "AddRSVPSegue"
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
    static let passwordTitleLogin  = "What is your password?"
    static let phoneNoTitleRegister  = "Add phone number to increase security"
    static let phoneNoTitleLogin  = "Enter your phone number"
    static let userNameTitleRegister  = "Profile setup"
    static let show  = "show"
    static let hide  = "hide"
    static let next  = "Next"
    static let login = "Login"
    static let logout = "Logout"
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
    static let deleteClass              = "Delete class"
    static let deletePost               = "Delete post"
    static let deleteClub               = "Delete club"
    static let report                   = "Report"
    static let settings                 = "Settings"

    static let personal                 = "Personal"
    static let general                  = "General"
    static let privacy                  = "Privacy"

    static let email                     = "Email"
    static let password                  = "Password"
    static let notifications             = "Notifications"
    static let darkMode                  = "Dark mode"
    static let whoCanInviteMe            = "Who can invite me"
    static let whoCanMessageMe           = "Who can message me"
    static let dataPolicy                = "Data policy"
    static let termsConditions           = "Terms & conditions"
    static let invitesFrom               = "Invites from"
    static let messagesFrom              = "Messages from"
    static let recieveNotifications      = "Recieve notifications"
    static let inviteFromContact         = "Invite from contacts"
    static let interests                 = "Interests"
    static let nameEvent                 = "Name event"
    static let addRSVP                   = "Add RSVP"
    static let addAnotherRSVP            = "Add another RSVP"
    static let addLocation               = "Add location"
    static let joinAndRSVP               = "Join and RSVP"
    static let going                     = "Going"
}

public struct Message {
    static let tryAgainErrorMessage            = "Try again, please."
    static let phPhotoLibraryAuthorizedMesssage  = "Photo library access is required to add photo."
    static let cameraAuthorizedMesssage = "Camera access is required to capture photo."
    static let joinEventsAndClassses = "Join events and classes to see your schedule in Calendar."
    static let noCamera = "You don't have camera"
    static let warning = "Warning"
    static let skipSavedImageMessage =
    "You skipped previous step. Don’t worry, \nyour image was saved!"
    static let emailAlreadyInUse = "This email address is already in use."
    static let emailNotAvailable = "Please enter correct email."
    
    static let instagramTitle = "Instagram connected"
    static let instagramMessage =
    "Your photos will be automatically uploaded to Rush. It might take a few minutes."
}

public struct Icons {
    static let searchWhite    = "search-white"

}

public struct UserDefaultKey {
    static let searchFilter = "searchFilterData"
    static let showAlertOfChatRemoved = "showAlertOfChatRemoved"

}

enum EventCategoryType {
    case none
    case upcoming
    case clubs
    case clubsJoined
    case classes
    
}

enum EventType: String, Codable {
    case none = "none"
    case publik = "public"
    case closed = "closed"
    case inviteOnly = "invite_only"
}

enum LoginType {
    case register
    case login
}

enum PhotoFrom {
    case cameraRoll
    case unSplash
}


enum PasswordFormate {
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
