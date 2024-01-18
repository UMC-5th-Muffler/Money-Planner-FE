////
////  GoalFinalViewController.swift
////  Money-Planner
////
////  Created by 유철민 on 1/12/24.
////
//
//import Foundation
//import UIKit
//
/////FIX : 변수 lazy 여부 바꿔야 한다면 바꾸기
/////TODO :  imoji
/////imoji는 imojiList에서 0번째 원소로 기본으로 채워넣되, 추후에 changeImoji를 통해 picker로 imoji를 바꿀 수 있어야 됨.
/////imoji를 터치하면 picker가 뜨도록 만들어야됨. 필요에 따라 imoji를 버튼으로 바꿔도 됨
/////TODO :
/////
//class GoalFinalViewController : UIViewController{
//    
//    lazy var header : HeaderView = HeaderView(title: "")
//    lazy var imoji : MPLabel
//    lazy var goalName : MPLabel
//    lazy var goalAmout : MPLabel
//    lazy var goalSpan : MPLabel
//    lazy var goalPeriod : MPLabel
//    lazy var bottombtn : MainBottomBtn
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setHeader()
//        setImoji()
//        setGoalName()
//        setGoalSpan()
//        setGoalPeriod()
//        setBottomBtn()
//    }
//    
//    private func setHeader(){
//        header.addBackButtonTarget(target: self, action: #selector(backButtonTapped), for: .touchUpInside)
//    }
//    
//    private func setImoji(){
//        
//    }
//    
//    private func setGoalName(){
//        
//    }
//    
//    private func setGoalSpan(){
//        
//    }
//    
//    private func setGoalPeriod(){
//        
//    }
//    
//    private func setBottomBtn(){
//        
//    }
//    
//    private func changeImoji(){
//
//    }
//    
//    @objc private func backButtonTapped() {
//        // 네비게이션 컨트롤러를 사용하여 이전 화면으로 돌아감
//        navigationController?.popViewController(animated: true)
//    }
//}
//
//class ImojiList{
//    static var imojiList  = ["💰","🎁","🕌"]
//}
