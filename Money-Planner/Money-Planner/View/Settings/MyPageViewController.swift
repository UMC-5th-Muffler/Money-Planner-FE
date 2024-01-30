//
//  MyPageViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/30/24.
//
import Foundation
import UIKit

class MyPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 뷰 컨트롤러의 타이틀 설정
        title = "마이 페이지"

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
            cell.textLabel?.text = item
        cell.textLabel?.font = UIFont.mpFont16M()
        
            // 각 셀에 대한 추가 작업을 수행할 수 있습니다.
            return cell
        }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return myPageData[section].title
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0 // 원하는 높이로 수정하세요
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
            print("1:1 문의하기 선택됨")
        case "로그아웃":
            // 로그아웃 처리
            print("로그아웃 선택됨")
        case "탈퇴하기":
            // 계정 탈퇴 처리
            print("탈퇴하기 선택됨")
        default:
            break
        }
    }

    // 섹션과 아이템을 나타내는 데이터 구조
    struct Section {
        var title: String
        var items: [String]
    }
}
