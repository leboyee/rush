//
//  ChatContactsListViewController.swift
//  Rush
//
//  Created by ideveloper on 17/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//
import UIKit

class ChatContactsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pageNo = 1
    var isNextPageExist = false
    var searchText = ""
    var friendsList = [String: Any]()
    var tempFriendsList = [User]()
    
    let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        setupTableView()
        setupNavigation()
        getFriendListAPI()
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
