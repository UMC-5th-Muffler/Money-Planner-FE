//
//  Example.swift
//  Money-Planner
//
//  Created by 유철민 on 2/26/24.
//

import Foundation
import UIKit
import Lottie

class GifViewController : UIViewController {
    
    let animationView1 :  LottieAnimationView = {
        let animationView: LottieAnimationView = .init(name: "muffler_delete")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 2
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    let animationView2 :  LottieAnimationView = {
        let animationView: LottieAnimationView = .init(name: "muffler_happy2")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 2
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    let animationView3 :  LottieAnimationView = {
        let animationView: LottieAnimationView = .init(name: "muffler_surprised")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 2
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    let animationView4 :  LottieAnimationView = {
        let animationView: LottieAnimationView = .init(name: "muffler_zero")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 2
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    let animationView5 :  LottieAnimationView = {
        let animationView: LottieAnimationView = .init(name: "muffler_money")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 2
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationViews = [animationView1, animationView2, animationView3, animationView4, animationView5]
        animationViews.forEach { animationView in
            self.view.addSubview(animationView)
        }
        
        //첫 번째 애니메이션 뷰의 제약조건 설정
        NSLayoutConstraint.activate([
            animationView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            animationView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            animationView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
        
        //첫 번째를 제외한 나머지 애니메이션 뷰의 제약조건을 설정
        for (index, animationView) in animationViews.enumerated() where index > 0 {
            NSLayoutConstraint.activate([
                animationView.topAnchor.constraint(equalTo: animationViews[index - 1].bottomAnchor, constant: 10),
                animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
                animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
            ])
        }
        
        //마지막 애니메이션 뷰의 하단 제약조건 추가
        if let lastAnimationView = animationViews.last {
            NSLayoutConstraint.activate([
                lastAnimationView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
        }
        
        //모든 애니메이션 뷰 재생
        animationViews.forEach { $0.play() }
        
        view.backgroundColor = .white
    }
}

//참조 : https://babbab2.tistory.com/142
