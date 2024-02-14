//
//  DailyComsumeViewController.swift
//  Money-Planner
//
//  Created by Jini on 2024/01/28.
//

import Foundation
import UIKit

class DailyConsumeViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dateText = ""
    var totalAmount = 100000
    var flag = 1 //0 : 소비등록x / 1 : 소비등록 1개이상 완료
    var zeroday = 0 //0 : 제로데이 / 1 : 제로데이아님
    var evaluation = false
    var temptext = ""
    
    let historyList = Consumption.data
    let cellSpacingHeight: CGFloat = 1
    
    let dateLabel = DescriptionView(text: "", alignToCenter: false)
    
    let consumeLabel : MPLabel = {
        let label = MPLabel()
        label.font = UIFont.mpFont18M()
        label.textColor = UIColor.mpCharcoal
        
        return label
    }()
    
    let evaluationView = UIView()
    
    let stateLabel : MPLabel = {
        let label = MPLabel()
        label.font = UIFont.mpFont14B()
        
        return label
    }()
    
    let textLabel = memoLabel()
    
    let historyTableView = UITableView()
    
    let imageView : UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "icon_Paper"))
        
        return imageview
    }()
    
    let guideLabel : MPLabel = {
        let label = MPLabel()
        label.text = "아직 소비내역을 입력하지 않았어요!\n오늘 소비내역이 있나요?"
        label.numberOfLines = 0
        label.font = UIFont.mpFont16M()
        label.textColor = UIColor.mpDarkGray
        label.textAlignment = .center
        
        return label
    }()
    
    let zeroOnBtn = UIButton()
    let zeroOffBtn = UIButton()
    
    let addContainerView = UIView()
    let addConsumeBtn = UIButton()
    
    override func viewDidLoad(){
        view.backgroundColor = UIColor.mpWhite
        
        setupNavigationBar()
        setupDateView()
        dateLabel.text = dateText
        
        if flag == 0 && zeroday == 1 { //소비등록 안한 상태 && 제로데이아님
            setupInitial()
            setupAddBtn()
        }
        else if flag == 0 && zeroday == 0 { //소비등록 안한 상태 && 제로데이
            setupZeroday()
        }
        else { //소비등록한 상태
            setupTotalAmount()
            setupEvaluation()
            setupHistory()
            setupAddBtn()
            
            historyTableView.delegate = self
            historyTableView.dataSource = self
            historyTableView.register(historyCell.self, forCellReuseIdentifier: historyCell.cellId)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return historyList.count
     }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyCell.cellId, for: indexPath) as! historyCell
        
        let consumption = historyList[indexPath.section]
        
        // 데이터 할당
        cell.category.image = UIImage(named: consumption.category)
        cell.name.text = consumption.title
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let formattedPrice = numberFormatter.string(from: NSNumber(value: consumption.price)) {
            cell.priceAmount.text = "\(formattedPrice)원"
        } else {
            cell.priceAmount.text = "\(consumption.price)원"
        }
        
        cell.memoText.text = consumption.memo
        cell.configureSeparatorViewVisibility(isVisible: !consumption.memo.isEmpty)
        
//        let memoTextHeight = heightForView(text: consumption.memo, font: UIFont.mpFont14R(), width: tableView.bounds.width - 64)
//        cell.memoTextHeight = memoTextHeight
        
        cell.layoutIfNeeded()
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let consumption = historyList[indexPath.section]
        let memoTextHeight = heightForView(text: consumption.memo, font: UIFont.mpFont14R(), width: tableView.bounds.width - 64)
        
        if consumption.memo.isEmpty {
            return 53 + 30
        } else {
            return 53 + 20 + memoTextHeight + 30
        }
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
}


extension DailyConsumeViewController {
    func setupNavigationBar() {
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mpBlack, NSAttributedString.Key.font: UIFont.mpFont18B()]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        //self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    func setupDateView() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24),
            dateLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func setupTotalAmount() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if let formattedTotalAmount = numberFormatter.string(from: NSNumber(value: totalAmount)) {
            consumeLabel.text = "\(formattedTotalAmount)원 썼어요"
        } else {
            consumeLabel.text = "\(totalAmount)원 썼어요"
        }
        
        consumeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(consumeLabel)
        
        NSLayoutConstraint.activate([
            consumeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            consumeLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            consumeLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            consumeLabel.heightAnchor.constraint(equalToConstant: 23)
        ])
    }
    
    func setupEvaluation() {
        evaluationView.backgroundColor = UIColor.mpGypsumGray
        evaluationView.layer.cornerRadius = 20
        
        let emojiView = UIImageView()
        let iconView = UIImageView()
        
        if evaluation == true {
            emojiView.image = UIImage(named: "btn_evaluation_red_on")
            iconView.image = UIImage(named: "btn_Edit")
            stateLabel.text = "아쉬워요"
            stateLabel.textColor = UIColor.mpCharcoal
        }
        else {
            emojiView.image = UIImage(named: "btn_evaluation_no")
            iconView.image = UIImage(named: "btn_arrow")
            stateLabel.text = "오늘 하루를 평가해보세요!"
            stateLabel.textColor = UIColor.mpDarkGray
        }
        
        evaluationView.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(evaluationView)
        evaluationView.addSubview(stateLabel)
        evaluationView.addSubview(emojiView)
        evaluationView.addSubview(iconView)
        evaluationView.addSubview(textLabel)
        
        textLabel.text = temptext
        textLabel.font = UIFont.mpFont14M()
        textLabel.textColor = UIColor.mpDarkGray
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byCharWrapping
        textLabel.adjustsFontSizeToFitWidth = false
        
        if textLabel.text == "" { //메모 없으면
            NSLayoutConstraint.activate([
                evaluationView.topAnchor.constraint(equalTo: consumeLabel.bottomAnchor, constant: 24),
                evaluationView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                evaluationView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                evaluationView.heightAnchor.constraint(equalToConstant: 62),
                
                emojiView.centerYAnchor.constraint(equalTo: evaluationView.centerYAnchor),
                emojiView.leadingAnchor.constraint(equalTo: evaluationView.leadingAnchor, constant: 20),
                emojiView.widthAnchor.constraint(equalToConstant: 30),
                emojiView.heightAnchor.constraint(equalToConstant: 30),
                
                stateLabel.centerYAnchor.constraint(equalTo: evaluationView.centerYAnchor),
                stateLabel.leadingAnchor.constraint(equalTo: emojiView.trailingAnchor, constant: 10),
                
                iconView.centerYAnchor.constraint(equalTo: evaluationView.centerYAnchor),
                iconView.trailingAnchor.constraint(equalTo: evaluationView.trailingAnchor, constant: -20),
                iconView.widthAnchor.constraint(equalToConstant: 24),
                iconView.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
        else {
            NSLayoutConstraint.activate([
                evaluationView.topAnchor.constraint(equalTo: consumeLabel.bottomAnchor, constant: 24),
                evaluationView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                evaluationView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                evaluationView.bottomAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16), //textLabel 있으면... 없으면 center처리
                
                emojiView.topAnchor.constraint(equalTo: evaluationView.topAnchor, constant: 16),
                emojiView.leadingAnchor.constraint(equalTo: evaluationView.leadingAnchor, constant: 20),
                emojiView.widthAnchor.constraint(equalToConstant: 30),
                emojiView.heightAnchor.constraint(equalToConstant: 30),
                
                stateLabel.topAnchor.constraint(equalTo: evaluationView.topAnchor, constant: 21),
                stateLabel.leadingAnchor.constraint(equalTo: emojiView.trailingAnchor, constant: 10),
                
                iconView.topAnchor.constraint(equalTo: evaluationView.topAnchor, constant: 19),
                iconView.trailingAnchor.constraint(equalTo: evaluationView.trailingAnchor, constant: -20),
                iconView.widthAnchor.constraint(equalToConstant: 24),
                iconView.heightAnchor.constraint(equalToConstant: 24),
                
                textLabel.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 10),
                textLabel.leadingAnchor.constraint(equalTo: evaluationView.leadingAnchor, constant: 20),
                textLabel.trailingAnchor.constraint(equalTo: evaluationView.trailingAnchor, constant: -20)
            ])
        }
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(evaluationViewTapped))
        evaluationView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func evaluationViewTapped() {
        // Navigate to EvaluationViewController
        let evaluationVC = EvaluationViewController() // Instantiate your EvaluationViewController
        // Push or present EvaluationViewController based on your navigation flow
        navigationController?.pushViewController(evaluationVC, animated: true) // Assuming you're using navigation controller
    }
    
    func setupHistory() {
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        
        historyTableView.separatorStyle = .none
        historyTableView.rowHeight = UITableView.automaticDimension
        historyTableView.estimatedRowHeight = 100
        
        view.addSubview(historyTableView)
        
        NSLayoutConstraint.activate([
            historyTableView.topAnchor.constraint(equalTo: evaluationView.bottomAnchor, constant: 40),
            historyTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            historyTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            historyTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func setupInitial() {
        zeroOnBtn.setTitle("오늘 0원 소비했어요", for: .normal)
        zeroOnBtn.setTitleColor(.mpWhite, for: .normal)
        zeroOnBtn.titleLabel?.font = UIFont.mpFont18B()
        zeroOnBtn.backgroundColor = UIColor.mpMainColor
        zeroOnBtn.layer.cornerRadius = 12
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        zeroOnBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(guideLabel)
        view.addSubview(zeroOnBtn)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 160),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 95),
            imageView.heightAnchor.constraint(equalToConstant: 79),
            
            guideLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideLabel.heightAnchor.constraint(equalToConstant: 50),
            
            zeroOnBtn.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 20),
            zeroOnBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            zeroOnBtn.heightAnchor.constraint(equalToConstant: 50),
            zeroOnBtn.widthAnchor.constraint(equalToConstant: 203)
        ])
    }
    
    func setupZeroday() {
        guideLabel.text = "0원 소비를 한 날이에요!\n소비내역을 추가하려면\n0원소비를 해제해주세요."
        guideLabel.numberOfLines = 0
        guideLabel.font = UIFont.mpFont16M()
        guideLabel.textColor = UIColor.mpDarkGray
        guideLabel.textAlignment = .center
        
        zeroOffBtn.setTitle("0원소비 해제", for: .normal)
        zeroOffBtn.setTitleColor(.mpWhite, for: .normal)
        zeroOffBtn.titleLabel?.font = UIFont.mpFont18B()
        zeroOffBtn.backgroundColor = UIColor.mpMainColor
        zeroOffBtn.layer.cornerRadius = 12
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        zeroOffBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(guideLabel)
        view.addSubview(zeroOffBtn)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 160),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 95),
            imageView.heightAnchor.constraint(equalToConstant: 79),
            
            guideLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideLabel.heightAnchor.constraint(equalToConstant: 75),
            
            zeroOffBtn.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 20),
            zeroOffBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            zeroOffBtn.heightAnchor.constraint(equalToConstant: 50),
            zeroOffBtn.widthAnchor.constraint(equalToConstant: 203)
        ])
    }
    
    func setupAddBtn() {
        let image = UIImage(named: "btn_add-new")
        
        addContainerView.backgroundColor = UIColor.mpWhite
        
        addConsumeBtn.setImage(image, for: .normal)
        addConsumeBtn.setTitle("소비내역 추가하기", for: .normal)
        addConsumeBtn.setTitleColor(.mpBlack, for: .normal)
        addConsumeBtn.titleLabel?.font = UIFont.mpFont18B()
        
        let intervalSpacing = 16.0
        let halfIntervalSpacing = intervalSpacing / 2
        
        addConsumeBtn.contentEdgeInsets = .init(top: 0, left: halfIntervalSpacing, bottom: 0, right: halfIntervalSpacing)
        addConsumeBtn.imageEdgeInsets = .init(top: 0, left: -halfIntervalSpacing, bottom: 0, right: halfIntervalSpacing)
        addConsumeBtn.titleEdgeInsets = .init(top: 0, left: halfIntervalSpacing, bottom: 0, right: -halfIntervalSpacing)
        
        addContainerView.translatesAutoresizingMaskIntoConstraints = false
        addConsumeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addContainerView)
        addContainerView.addSubview(addConsumeBtn)
        
        NSLayoutConstraint.activate([
            addContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            addContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            addContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            addContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            addConsumeBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addConsumeBtn.leadingAnchor.constraint(equalTo: addContainerView.leadingAnchor, constant: 20),
            addConsumeBtn.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        let borderView = UIView()
        borderView.backgroundColor = UIColor.mpLightGray
        borderView.translatesAutoresizingMaskIntoConstraints = false
        addContainerView.addSubview(borderView)
        
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: addContainerView.topAnchor),
            borderView.leadingAnchor.constraint(equalTo: addContainerView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: addContainerView.trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    
}

class memoLabel: UILabel {
    override var text: String? {
        didSet {
            updateTextSpacing()
        }
    }
    
    private func updateTextSpacing() {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3 // 줄간격 조정
        let letterSpacing = -0.02 * self.font.pointSize // 글자 크기의 -2%
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: text.count))
        self.attributedText = attributedString
        
    }
}

