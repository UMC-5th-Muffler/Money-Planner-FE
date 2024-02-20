//
//  EvaluationViewController.swift
//  Money-Planner
//
//  Created by Jini on 2024/01/12.
//

import Foundation
import UIKit

class EvaluationViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var dateText = ""
    var rateInfo : RateInfo?
    
    let descriptionView = DescriptionView(text: "오늘의 소비를\n스스로 평가해주세요", alignToCenter: false)
    
    let estimationLabel : MPLabel = {
        let label = MPLabel()
        label.text = "종합적 평가"
        label.font = UIFont.mpFont16B()
        label.textColor = UIColor(named:"black")
        
        return label
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        
        return myCollectionView
    }()
    
    
    let diaryLabel : UILabel = {
        let label = UILabel()
        label.text = "오늘의 소비 일기 (선택)"
        label.font = UIFont.mpFont16B()
        label.textColor = UIColor(named:"black")
            
        return label
    }()
    
    let placeholder = "오늘 하루 소비가 어땠나요?"
        
    let diaryTextView : UITextView = {
        let textview = UITextView()
        textview.backgroundColor = UIColor.mpGypsumGray
        textview.layer.cornerRadius = 20
        textview.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textview.font = UIFont.mpFont16M()
        textview.textColor = UIColor.mpCharcoal
        textview.tintColor = UIColor.mpMainColor
            
        return textview
    }()
        
    let numLabel : UILabel = {
        let label = UILabel()
        label.text = "0/100"
        label.textColor = UIColor.mpDarkGray
        label.font = UIFont.mpFont14M()
            
        return label
    }()
    
    let confirmBtn = MainBottomBtn(title: "확인")
    
    override func viewDidLoad(){
        view.backgroundColor = UIColor.mpWhite
        
        fetchRateData()
        presentCustomModal()
        
        setupNavigationBar()
        setupDescription()
        setupTotalEstimation()
        setupDiary()
        setupConfirmButton()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(estimateCell.self, forCellWithReuseIdentifier: "Cell")
        
        diaryTextView.delegate = self
        diaryTextView.text = placeholder
        diaryTextView.textColor = UIColor.mpGray
        
        //diaryTextView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) /// 화면을 누르면 키보드 내리기
    }
    
    private func presentCustomModal() {
        // CustomModal을 띄웁니다.
        let customModalVC = evaluationModalView()
        customModalVC.dateText = dateText
        customModalVC.modalPresentationStyle = .overFullScreen
        customModalVC.modalTransitionStyle = .crossDissolve
        present(customModalVC, animated: true, completion: nil)
        
        // completeButton을 눌렀을 때 모달을 닫는 기능을 추가
        customModalVC.completeButton.addTarget(self, action: #selector(dismissCustomModal), for: .touchUpInside)
    }
    
    @objc private func dismissCustomModal() {
         // 모달 닫기
         dismiss(animated: true, completion: nil)
     }
    
}

extension EvaluationViewController : UITextViewDelegate {

