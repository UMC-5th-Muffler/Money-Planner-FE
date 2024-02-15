//  MyPageViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/30/24.
//
import Foundation
import UIKit


class MyPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfileViewDelegate {
    var tempUserName : String = ""
    var tempProfileImage: UIImage?

    var user = User()
    // 테이블 뷰 데이터 소스
    let myPageData = [
        Section(title: "프로필", items: ["프로필"]),
        Section(title: "설정", items: ["알림 설정"]),
        Section(title: "앱 정보 및 문의", items: ["앱 버전", "약관 및 정책", "개인정보 처리 방침", "1:1 문의하기"]),
        Section(title: "계정", items: ["로그아웃", "탈퇴하기"])
    ]

    // UITableView 인스턴스
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tempUserName = user.userNameString
        navigationController?.isNavigationBarHidden = true // 네비게이션 바 숨김

        // 커스텀 UITableViewCell 등록
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: "myPageCell")


        // 테이블 뷰의 델리게이트와 데이터 소스 설정
        tableView.delegate = self
        tableView.dataSource = self

        // 테이블 뷰를 뷰 계층에 추가
        view.addSubview(tableView)

        // 테이블 뷰에 대한 제약 조건 설정
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - UITableViewDataSource 메서드

    func numberOfSections(in tableView: UITableView) -> Int {
        return myPageData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageData[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myPageCell", for: indexPath) as! MyPageTableViewCell
        let item = myPageData[indexPath.section].items[indexPath.row]
        var text = item
 
        if item == "알림 설정" {
            // 알림 설정인 경우 on or off 버튼 추가
            text = "ON"
            cell.optionalLabel.text = text
            
        }
        if item == "프로필"{
            text = "프로필 설정"
            cell.optionalLabel.text = text
            cell.addProfile(user.userNameString, image : tempProfileImage)

            // 프로필인 경우 프로필 띄우기
        }
        else{
            cell.textLabel?.text = item
            cell.textLabel?.font = UIFont.mpFont16M()

        }
        
            // 각 셀에 대한 추가 작업을 수행할 수 있습니다.
            return cell
        }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if myPageData[section].title == "프로필"{
            return nil // 부제목을 표시하지 않음
        }
        return myPageData[section].title
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = myPageData[indexPath.section].items[indexPath.row]
        if item == "프로필"{
            return 128.0 // 프로필인 경우 높이 120

        }else{
            return 60.0 //프로필이 아닌 경우 높이 60
        }
        
    }

    // MARK: - UITableViewDelegate 메서드

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // 셀 선택 처리
        let selectedItem = myPageData[indexPath.section].items[indexPath.row]

        switch selectedItem {
        case "프로필":
            // 프로필 뷰로 이동
            print("프로필 선택됨")
            // 프로필 설정 화면으로 이동
            settingProfile()
            
        case "알림 설정":
            // 알림 설정 뷰로 이동
            print("알림 설정 선택됨")
        case "앱 버전":
            // 앱 버전 뷰로 이동
            print("앱 버전 선택됨")
        case "약관 및 정책":
            // 약관 및 정책 뷰로 이동
            print("약관 및 정책 선택됨")
        case "개인정보 처리 방침":
            // 개인정보 처리 방침 뷰로 이동
            print("개인정보 처리 방침 선택됨")
        case "1:1 문의하기":
            // 1:1 문의하기 뷰로 이동
            Ask()
            print("1:1 문의하기 선택됨")
        case "로그아웃":
            // 로그아웃 처리
            print("로그아웃 선택됨")
            // 로그아웃 모달로 이동
            let logoutVC = PopupViewController() // 로그아웃 완료 팝업 띄우기
            present(logoutVC, animated: true)
            
            
        case "탈퇴하기":
            // 계정 탈퇴 처리
            print("탈퇴하기 선택됨")
            Unregister()
        default:
            break
        }
    }

    // 섹션과 아이템을 나타내는 데이터 구조
    struct Section {
        var title: String
        var items: [String]
    }
    
    func profileNameChanged(_ userName: String, _ profileImage : UIImage?) {
        user.changeUserName(userName)
        tempUserName = userName
        tempProfileImage = profileImage // Set the profile image in your User model

        // Reload only the cell representing the profile
        if let indexPath = indexPathForProfileCell() {
            tableView.reloadRows(at: [indexPath], with: .none)
        }

        print("프로필 이름이 변경되었습니다")
        print(user.userNameString)
        view.layoutIfNeeded()
    }

    private func indexPathForProfileCell() -> IndexPath? {
        for (sectionIndex, section) in myPageData.enumerated() {
            if let rowIndex = section.items.firstIndex(of: "프로필") {
                return IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
        return nil
    }
    
    func settingProfile() {
        let profileVC = ProfileViewController(tempUserName: tempUserName) // 프로필 설정 화면으로 이동
        profileVC.modalPresentationStyle = .fullScreen
        profileVC.delegate = self
        present(profileVC, animated: true)
    }
    func Ask(){
        let askVC = AskViewController() // 프로필 설정 화면으로 이동
        askVC.modalPresentationStyle = .fullScreen
        //askVC.delegate = self
        present(askVC, animated: true)
        
    }
    func Unregister(){
        let unregisterVC = UnregisterViewController() // 프로필 설정 화면으로 이동
        unregisterVC.modalPresentationStyle = .fullScreen
        //askVC.delegate = self
        present(unregisterVC, animated: true)
        
    }
}