class historyCell : UITableViewCell {
    
    static let cellId = "CellId"
    
    let category = UIImageView()
    let name = MPLabel()
    let priceAmount = MPLabel()
    let memoText = memoLabel()
    let separatorView = UIView() //구분선
    
    //var memoTextHeight: CGFloat = 23
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        name.font = UIFont.mpFont18B()
        name.textColor = UIColor.mpBlack
        
        priceAmount.font = UIFont.mpFont16R()
        priceAmount.textColor = UIColor.mpDarkGray
        
        memoText.font = UIFont.mpFont14R()
        memoText.textColor = UIColor.mpDarkGray
        
        separatorView.backgroundColor = UIColor.mpLightGray
        
        self.addSubview(category)
        self.addSubview(name)
        self.addSubview(priceAmount)
        self.addSubview(memoText)
        self.addSubview(separatorView)
        
        memoText.numberOfLines = 0
        memoText.lineBreakMode = .byCharWrapping
        memoText.adjustsFontSizeToFitWidth = false
        memoText.sizeToFit()
        
        category.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        priceAmount.translatesAutoresizingMaskIntoConstraints = false
        memoText.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            category.topAnchor.constraint(equalTo: topAnchor),
            category.leftAnchor.constraint(equalTo: leftAnchor),
            category.heightAnchor.constraint(equalToConstant: 44),
            category.widthAnchor.constraint(equalToConstant: 44),
            
