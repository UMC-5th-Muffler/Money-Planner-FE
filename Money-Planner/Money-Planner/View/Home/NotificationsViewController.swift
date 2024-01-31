//
//  NotificationsViewController.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/24.
//

import Foundation
import UIKit

class NotificationViewController : UIViewController {
    
    lazy var settingButton : UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.tintColor = .mpBlack
        button.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.backgroundColor = .mpWhite
        self.navigationController?.navigationBar.tintColor = .mpBlack
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "알림"
        self.navigationItem.rightBarButtonItems = [settingButton]
    }
    
}

extension NotificationViewController {
    @objc func settingButtonTapped() {
        print("setting button tapped")
    }
}

