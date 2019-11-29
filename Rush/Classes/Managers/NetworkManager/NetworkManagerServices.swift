//
//  NetworkManagerServices.swift
//  eventX_ios
//
//  Created by Kamal Mittal on 22/04/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
extension NetworkManager {

    // MARK: - Autherization API's
    func checkEmail(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "email/check", params: params, resultHandler: resultHandler)
    }
    
    func restorePassword(params: [String: Any], resultHandler: @escaping ResultClosure) {
         requestGet(path: "auth/resetpwd", params: params, resultHandler: resultHandler)
     }
    
    func verifyPassword(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "verify/pwd", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
       }
    
    func changePassword(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "change/pwd", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func restoreNewPassword(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/resetpwd", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func login(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/login", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func signup(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/signup", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func connectWithFB(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/social/login", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func logout(resultHandler: @escaping ResultClosure) {
        requestDelete(path: "auth/logout", params: [:], resultHandler: resultHandler)
    }

    func phonetkn(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/phonetkn", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func authPhone(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/phone", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func resendSMS(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "phone/verify", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    // MARK: - Home
    func getHomeList(params: [String: Any], resultHandler: @escaping ResultClosure) {
           requestGet(path: "home/list", params: params, resultHandler: resultHandler)
       }
    
    // MARK: - Profile
    func updateProfile(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "profile", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func uploadUserProfileImage(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestUploadImage(path: "profile/photo", params: params, contentType: ContentType.formData, resultHandler: resultHandler)
    }

    func instagramConnect(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "instagram/connect", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func instagramDisconnect(resultHandler: @escaping ResultClosure) {
        requestDelete(path: "instagram/disconnect", params: [:], resultHandler: resultHandler)
    }
    
    func getProfile(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "profile", params: params, resultHandler: resultHandler)
    }

    // MARK: - Update Token
    func updatePushToken(params: [String: String], resultHandler: @escaping ResultClosure) {
        requestPost(path: "pushtoken", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func getUniversity(params: [String: Any], resultHandler: @escaping ResultClosure) {
          requestGet(path: "university", params: params, resultHandler: resultHandler)
      }
    
    func getUniversityWithSession(params: [String: Any], resultHandler: @escaping ResultClosure) -> URLSessionDataTask? {
        return getRequestGet(path: "university", params: params, resultHandler: resultHandler)
       }

    // MARK: - Major and Minor list
    func getMajorList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "major", params: params, resultHandler: resultHandler)
    }
    
    func getMinorList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "minor", params: params, resultHandler: resultHandler)
    }
    
    func getInterestList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "interest", params: params, resultHandler: resultHandler)
    }
    
    func getClassCategory(params: [String: Any], resultHandler: @escaping ResultClosure) {
          requestGet(path: "category/class", params: params, resultHandler: resultHandler)
      }
    
    func getSubClass(classId: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "class/\(classId)/groups", params: params, resultHandler: resultHandler)
    }

    func getImageList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "profile-images", params: params, resultHandler: resultHandler)
    }
    
    func createClub(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestUploadImage(path: "club", params: params, contentType: ContentType.formData, resultHandler: resultHandler)
    }
    
    func updateClub(clubId: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestUploadImage(path: "club/\(clubId)", params: params, contentType: ContentType.formData, resultHandler: resultHandler)
    }
   
    func getClubList(sortBy: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "club/\(sortBy)/list", params: params, resultHandler: resultHandler)
    }
    
    func getClubDetail(clubId: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "club/\(clubId)", params: params, resultHandler: resultHandler)
    }
    
    func deleteClub(clubId: Int64, param: [String: Any], resultHandler: @escaping ResultClosure) {
        requestDelete(path: "club/\(clubId)", params: param, resultHandler: resultHandler)
    }
    
    func createPost(param: [String: Any], resultHandler: @escaping ResultClosure) {
        requestUploadImage(path: "post", params: param, contentType: ContentType.formData, resultHandler: resultHandler)
    }
    
    func deletePost(postId: String, param: [String: Any], resultHandler: @escaping ResultClosure) {
        requestDelete(path: "post/\(postId)", params: param, resultHandler: resultHandler)
    }
    
    func postComment(param: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "comment", params: param, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func getCommentList(postId: String, param: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "post/\(postId)/comment/list", params: param, resultHandler: resultHandler)
    }
    
    func votePost(postId: String, voteType: String, resultHandler: @escaping ResultClosure) {
        requestPut(path: "post/\(postId)/vote/\(voteType)", params: [:], contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func fetchPostList(dataId: String, type: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "\(type)/\(dataId)/post/list", params: params, resultHandler: resultHandler)
    }
    
    func joinClub(clubId: String, param: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "club/\(clubId)/\(param[Keys.action] ?? "join")", params: param, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    func joinClassGroup(classId: String, groupId: String, param: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "class/\(classId)/group/\(groupId)/join", params: param, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    func getClassDetail(classId: String, groupId: String, param: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "class/\(classId)/group/\(groupId)", params: param, resultHandler: resultHandler)
    }

    // MARK: - Events
    func getEventDetail(eventId: String, resultHandler: @escaping ResultClosure) {
        requestGet(path: "event/\(eventId)", params: [:], resultHandler: resultHandler)
    }
    
    func getEventList(sortBy: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "event/\(sortBy)/list", params: params, resultHandler: resultHandler)
    }
    
    func getEventCategoryWithEventList(params: [String: Any], resultHandler: @escaping ResultClosure) {
             requestGet(path: "interest/event/list", params: params, resultHandler: resultHandler)
    }
  
    func joinEvent(eventId: String, action: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "event/\(eventId)/\(action)", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func createEvent(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestUploadImage(path: "event", params: params, contentType: ContentType.formData, resultHandler: resultHandler)
    }
    
    func updateEvent(eventId: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestUploadImage(path: "event/\(eventId)", params: params, contentType: ContentType.formData, resultHandler: resultHandler)
    }
    
    func getCalendarList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "calender/list", params: params, resultHandler: resultHandler)
    }
    
    func getInviteeList(eventId: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "event/\(eventId)/invitees", params: params, resultHandler: resultHandler)
    }
    
    func getClubInviteeList(clubId: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "club/\(clubId)/invitees", params: params, resultHandler: resultHandler)
    }
    
    func getClassGroupRostersList(classId: String, groupId: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "class/\(classId)/group/\(groupId)/rosters", params: params, resultHandler: resultHandler)
    }
   
    func getInviteeListWithSession(eventId: String, params: [String: Any], resultHandler: @escaping ResultClosure) -> URLSessionDataTask? {
        return getRequestGet(path: "event/\(eventId)/invitees", params: params, resultHandler: resultHandler)
       }
    
    func getClubCategoryList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "interest/club/list", params: params, resultHandler: resultHandler)
    }
    
    func getCategoryClassList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "category/class/list", params: params, resultHandler: resultHandler)
    }

    func getClassList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "class/list", params: params, resultHandler: resultHandler)
    }
    func getMyJoinedClassList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "profile/class/list", params: params, resultHandler: resultHandler)
    }

    func getClassGroupList(classId: String, params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "class/\(classId)/groups", params: params, resultHandler: resultHandler)
    }

    func deleteEvent(eventId: String, resultHandler: @escaping ResultClosure) {
        requestDelete(path: "event/\(eventId)", params: [:], resultHandler: resultHandler)
    }
    
    func deletePhoto(photoId: String, resultHandler: @escaping ResultClosure) {
        requestDelete(path: "profile/photo/\(photoId)", params: [:], resultHandler: resultHandler)
    }

    
    func inviteContact(params: [String: Any], resultHandler: @escaping ResultClosure) {
          requestPost(path: "contacts/invite", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
      }
    
    // MARK: - Post API
    func getPostDetail(postId: String, param: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "post/\(postId)", params: param, resultHandler: resultHandler)
    }
    // MARK: - Friend
    func getFriendList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "friend", params: params, resultHandler: resultHandler)
    }
    // MARK: - People
    func getPeopleList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "people", params: params, resultHandler: resultHandler)
    }
    
    func getFriendListWithSession(params: [String: Any], resultHandler: @escaping ResultClosure) -> URLSessionDataTask? {
        return getRequestGet(path: "friend", params: params, resultHandler: resultHandler)
    }
    
    func sendFriendRequest(param: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "friend", params: param, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func friendRequestStatus(param: [String: Any], resultHandler: @escaping ResultClosure) {
        requestPut(path: "friend", params: param, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    // MARK: - Notification
    func getNotificationList(params: [String: Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "notification/histories", params: params, resultHandler: resultHandler)
    }
}
