//
//  Keys.swift
//  Rush
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//
import UIKit

// MARK: - Authorization
let kUserInfo  = "userInfo"
let kSessionId = "sessionIdKey"
let kDeviceId  = "deviceIdKey"
let kPushToken = "pushToken"
let kTimezoneOffset = "timezoneOffset"
let kPushTokenUpdateOnServer = "pushTokenUpdateOnServer"

// MARK: - Network manager
let kSavedProfile               = "kSavedProfile"
let kSavedSession               = "kSavedSession"
let kSavedIsNewUser             = "kSavedNewUser"
let kAppOpenFirstTime           = "kAppOpenFirstTime"

// MARK: - User Default
let kLastLocation               = "com.rush.lastlocation"
let kDeviceTokenPushKey         = "com.rush.devicetokenpush"
let kDeviceTokenPushDataKey     = "com.rush.devicetokenpushdata"
let kUpdateUnreadcount          = "com.rush.updateunreadcount"
let kHomeTutorialKey            = "com.rush.hometutorial"

// MARK: - API's Keys
struct Keys {

    static let data                  = "data"
    static let user                  = "user"
    static let session               = "session"
    static let userId                = "user_id"
    static let profileUserId         = "profileUserId"

    static let photo                 = "photo"
    static let main                  = "main"
    static let thumb                 = "thumb"
    static let medium                = "medium"
    static let large                 = "large"
    static let url                   = "url"
    static let list                  = "list"
    static let kclass                = "class"
    
    static let matchId            = "match_id"
    static let classId            = "class_id"
    static let groupId            = "group_id"
    static let matchStatus        = "match_status"
    static let friendUserId       = "frd_user_id"
    static let friendOtherUserId  = "frd_other_user_id"
    static let friendStatus       = "frd_status"
    static let friendType         = "frd_type"
    static let friend             = "friend"
    static let friendId           = "frd_id"
    static let uIsNotifyOn        = "u_is_notify_on"
    static let uIsEventNotify     = "u_is_event_notify"
    static let uIsClubNotify      = "u_is_club_notify"
    static let uIsClassNotify     = "u_is_class_notify"
    static let uWhoCanMessage     = "u_who_can_message"
    static let uWhoCanInvite      = "u_who_can_invite"
    static let uIsDarkMode        = "u_is_dark_mode"
    static let instaUsername      = "insta_username"
    static let pageNo             = "pageNo"
    static let search             = "search"
    static let sortBy            = "sort_by"
    static let fromStartDate      = "from_start"
    static let toStartDate        = "to_start"

    static let clubName = "club_name"
    static let clubDesc = "club_desc"
    static let clubInterests = "club_interests"
    static let clubInvitedUserIds = "club_invited_user_ids"
    static let clubIsChatGroup = "club_is_chat_group"
    static let clubContact = "club_contact"
    static let clubPhoto = "club_photo"
    static let clubId = "club_id"
    static let club = "club"
    static let post = "post"
    static let event = "event"
    
    static let interestId           = "_id"
    static let interestName           = "name"
    static let userInterests           = "u_interests"
    static let userHomeTown            = "u_hometown"
    static let userLatitude            = "u_latitude"
    static let userLongitude           = "u_longitude"
    static let userBirthDate           = "u_birth_date"
    static let userGender              = "u_gender"
    static let userRelation             = "u_relationship"

    static let phone           = "phone"
    static let phoneToken           = "phone_token"
    static let countryCode           = "country_code"
    static let verifyType           = "verify_type"
    static let socialId           = "socialId"
    static let isNewRegister           = "isNewRegister"
    static let userType           = "user_type"
    static let token           = "token"
    static let email           = "email"
    static let isEmailExist           = "isEmailExist"
    static let password           = "password"
    static let firstName           = "first_name"
    static let lastName           = "last_name"

    static let uEduLevel           = "u_edu_level"
    static let uEduYear           = "u_edu_year"
    static let uEduMajors           = "u_edu_majors"
    static let uEduMinors           = "u_edu_minors"
    static let uEduClasses           = "u_edu_classes"
    static let instagramToken           = "insta_token"
    static let images           = "images"
    static let rsvpAns         = "rsvp_ans"
    
    static let dataId = "data_id"
    static let dataType = "data_type"
    static let desc = "desc"
    static let totalPhotos = "total_photos"

    static let createEventType = "event_type"
    static let eventCateId = "event_cat_id"
    static let eventName = "event_name"
    static let eventDesc = "event_desc"
    static let eventRsvpList = "event_rsvp_list"
    static let eventAddress = "event_address"
    static let eventLatitude = "event_latitude"
    static let eventLongitude = "event_longitude"
    static let eventStartDate = "event_start_date"
    static let eventEndDate = "event_end_date"
    static let eventInterests = "event_interests"
    static let eventIsChatGroup = "event_is_chat_group"
    static let eventInvitedUserIds = "event_invited_user_ids"
    static let eventPhoto = "event_photo"
    static let eventId = "event_id"
    static let isOnlyFriendGoing = "is_only_friend_going"
    static let fromStart = "from_start"
    static let toStart = "to_start"
    static let fromTime = "from_time"
    static let toTime = "to_time"

    static let postId = "post_id"
    static let parentId = "parent_id"

    static let eventContact = "event_Contact"
    static let isFirstJoin  = "isFirstJoin"
    static let otherUserId = "other_user_id"
    static let action = "action"
    static let menstionUserId = "mentioned_user_ids"
    
    static let startDate        = "startDate"
    static let endDate          = "endDate"
    static let events           = "events"
    static let classes          = "classes"
    static let count            = "count"
    static let isScheduledAnything = "isScheduledAnything"

}
