//
//  ClubListMediates.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit


extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.chatListCell, bundle: nil), forCellReuseIdentifier: Cell.chatListCell)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.chatListCell, for: indexPath) as! ChatListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let whitespace = whitespaceString(width: 80)
        let deleteAction = UITableViewRowAction(style: .`default`, title: whitespace) { (action, indexPath) in
            // do whatever you want
            // handle action by updating model with deletion
            Utils.alert(message: "Are you sure you want to delete?",buttons: ["Yes", "No"], handler: { (index) in
                if index == 0 {
                    tableView.reloadData()
                    let snackbar = TTGSnackbar(message: "Fine art chat was deleted",
                                               duration: .middle,
                                               actionText: "Undo",
                                               actionBlock: { (snackbar) in
                                                Utils.notReadyAlert()
                    })
                    snackbar.show()
                }
            })
            
        }
        
        // create a color from patter image and set the color as a background color of action
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        view.backgroundColor = UIColor.bgWhite96
        let imageView = UIImageView(frame: CGRect(x: (80 - 32) / 2,
                                                  y: (80 - 32) / 2,
                                                  width: 32,
                                                  height: 32))
        imageView.image = UIImage(named: "chat-delete")
        view.addSubview(imageView)
        let image = self.image(view)
        
        deleteAction.backgroundColor = UIColor(patternImage: image)
        
        return [deleteAction]
    }
    
    fileprivate func whitespaceString(font: UIFont = UIFont.systemFont(ofSize: 15), width: CGFloat) -> String {
        let kPadding: CGFloat = 20
        let mutable = NSMutableString(string: "")
        let attribute = [NSAttributedString.Key.font: font]
        while mutable.size(withAttributes: attribute).width < width - (2 * kPadding) {
            mutable.append(" ")
        }
        return mutable as String
    }
    
    func image(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
