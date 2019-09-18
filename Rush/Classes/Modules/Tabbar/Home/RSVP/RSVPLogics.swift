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
    
    private func addRSVPAnswer(text: String, index: Int) {
        if var answer = answers.first(where: { $0.index == index }) {
            answer.answer = text
            answers[index] = answer
        } else {
            let answer = RSVPAnswer(index: index, answer: text)
            answers.append(answer)
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
        let count = 2
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

}
