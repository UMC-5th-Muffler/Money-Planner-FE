//
//  HomeViewModel.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/29.
//

import Foundation
import RxSwift

//rx 오류로 추후에 사용
class HomeViewModel {
    let goalText : String = "✈️ 일본여행 가기 전 돈 모으기"
    
    let monthViewCurrentYear : Int = Calendar.current.component (.year, from: Date())
    
    let monthViewCurrentMonth : Int = Calendar.current.component (.month, from: Date())
    
    let categories : [Category] = [Category(id: 0, name: "전체"), Category(id: 1, name: "식사"), Category(id: 2, name: "카페"), Category(id: 3, name: "교통"), Category(id: 4, name: "쇼핑")]
}
