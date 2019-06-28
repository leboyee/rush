//
//  NetworkManagerServices.swift
//  eventX_ios
//
//  Created by Kamal Mittal on 22/04/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation
extension NetworkManager {

    //MARK: - Autherization API's
    func login(params : [String : Any] , resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/login", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func signup(params : [String : Any] , resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/login", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func connectWithFB(params : [String : Any] , resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/social/login", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func logout(params : [String : Any] , resultHandler: @escaping ResultClosure) {
        requestPost(path: "auth/logout", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func phonetkn(params : [String : Any] , resultHandler: @escaping ResultClosure) {
        requestPost(path: "/auth/phone", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }



    func resendSMS(params : [String : Any] , resultHandler: @escaping ResultClosure) {
        requestPost(path: "phone/verify", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    //MARK: - Profile
    func updateProfile(params : [String : Any], resultHandler: @escaping ResultClosure) {
        requestUploadImage(path: "profile", params: params, contentType: ContentType.formData, resultHandler: resultHandler)
    }

    func getProfile(params : [String : Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "profile", params: params, resultHandler: resultHandler)
    }

    //MARK: - Update Token
    func updatePushToken(params : [String : String],resultHandler: @escaping ResultClosure) {
        requestPost(path: "pushtoken", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }


    //MARK: - Stat
    func homeStatistics(resultHandler: @escaping ResultClosure) {
        requestGet(path: "home/statistics", params: [:], resultHandler: resultHandler)
    }

    func getContributorList(params : [String : Any], resultHandler: @escaping ResultClosure) -> URLSessionDataTask? {
        return getRequestGet(path: "contributor", params: params, resultHandler: resultHandler)
    }

    func getRestaurantList(params : [String : Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "restaurant", params: params, resultHandler: resultHandler)
    }

    func getReceiverList(params : [String : Any], resultHandler: @escaping ResultClosure) -> URLSessionDataTask? {
        return getRequestGet(path: "receiver", params: params, resultHandler: resultHandler)
    }

    //MARK: - Notifications
    func getNotificationList(params : [String : Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "notification/histories", params: params, resultHandler: resultHandler)
    }

    func unreadNotificationCount(resultHandler: @escaping ResultClosure) {
        requestGet(path: "notification/badge-count", params: [:], resultHandler: resultHandler)
    }

    func updateUnreadNotificationCount(params : [String : Any], resultHandler: @escaping ResultClosure) {
        requestPut(path: "notification/badge-count", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func removeNotification(nt_id : String, resultHandler: @escaping ResultClosure) {
        requestDelete(path: "notification/\(nt_id)", params: [:], resultHandler: resultHandler)
    }

    //MARK: - Order
    func getContributorMealsList(params : [String : Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "order/contributed", params: params, resultHandler: resultHandler)
    }
    
    func getReceiverMealsList(params : [String : Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "requested-meal/receiver", params: params, resultHandler: resultHandler)
    }
    
    func getReceiverMealCount(resultHandler: @escaping ResultClosure) {
        requestGet(path: "requested-meal/total-today", params: [:], resultHandler: resultHandler)
    }

    //MARK: - Payment

    func saveReplacePaymentCard(params : [String : Any],resultHandler: @escaping ResultClosure) {
        requestPost(path: "stripe/payment/card", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func saveReplaceStripPayoutCard(params : [String : Any],resultHandler: @escaping ResultClosure) {
        requestPost(path: "stripe/payout/card", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

    func checkoutFoodContribution(params : [String : Any],resultHandler: @escaping ResultClosure) {
        requestPost(path: "checkout", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func getStripAccountDetail(params : [String : Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "stripe/account", params: params, resultHandler: resultHandler)
    }
    
    func updateStripAccountDetail(params : [String : Any], resultHandler: @escaping ResultClosure) {
        requestPost(path: "stripe/account", params: params, contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }
    
    func updateStripOwnerDetail(params : [String : Any], resultHandler: @escaping ResultClosure) {
        requestUploadImage(path: "stripe/person", params: params, contentType: ContentType.formData, resultHandler: resultHandler)
    }
    
    func resetStripeStore(resultHandler: @escaping ResultClosure) {
        requestPost(path: "stripe/reset", params: makeParamsForData(params: [:]), contentType: ContentType.formData, resultHandler: resultHandler)
    }
    
    //MARK: - Meal/Menu
    func getMealDetails(meal_id : String, resultHandler: @escaping ResultClosure) {
        requestGet(path: "menu/\(meal_id)", params: [:], resultHandler: resultHandler)
    }

    func getMealList(params : [String : Any], resultHandler: @escaping ResultClosure) {
        requestGet(path: "menu", params: params, resultHandler: resultHandler)
    }

    func addMeal(params : [String : Any], resultHandler: @escaping ResultClosure) {
        requestUploadImage(path: "menu", params: params, contentType: ContentType.formData, resultHandler: resultHandler)
    }

    func updateMeal(params : [String : Any],meal_id: String , resultHandler: @escaping ResultClosure) {
        requestUploadImage(path: "menu/\(meal_id)", params: params, contentType: ContentType.formData, resultHandler: resultHandler)
    }

    func deleteMeal(meal_id : String, resultHandler: @escaping ResultClosure) {
        requestDelete(path: "menu/\(meal_id)", params: [:], resultHandler: resultHandler)
    }

    func updateOrderStatus(order_id: String, resultHandler: @escaping ResultClosure) {
        requestPut(path: "restaurant/provide/\(order_id)", params: [:], contentType: ContentType.applicationJson, resultHandler: resultHandler)
    }

}
