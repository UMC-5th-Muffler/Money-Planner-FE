//
//  ExpenseTapController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/17/24.
//

import Foundation
import UIKit


class ExpenseTapController: UIViewController{
    override func viewDidLoad() {
        // ConsumeViewController를 모달로 표시
        let consumeVC = ConsumeViewController()
        consumeVC.modalPresentationStyle = .overFullScreen
        //let navigationController = UINavigationController(rootViewController: consumeVC)
        present(consumeVC, animated: true, completion: nil)
        
    }
}