    func setupNavigationBar() {
        self.navigationItem.title = "평가"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mpBlack, NSAttributedString.Key.font: UIFont.mpFont18B()]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func setupDescription() {
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionView)
        
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 36),
            
            descriptionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            descriptionView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    func setupTotalEstimation() {
        estimationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(estimationLabel)
        view.addSubview(myCollectionView)
        
        NSLayoutConstraint.activate([
            estimationLabel.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 40),
            
            estimationLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            estimationLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            estimationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            myCollectionView.topAnchor.constraint(equalTo: estimationLabel.bottomAnchor, constant: 12),
            myCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            myCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            myCollectionView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
    }
    
    func setupDiary() {
        diaryTextView.text = placeholder // 기본적으로 placeholder 표시

        if let rateMemo = rateInfo?.rateMemo, !rateMemo.isEmpty {
            diaryTextView.text = rateMemo // rateMemo가 비어 있지 않으면 내용을 표시
        }
        numLabel.text = "\(diaryTextView.text.count)/100"
        
        diaryLabel.translatesAutoresizingMaskIntoConstraints = false
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        numLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(diaryLabel)
        view.addSubview(diaryTextView)
        view.addSubview(numLabel)

        NSLayoutConstraint.activate([
            diaryLabel.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor, constant: 60),

            diaryLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            diaryLabel.heightAnchor.constraint(equalToConstant: 20),
            
            diaryTextView.topAnchor.constraint(equalTo: diaryLabel.bottomAnchor, constant: 12),
            diaryTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            diaryTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            diaryTextView.heightAnchor.constraint(equalToConstant: 128),
            
            numLabel.topAnchor.constraint(equalTo: diaryTextView.bottomAnchor, constant: 4),
            numLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            numLabel.heightAnchor.constraint(equalToConstant: 23),
        ])
    }
    
    func setupConfirmButton(){
        confirmBtn.isEnabled = false
        
        confirmBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmBtn)
        
        NSLayoutConstraint.activate([
            confirmBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            confirmBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            confirmBtn.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        confirmBtn.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func confirmButtonTapped() {
        rateConsume()
        navigationController?.popViewController(animated: true)
    }
    
    private func getSelectedRate() -> String? {
        guard let selectedIndexPath = myCollectionView.indexPathsForSelectedItems?.first else {
            // 선택된 셀이 없는 경우에 대한 처리
            return nil
        }
        
        switch selectedIndexPath.item {
        case 0:
            return "LOW"
        case 1:
            return "MEDIUM"
        case 2:
            return "HIGH"
        default:
            return nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        confirmBtn.isEnabled = true
        
        if let cell = collectionView.cellForItem(at: indexPath) as? estimateCell {
             switch indexPath.item {
             case 0:
                 cell.imageView.image = UIImage(named: "btn_evaluation_red_on")
             case 1:
                 cell.imageView.image = UIImage(named: "btn_evaluation_yellow_on")
             case 2:
                 cell.imageView.image = UIImage(named: "btn_evaluation_green_on")
             default:
                 break
             }
             cell.stateLabel.textColor = UIColor.mpCharcoal
             cell.stateLabel.font = UIFont.mpFont14B()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? estimateCell {
             switch indexPath.item {
             case 0:
                 cell.imageView.image = UIImage(named: "btn_evaluation_red_off")
             case 1:
                 cell.imageView.image = UIImage(named: "btn_evaluation_yellow_off")
             case 2:
                 cell.imageView.image = UIImage(named: "btn_evaluation_green_off")
             default:
                 break
             }
             cell.stateLabel.textColor = UIColor.mpDarkGray
            cell.stateLabel.font = UIFont.mpFont14R()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! estimateCell
        
        switch indexPath.item {
        case 0:
            cell.imageView.image = UIImage(named: "btn_evaluation_red_off")
            cell.stateLabel.text = "아쉬워요"
        case 1:
            cell.imageView.image = UIImage(named: "btn_evaluation_yellow_off")
            cell.stateLabel.text = "그럭저럭"
        case 2:
            cell.imageView.image = UIImage(named: "btn_evaluation_green_off")
            cell.stateLabel.text = "잘했어요"
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 60, height: 90)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            diaryTextView.textColor = UIColor.mpCharcoal
            diaryTextView.text = placeholder
        }
        else if textView.text == placeholder {
            diaryTextView.textColor = UIColor.mpGray
            diaryTextView.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        /// 글자 수 제한
        if diaryTextView.text.count > 100 {
            numLabel.textColor = UIColor.red
            diaryTextView.layer.borderWidth = 1
            diaryTextView.layer.borderColor = UIColor.red.cgColor
            confirmBtn.isEnabled = false
        }
        else {
            numLabel.textColor = UIColor.mpDarkGray
            diaryTextView.layer.borderWidth = 0
            
            confirmBtn.isEnabled = !diaryTextView.text.isEmpty && getSelectedRate() != nil
        }
        
        numLabel.text = "\(diaryTextView.text.count)/100"
        
        diaryTextView.textColor = UIColor.mpCharcoal
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == placeholder {
            diaryTextView.textColor = UIColor.mpGray
            diaryTextView.text = placeholder
            numLabel.textColor = UIColor.mpDarkGray
            numLabel.text = "0/100"
        }
        else if diaryTextView.text.count > 100 {
            numLabel.textColor = UIColor.red
            diaryTextView.layer.borderWidth = 1
            diaryTextView.layer.borderColor = UIColor.red.cgColor
        }
        else {
            diaryTextView.textColor = UIColor.mpCharcoal
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let tempText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = tempText.count
        return numberOfChars <= 101
    }
    
    func fetchRateData() {
        let date = dateText
        ExpenseRepository.shared.getRateInformation(date: date) { result in
            switch result {
            case .success(let data):
                print(data)
                self.rateInfo = data!
                
                DispatchQueue.main.async {
                    if let rateMemo = self.rateInfo?.rateMemo, !rateMemo.isEmpty {
                        self.diaryTextView.text = rateMemo
                        self.diaryTextView.textColor = UIColor.mpCharcoal
                    } else {
                        self.diaryTextView.text = self.placeholder
                        self.diaryTextView.textColor = UIColor.mpGray
                    }
                    
                    self.reloadUI()
                    self.selectCellBasedOnRate()
                }
            case .failure(let error):
                // 에러가 발생했을 때 처리
                print("Error: \(error)")
            }
        }
    }
    
    func reloadUI() {
        setupTotalEstimation()
        setupDiary()
        setupConfirmButton()
        
    }
    
    func selectCellBasedOnRate() {
        guard let rate = rateInfo?.rate else { return }
        
        // rate에 따라 셀을 선택
        var selectedIndex: Int = 0
        switch rate {
        case "HIGH":
            selectedIndex = 2
        case "MEDIUM":
            selectedIndex = 1
        case "LOW":
            selectedIndex = 0
        default:
            break
        }
        
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        myCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        collectionView(myCollectionView, didSelectItemAt: indexPath)
    }
    
    func rateConsume() {
        guard let rate = getSelectedRate() else {
            print("No rate selected")
            return
        }
        
        let rateMemo = diaryTextView.text.isEmpty ? nil : diaryTextView.text
        
        // API 호출을 통해 변경사항을 업데이트합니다.
        ExpenseRepository.shared.rateDailyConsume(date: dateText, rate: rate, rateMemo: rateMemo) { result in
            switch result {
            case .success(let updatedRateInfo):
                NotificationCenter.default.post(name: Notification.Name("changeCalendar"), object: nil)
                print("Rate daily info updated successfully: \(updatedRateInfo)")
            case .failure(let error):
                print("Failed to update rate daily info: \(error)")
            }
        }
    }

}

class estimateCell: UICollectionViewCell {
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let stateLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.mpFont14R()
        label.textColor = UIColor.mpDarkGray
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        setupViews()
    }
    
    func setupViews() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(stateLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            stateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            stateLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            stateLabel.heightAnchor.constraint(equalToConstant: 30),
            stateLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
