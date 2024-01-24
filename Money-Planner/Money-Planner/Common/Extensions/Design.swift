//
//  Design.swift
//  Money-Planner
//
//  Created by 유철민 on 1/9/24.
//

import Foundation
import UIKit


// Fonts
extension UIFont {
    // 각 폰트 스타일에 대한 메소드 정의
    static func mpFont26B() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Bold", size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .bold)
    }
    
    static func mpFont20B() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    static func mpFont20M() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium)
    }
    
    static func mpFont20R() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .regular)
    }
    
    static func mpFont18B() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    static func mpFont18M() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    static func mpFont18R() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .regular)
    }
    
    static func mpFont16B() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    static func mpFont16M() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    static func mpFont16R() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    static func mpFont14B() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    static func mpFont14M() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    static func mpFont14R() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    static func mpFont12M() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    static func mpFont12R() -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
    }
}


//Custom Color
extension UIColor {
    static let mpHomeBackGround = UIColor(red: 245/255, green: 246/255, blue: 250/255, alpha: 1.0)
    static let mpMainColor = UIColor(red: 19/255, green: 203/255, blue: 191/255, alpha: 1) // #19CBBF
    static let mpGraph = UIColor(red: 40/255, green: 216/255, blue: 204/255, alpha: 1) // #28D8CC
    static let mpCalendarHighLight = UIColor(red: 223/255, green: 242/255, blue: 241/255, alpha: 1) // #DFF2F1
    static let mpGray = UIColor(red: 190/255, green: 190/255, blue: 192/255, alpha: 1) // #BEBEC0
    static let mpLightGray = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1) // #E8E8E8
    static let mpDarkGray = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1) // #8A8A8A
    static let mpGypsumGray = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1) // #F6F6F6
    static let mpCharcoal = UIColor(red: 84/255, green: 89/255, blue: 101/255, alpha: 1) // #545965
    static let mpWhite = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1) // #FFFFFF
    static let mpBlack = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1) // #000000
}

