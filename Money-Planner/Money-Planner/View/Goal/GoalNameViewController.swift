//
//  GoalNameViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/12/24.
//

import Foundation
import UIKit


class GoalNameViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var header = HeaderView(title: "목표 이름 설정")
    private var emojiPickerButton = EmojiPickerButton()
    private var descriptionView = DescriptionView(text: "목표 이름과 메모를 설정해주세요", alignToCenter: true)
    private var tableView: UITableView!
    private var btmbtn = MainBottomBtn(title: "다음")
    
    private let goalViewModel = GoalViewModel.shared // 싱글턴용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHeader()
        setupEmojiPickerButton()
        setupDescriptionView()
        setUpBtmBtn()
        setupTableView()
        tableView.delegate = self // 이 코드 추가 안할시 delegate 함수 반영 안됨
    }
    
    private func setupHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60) // 예시 높이값
        ])
    }
    
    private func setupEmojiPickerButton() {
        emojiPickerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiPickerButton)
        
        NSLayoutConstraint.activate([
            emojiPickerButton.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
            emojiPickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiPickerButton.heightAnchor.constraint(equalToConstant: 50),
            emojiPickerButton.widthAnchor.constraint(equalToConstant: 50)
        ])

        
        emojiPickerButton.addTarget(self, action: #selector(presentEmojiPickerModal), for: .touchUpInside)
    }
    
    private func setupDescriptionView() {
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionView)
        
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: emojiPickerButton.bottomAnchor, constant: 70),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    
    private func setupTableView() {
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.register(WriteTextCell.self, forCellReuseIdentifier: "WriteTextCell")
        tableView.rowHeight = 60
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none  // 셀 사이 구분선 제거
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: btmbtn.topAnchor, constant: -20)
        ])
    }
    
    @objc func presentEmojiPickerModal() {
        let emojiPickerModalVC = EmojiPickerModalViewController()
        emojiPickerModalVC.modalPresentationStyle = .overCurrentContext
        emojiPickerModalVC.modalTransitionStyle = .coverVertical
        self.present(emojiPickerModalVC, animated: true, completion: nil)
    }
    
    
    // UITableViewDataSource 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // 두 개의 셀
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WriteTextCell", for: indexPath) as! WriteTextCell
        
        // 셀 설정
        switch indexPath.row {
        case 0:
            cell.configureCell(image: UIImage(systemName: "pencil"), placeholder: "목표 이름")
        case 1:
            cell.configureCell(image: UIImage(systemName: "note.text"), placeholder: "추가 설명/메모(선택)")
        default:
            break
        }
        
        return cell
    }
    
    // UITableViewDelegate 메서드
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {  // 두 번째 셀에 대한 높이 설정
            return 180
        } else {
            return 60  // 다른 셀에 대한 기본 높이
        }
    }

    
    func setUpBtmBtn(){
        btmbtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btmbtn)
        NSLayoutConstraint.activate([
            btmbtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            btmbtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btmbtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btmbtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
}


//profile을 위한 Emoji picker button
class EmojiPickerButton: UIButton {
    
    private let emojiImageView = UIImageView()
    private let addButton = UIButton(type: .system)
    private var emojiList = ["😀", "👍", "🚀", "💰", "🎉"]
    private var selectedEmoji: String? {
        didSet {
            setTitle(selectedEmoji, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 32) // 이모지 크기 조절
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 정사각형 형태를 보장하기 위한 추가 코드
        let sideLength : CGFloat = 100
        frame.size = CGSize(width: sideLength, height: sideLength)
        
        // 여기에서 cornerRadius 설정
        layer.cornerRadius = sideLength / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.mpGray.cgColor
    }
    
    private func setupButton() {
        // 초기 이모지 설정
        selectedEmoji = emojiList.first
        
        // '+' 버튼 이미지 설정 (SF Symbols)
        let plusImage = UIImage(systemName: "plus.circle.fill")?.withTintColor(.mpDarkGray, renderingMode: .alwaysOriginal)
        addButton.setImage(plusImage, for: .normal)
        addButton.addTarget(self, action: #selector(presentEmojiPicker), for: .touchUpInside)
        
        // '+' 버튼 오토레이아웃 설정
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            addButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        ])
        
        // 이 버튼의 UI 및 오토레이아웃 설정
        clipsToBounds = true
        setTitle(selectedEmoji, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 60) // 이모지 크기 조절
        setTitleColor(.mpGray, for: .normal)

        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func presentEmojiPicker() {
        let modalViewController = EmojiPickerModalViewController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.modalTransitionStyle = .coverVertical
        if let presenter = window?.rootViewController {
            presenter.present(modalViewController, animated: true, completion: nil)
        }
    }
    
    func getSelectedEmoji() -> String {
        return selectedEmoji ?? ""
    }
}


class EmojiPickerModalViewController: UIViewController {
    var emojiPickerView = UIPickerView()
    var confirmButton = UIButton()
    var dismissGestureView = UIView() // scrim과 handle bar를 위한 뷰
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
        setupDismissGesture()
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        // scrim 설정
        dismissGestureView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(dismissGestureView)
        
        // handle bar 설정
        let handleBar = UIView()
        handleBar.backgroundColor = .white
        handleBar.layer.cornerRadius = 3
        view.addSubview(handleBar)
        
        // 픽커 설정
        emojiPickerView.backgroundColor = .white
        emojiPickerView.layer.cornerRadius = 12
        emojiPickerView.layer.masksToBounds = true
        view.addSubview(emojiPickerView)
        
        // 확인 버튼 설정
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.backgroundColor = .mpMainColor
        confirmButton.layer.cornerRadius = 12
        confirmButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        view.addSubview(confirmButton)
    }
    
    private func setupLayout() {
        // scrim, handle bar, 픽커 뷰, 확인 버튼의 레이아웃을 설정합니다.
        // Auto Layout 코드를 여기에 추가합니다.
    }
    
    private func setupDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        dismissGestureView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
}


