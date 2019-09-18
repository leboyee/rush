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
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(answers)
            if let json = String(data: jsonData, encoding: String.Encoding.utf8) {
                let escapedString = json.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let params = [Keys.rsvpAns: escapedString]
                joinEventWithRSVP(eventId: "123", params: params as [String: Any])
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func addRSVPAnswer(text: String, index: Int) {
        if let objectIndex = answers.firstIndex(where: { $0.index == index }) {
            var answer = answers[objectIndex]
            answer.answer = text
            answers[objectIndex] = answer
        } else {
            let answer = RSVPAnswer(index: index, answer: text)
            answers.append(answer)
        }
        
        if answers.count == questionCount {
            let filter = answers.filter({ $0.answer.isEmpty })
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
        let count = questionCount
        return count
    }
    
    func fillCell(_ cell: JoinRSVPCell, _ indexPath: IndexPath) {
        cell.setup(placeholder: "Do you have any experience in VR?")
        let answer = answers.first(where: { $0.index == indexPath.row })
        cell.setup(answer: answer?.answer ?? "")
        
        cell.textDidChanged = { [weak self] (text) in
            self?.addRSVPAnswer(text: text, index: indexPath.row)
            self?.updateTable(textView: cell.textView)
        }
        
        cell.textDidEndEditing = { [weak self] (text) in
            self?.addRSVPAnswer(text: text, index: indexPath.row)
            self?.updateTable(textView: cell.textView)
        }
    }
}

// MARK: - API's
extension RSVPViewController {

    private func joinEventWithRSVP(eventId: String, params: [String: Any]) {
        joinSuccessfully()
        /*
        Utils.showSpinner()
        ServiceManager.shared.joinEvent(eventId: eventId, params: params) { (data, errorMessage) in
            Utils.hideSpinner()

        } */
    }
}
