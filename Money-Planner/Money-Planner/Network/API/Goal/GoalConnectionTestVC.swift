//
//  GoalConnectionTestVC.swift
//  Money-Planner
//
//  Created by 유철민 on 1/30/24.
//

import Foundation
import UIKit

//class GoalConnectionTestVC : UIViewController{
//    
//    //get 만 시도해본다.
//    //화면 시작시 자동으로 get으로 Goal들을 받아서 보여준다.
//    
//}

import UIKit
import RxSwift
import RxCocoa //Missing required module 'RxCocoaRuntime' => 해결필요

class GoalConnectionTestVC: UIViewController {
    
    var goalRepository = GoalRepository.shared
    let disposeBag = DisposeBag()
    
    // Assuming you have a UILabel to display the results
    @IBOutlet weak var resultsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGoals()
    }
    
    private func fetchGoals() {
        goalRepository.getPreviousGoals()
            .subscribe(on: MainScheduler.instance)
            .subscribe { [weak self] goalResponse in
                //self?.handleGoalResponse(goalResponse)
            } onError: { [weak self] error in
                self?.resultsLabel.text = "Error: \(error.localizedDescription)"
            }
            .disposed(by: disposeBag)
    }
    
    private func handleGoalResponse(_ response: GetCategoryResponse) {
        // Handle your response and update UI accordingly
        // This is just a simple way to show the response in a label
//        resultsLabel.text = "Goals: \(response.result.terms.map { "\($0.startDate) to \($0.endDate)" }.joined(separator: ", "))"
    }
}
