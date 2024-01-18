//
//  Components.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit


// CustomLabel (letter spacing -2%)
class MPLabel: UILabel {
    override var text: String? {
        didSet {
            updateTextSpacing()
        }
    }
    
    // 문자 간격 업데이트 메소드
    private func updateTextSpacing() {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let letterSpacing = -0.02 * self.font.pointSize // 글자 크기의 -2%
        attributedString.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: text.count))
        self.attributedText = attributedString
    }
    
    /// 사용방법
    /// let label = MPLabel()
    /// label.font = UIFont.systemFont(ofSize: 16)
    /// label.text = "커스텀 레이블 테스트"
}


// HeaderView
class HeaderView: UIView {
    
    private let backButton = UIButton()
    private let titleLabel = MPLabel()
    
    init(title: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        setupBackButton()
        setupTitleLabel(with: title)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //추후 색 변환 가능
    private func setupBackButton() {
        if let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal) {
            let darkGrayChevron = chevronImage.withTintColor(.mpGray)
            backButton.setImage(darkGrayChevron, for: .normal)
        }
        addSubview(backButton)
    }
    
    
    //나중에 action을 필요에 따라 설정한다.
    public func addBackButtonTarget(target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        backButton.addTarget(target, action: action, for: controlEvents)
    }
    
    //받은 제목에 맞춰서 title 수정
    private func setupTitleLabel(with title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont.mpFont18B()
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }
    
    //headerView 내부 contraint
    private func setupConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}



//DescriptionView
class DescriptionView: MPLabel {
    // 초기화 메소드
    init(text: String, alignToCenter: Bool) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = alignToCenter ? .center : .left
        self.font = UIFont.mpFont26B()
        self.numberOfLines = 0  // 여러 줄 표시 가능
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//SubDescriptionView
class SubDescriptionView: MPLabel {
    // 초기화 메소드
    init(text: String, alignToCenter: Bool) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = alignToCenter ? .center : .left
        self.textColor = UIColor.mpGray
        self.font = UIFont.mpFont16B()
        self.numberOfLines = 0  // 여러 줄 표시 가능
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//check
class CheckBtn: UIButton {
    // 체크 상태 프로퍼티
    var isChecked: Bool = true {
        didSet {
            updateImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
        updateImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 체크 상태 토글 메소드
    @objc private func toggleCheck() {
        isChecked = !isChecked
    }
    
    // 이미지 업데이트 메소드
    private func updateImage() {
        let systemName = "checkmark.circle.fill"
        let color = isChecked ? UIColor.mpMainColor : UIColor.mpGray
        setImage(UIImage(systemName: systemName)?.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    // 초기 상태 설정 메소드
    func setChecked(_ checked: Bool) {
        isChecked = checked
    }
}


//MainBottomButton
class MainBottomBtn: UIButton {
    // 초기화 메소드
    init(title: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isEnabled: Bool {
        didSet {
            updateButtonStyle()
        }
    }
    
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        layer.cornerRadius = 10  // 둥근 모서리 설정
        titleLabel?.font = UIFont.systemFont(ofSize: 16)  // 폰트 크기 설정
        updateButtonStyle()
    }
    
    // 버튼 스타일 업데이트 메소드
    private func updateButtonStyle() {
        if isEnabled {
            backgroundColor = .mpMainColor
            setTitleColor(.mpWhite, for: .normal)
        } else {
            backgroundColor = .mpLightGray
            setTitleColor(.mpGray, for: .normal)
        }
    }
}


//smallButton
class SmallBtnView: UIView {
    // 버튼 생성
    private let cancelButton = UIButton()
    private let completeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///사용하는 viewcontroller에서 viewdidload에서 반드시 넣어줄것!
    ///smallButtonView.addCancelAction(target: self, action: #selector(cancelButtonTapped))
    ///smallButtonView.addCompleteAction(target: self, action: #selector(completeButtonTapped))
    ///
    ///@objc func cancelButtonTapped() {
    ///print("취소 버튼이 탭되었습니다.")
    /// 취소 버튼 액션 처리
    ///}
    ///
    // 취소 버튼에 액션 추가 메소드
    func addCancelAction(target: Any?, action: Selector) {
        cancelButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    // 완료 버튼에 액션 추가 메소드
    func addCompleteAction(target: Any?, action: Selector) {
        completeButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func setupButtons() {
        // 취소 버튼 설정
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(UIColor.mpMainColor, for: .normal)
        cancelButton.layer.borderColor = UIColor.mpMainColor.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.backgroundColor = UIColor.mpWhite
        cancelButton.layer.cornerRadius = 10  // 적절한 둥글기 값 설정
        cancelButton.clipsToBounds = true
        
        // 완료 버튼 설정
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(UIColor.mpWhite, for: .normal)
        completeButton.backgroundColor = UIColor.mpMainColor
        completeButton.layer.cornerRadius = 10  // 적절한 둥글기 값 설정
        completeButton.clipsToBounds = true
        
        // 버튼을 뷰에 추가
        addSubview(cancelButton)
        addSubview(completeButton)
        
        // Auto Layout 설정
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 취소 버튼 제약 조건
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 완료 버튼 제약 조건
            completeButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 10), // 버튼 사이의 간격
            completeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            completeButton.topAnchor.constraint(equalTo: topAnchor),
            completeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 두 버튼의 너비를 동일하게 설정
            cancelButton.widthAnchor.constraint(equalTo: completeButton.widthAnchor)
        ])
    }
}

