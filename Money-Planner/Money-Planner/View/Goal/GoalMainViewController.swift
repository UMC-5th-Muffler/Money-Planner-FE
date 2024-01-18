//
//  GoalMainViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/17/24.
//

import Foundation
import UIKit

class GoalMainViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView : UITableView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setTableView(){
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
        ])
        
    }
    
    //tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
