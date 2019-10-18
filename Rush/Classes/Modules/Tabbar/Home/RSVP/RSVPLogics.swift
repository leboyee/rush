//
//  RSVPLogics.swift
//  Rush
//
//  Created by kamal on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Other Function
extension RSVPViewController {
    
    func joinEvent() {
        guard let eventId = event?.id else { return }
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(answers)
            if let json = String(data: jsonData, encoding: String.Encoding.utf8) {
                let params = [Keys.rsvpAns: json]
                joinEventWithRSVP(eventId: String(eventId), action: action, params: params as [String: Any])
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func addRSVPAnswer(text: String, index: Int) {
        if let objectIndex = answers.firstIndex(where: { $0.index == index }) {
            var answer = answers[objectIndex]
            answer.ans = text
            answers[objectIndex] = answer
        } else {
            let answer = RSVPAnswer(index: index, ans: text)
            answers.append(answer)
        }
        
        if answers.count == event?.rsvp?.count ?? 0 {
            let filter = answers.filter({ $0.ans.isEmpty })
            toggleJoinButton(isEnbled: filter.count == 0)
        }
    }
    
    private func updateTable(textView: CustomBlackTextView) {
        let startHeight = textView.frame.size.height
        let calcHeight = textView.sizeThatFits(textView.frame.size).height
        if !startHeight.isEqual(to: calcHeight) {
            // Disable animations
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            // Enable animations
            UIView.setAnimationsEnabled(true)
        }
    }
}

// MARK: - Handlers
extension RSVPViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        let count = event?.rsvp?.count ?? 0
        return count
    }
    
    func fillCell(_ cell: JoinRSVPCell, _ indexPath: IndexPath) {
        if let question = event?.rsvp?[indexPath.row] {
        cell.setup(placeholder: question.que ?? "")
        let answer = answers.first(where: { $0.index == question.index })
        cell.setup(answer: answer?.ans ?? "")
        
        cell.textDidChanged = { [weak self] (text) in
            self?.addRSVPAnswer(text: text, index: question.index)
            self?.updateTable(textView: cell.textView)
        }
        
        cell.textDidEndEditing = { [weak self] (text) in
            self?.addRSVPAnswer(text: text, index: question.index)
            self?.updateTable(textView: cell.textView)
        }
        }
    }
}

// MARK: - API's
extension RSVPViewController {

    private func joinEventWithRSVP(eventId: String, action: String, params: [String: Any]) {
        Utils.showSpinner()
        ServiceManager.shared.joinEvent(eventId: eventId, action: action, params: params) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            if let object = data {
                let isFirstTime = object[Keys.isFirstJoin] as? Int ?? 0
                self?.joinSuccessfully(isFirstTime: isFirstTime == 1 ? true : false)
            } else if let message = errorMessage {
                self?.showMessage(message: message)
            }
        }
    }
}
