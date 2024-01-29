//
//  GoalFinalViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/12/24.
//

import Foundation
import RxMoya
import UIKit


class GoalFinalViewController : UIViewController{
    
    private let header = HeaderView(title: "")
    private let descriptionView = DescriptionView(text: "이렇게 등록할거에요", alignToCenter: false)
    private let subdescriptionView = SubDescriptionView(text: "마지막으로 확인해요!", alignToCenter: false)
    private let tableView : UITableView! = nil
    private let smallBtnView = SmallBtnView()
    
    private let goalCreationManager = GoalCreationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews(){
        
    }
    
    func setupConstraints(){
        
    }
    
    @objc func completeBtnTapped(){
        //navigation을 시작한 첫 화면인 GoalMainViewController 으로 돌아가기
        
        //post하기
        
        //manager 비우기
        goalCreationManager.clear()
    }
    
    @objc func cancelBtnTapped(){
        //navigation을 시작한 첫 화면인 GoalMainViewController 으로 돌아가기
        
        
        //manager 비우기
        goalCreationManager.clear()
    }
    
    
    
    
    
}

