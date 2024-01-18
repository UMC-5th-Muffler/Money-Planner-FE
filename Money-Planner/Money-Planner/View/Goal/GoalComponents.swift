//
//  GoalComponents.swift
//  Money-Planner
//
//  Created by 유철민 on 1/17/24.
//

import Foundation
import UIKit


// tableView 안에 들어가는 cell 중에 키보드로 수정할 수 있는 textfield를 보유
class WriteTextCell: UITableViewCell {
    
    let iconImageView = UIImageView()
    let textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupIconImageView()
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        
        backgroundColor = UIColor.clear  // 셀의 배경을 투명하게 설정
        contentView.backgroundColor = UIColor.mpLightGray
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true//" subview들이 view의 bounds에 가둬질 수 있는 지를 판단하는 Boolean 값 "
        
        selectionStyle = .none  // 셀 선택 시 배경색 변경 없음
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
    }
    
    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textField)
        
        textField.textColor = UIColor.mpGray
        textField.textAlignment = .left
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configureCell(image: UIImage?, placeholder: String) {
        if let image = image {
            iconImageView.image = image.withTintColor(.mpGray, renderingMode: .alwaysOriginal)
        } else {
            iconImageView.image = nil
        }
        textField.placeholder = placeholder
    }
}


class MultiLineTextCell: UITableViewCell {
    
    let iconImageView = UIImageView()
    let textView = UITextView()  // UITextView로 변경
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupIconImageView()
        setupTextView()  // UITextView 설정 메서드 호출
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = UIColor.clear  // 셀의 배경을 투명하게 설정
        contentView.backgroundColor = UIColor.mpLightGray
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true//" subview들이 view의 bounds에 가둬질 수 있는 지를 판단하는 Boolean 값 "
        
        selectionStyle = .none  // 셀 선택 시 배경색 변경 없음
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)
        
        textView.textColor = UIColor.mpGray
        textView.textAlignment = .left
        textView.isScrollEnabled = false  // 스크롤 비활성화
        textView.font = UIFont.systemFont(ofSize: 16)  // 폰트 설정
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configureCell(image: UIImage?, placeholder: String) {
        if let image = image {
            iconImageView.image = image.withTintColor(.mpGray, renderingMode:
                    .alwaysOriginal)
        } else {
            iconImageView.image = nil
        }
        
    }
}

// 금액 입력을 위한 cell
class MoneyAmountTextCell: UITableViewCell, UITextFieldDelegate {
    
    private let iconImageView = UIImageView()
    private let textField = UITextField()
    private let unitLabel = UILabel()
    private let amountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupIconImageView()
        setupUnitLabelField()
        setupTextField()
        setupAmountLabel()
        // Set the delegate for the textField
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        
        backgroundColor = UIColor.clear  // 셀의 배경을 투명하게 설정
        contentView.backgroundColor = UIColor.mpLightGray
        contentView.layer.cornerRadius = 10
//        contentView.clipsToBounds = true//" subview들이 view의 bounds에 가둬질 수 있는 지를 판단하는 Boolean 값 "
        
        selectionStyle = .none  // 셀 선택 시 배경색 변경 없음
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
    }
    
    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textField)
        
        textField.textColor = UIColor.mpGray
        textField.textAlignment = .left
        textField.keyboardType = .numberPad // Limit keyboard to numeric input
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: unitLabel.trailingAnchor, constant: -20),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupUnitLabelField() {
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.text = "원"
        contentView.addSubview(unitLabel)
        
        unitLabel.textColor = .mpBlack
        
        NSLayoutConstraint.activate([
            unitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            unitLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            unitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            unitLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupAmountLabel(){
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.text = "입력값이 없습니다."
        amountLabel.font = .mpFont12M()
        amountLabel.textColor = .mpGray
        contentView.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            amountLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1),
            amountLabel.heightAnchor.constraint(equalToConstant: 30),
            amountLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func configureCell(image: UIImage?, placeholder: String) {
        if let image = image {
            iconImageView.image = image.withTintColor(.mpGray, renderingMode: .alwaysOriginal)
        } else {
            iconImageView.image = nil
        }
        textField.placeholder = placeholder
    }
    
    func showNeatAmount() {
        guard let amountText = textField.text else {
            amountLabel.textColor = .mpGray
            amountLabel.text = "입력값이 없습니다."
            return
        }

        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
        let stringCharacterSet = CharacterSet(charactersIn: amountText)

        // Check if the entered characters are numbers
        if !allowedCharacterSet.isSuperset(of: stringCharacterSet) {
            amountLabel.textColor = .red
            amountLabel.text = "숫자만 입력 가능합니다."
            return
        }

        // Convert the text to an integer
        guard let amount = Int(amountText) else {
            amountLabel.textColor = .mpGray
            amountLabel.text = "유효한 숫자를 입력하세요."
            return
        }

        let maximumLimit: Int = 2147483647  // Define your own maximum limit

        if amount > maximumLimit {
            amountLabel.textColor = .red
            amountLabel.text = "숫자가 너무 큽니다."
            return
        } else {
            amountLabel.textColor = .mpGray
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 10진수
        formatter.maximumFractionDigits = 0 // 소수점 없음

        if let formattedAmount = formatter.string(from: NSNumber(value: amount)) {
            var result = ""
            let hundredMillion = amount / 100_000_000
            let tenThousand = (amount % 100_000_000) / 10_000
            let remainder = amount % 10_000

            if hundredMillion > 0 {
                result += "\(hundredMillion)억 "
            }

            if tenThousand > 0 {
                result += "\(tenThousand)만 "
            }

            if remainder > 0 {
                result += "\(remainder)원"
            } else if hundredMillion == 0 && tenThousand == 0 {
                result += "0원"
            }

            amountLabel.text = result
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
            showNeatAmount()
    }
    
}


// 금액 입력을 위한 cell
class PeriodCell: UITableViewCell, UITextFieldDelegate {
    
    private let iconImageView = UIImageView()
    private let textField = UITextField()
    private let spanLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupIconImageView()
        setupSpanLabelField()
        setupTextField()
        // Set the delegate for the textField
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        
        backgroundColor = UIColor.clear  // 셀의 배경을 투명하게 설정
        contentView.backgroundColor = UIColor.mpLightGray
        contentView.layer.cornerRadius = 10
//        contentView.clipsToBounds = true//" subview들이 view의 bounds에 가둬질 수 있는 지를 판단하는 Boolean 값 "
        
        selectionStyle = .none  // 셀 선택 시 배경색 변경 없음
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
    }
    
    private func setupIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textField)
        
        textField.textColor = UIColor.mpGray
        textField.textAlignment = .left
        textField.keyboardType = .numberPad // Limit keyboard to numeric input
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: spanLabel.trailingAnchor, constant: -20),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupSpanLabelField() {
        spanLabel.translatesAutoresizingMaskIntoConstraints = false
        spanLabel.text = ""
        contentView.addSubview(spanLabel)
        
        spanLabel.textColor = .mpMainColor
        
        NSLayoutConstraint.activate([
            spanLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            spanLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            spanLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            spanLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configureCell(image: UIImage?, placeholder: String) {
        if let image = image {
            iconImageView.image = image.withTintColor(.mpGray, renderingMode: .alwaysOriginal)
        } else {
            iconImageView.image = nil
        }
        textField.placeholder = placeholder
    }
    
    //mpMainColor의 색으로 기간 표시
    func showPeriodSpan() {
        
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        showPeriodSpan()
    }
    
}