            name.topAnchor.constraint(equalTo: topAnchor),
            name.leftAnchor.constraint(equalTo: category.rightAnchor, constant: 10),
            name.rightAnchor.constraint(equalTo: rightAnchor),
            name.heightAnchor.constraint(equalToConstant: 23),
            
            priceAmount.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 3),
            priceAmount.leftAnchor.constraint(equalTo: category.rightAnchor, constant: 10),
            priceAmount.rightAnchor.constraint(equalTo: rightAnchor),
            priceAmount.heightAnchor.constraint(equalToConstant: 24),
            
            separatorView.topAnchor.constraint(equalTo: priceAmount.bottomAnchor, constant: 10),
            separatorView.leftAnchor.constraint(equalTo: category.rightAnchor, constant: 10),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            memoText.topAnchor.constraint(equalTo: priceAmount.bottomAnchor, constant: 20),
            memoText.leftAnchor.constraint(equalTo: category.rightAnchor, constant: 10),
            memoText.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
    }
    
    func configureSeparatorViewVisibility(isVisible: Bool) {
        separatorView.isHidden = !isVisible
    }
}



struct Consumption {
    let title: String
    let category: String
    let price: Int
    let memo: String
}

extension Consumption {
    static var data = [
        Consumption(title: "올리브영 세일", category: "icon_Edit", price: 25200, memo: "올영 빅세일 참지 못하고 또... 그래도 마스크팩 필요했는데 쟁여서 기쁘다"),
        Consumption(title: "스타벅스 아메리카노", category: "icon_Paper", price: 4500, memo: ""),
        Consumption(title: "스타벅스 녹차", category: "icon_Edit", price: 5100, memo: "룰렛돌리기 져서 내가 민정이 음료도 사줌")
    ]
}
