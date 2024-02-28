//
//  RoutineDetailViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/21/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


// 소비 수정 및 삭제 컨트롤러
class RoutineDetailViewController : UIViewController, UITextFieldDelegate {


    var routineId: Int64? = 0
    var initRoutine : GetRoutineIdResponse.RoutineDetail?
    var currentCategoryId : Int64 = 0
    let StackView = UIStackView()

    // api 연결
    let disposeBag = DisposeBag()
    let viewModel = MufflerViewModel()
    var expenseRequest : UpdateExpenseRequest = UpdateExpenseRequest(expenseId: 0, expenseCost: 0, categoryId: 0, expenseTitle: "", expenseMemo: "", expenseDate: "")
    
    var currentAmount : Int64? = 0
    // 반복
    var routineRequest : ExpenseCreateRequest.RoutineRequest?
    //
    var currentTitle : String?  = ""
    var currentMemo : String? = ""
    var currnetCatIcon : String? = ""
    
    let resultbutton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitleColor(.mpDarkGray, for: .normal)
        button.titleLabel?.font = UIFont.mpFont16M()
        button.tintColor = UIColor.mpMainColor
        //button.backgroundColor = .mpGypsumGray // 수정 - 근영/ 텍스트 필드 배경 색상 F6F6F6
        button.setTitle("", for: .normal)
        button.isEnabled = false

        return button
    }()
    // 소비 등록 여부 확인 (메모 제외)
    var amountAdd = false
    var catAdd = false
    var titleAdd = false
    
    weak var delegate : ConsumeDetailViewDelegate?
    
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    lazy var todayDate: String = {
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: currentDate)
    }()
    private lazy var headerView = HeaderView(title: "반복 소비내역 조회")
    private var completeButton = MainBottomBtn(title: "확인")
    //소비금액 입력필드 추가
    
    private let amountTextField: UITextField = MainTextField(placeholder: "소비금액을 입력하세요", iconName: "icon_Wallet", keyboardType: .numberPad)

    // 소비금액 실시간 금액 표시
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "0원"
        label.font = UIFont.mpFont14M()
        label.textColor = UIColor.mpDarkGray
        return label
    }()
    // 제목 에러 표시
    private let titleErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "\t 최대 16글자로 입력해주세요"
        label.font = .mpFont14M()
        label.textColor = UIColor.mpRed
        return label
    }()


    let catContainerView = TextFieldContainerView()
    let calContainerView = TextFieldContainerView()
    
    let titleDeleteContainer : UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .leading
        return v
    }()
    let memoDeleteContainer : UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .leading
        return v
    }()
    let cateogoryTextField = MainTextField(placeholder: "카테고리를 입력해주세요", iconName: "icon_category" , keyboardType: .default)
    
   
    // 카테고리 선택 버튼 추가
    lazy var categoryChooseButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(systemName:"chevron.down")?.withTintColor(.mpBlack, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false  // 클릭 활성화
        return button
        
    }()
    
 
    let deleteButton: UIButton = {
        let arrowImage = UIImage(systemName: "xmark")?.withTintColor(.mpWhite, renderingMode: .alwaysOriginal)
        let button = UIButton()
        button.setImage(arrowImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.backgroundColor = .mpMidGray
        button.layer.cornerRadius = 9
        button.layer.masksToBounds = true
        
        return button
    }()
   
  
    private let titleTextField = MainTextField(placeholder: "제목", iconName: "icon_Paper", keyboardType: .default)
    private let memoTextField = MainTextField(placeholder: "메모", iconName: "icon_Edit", keyboardType: .default)
    
    
    let containerview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
   

    
    // 이니셜라이저를 정의하여 expenseId를 전달 받을 수 있도록 합니다.
    init(routineId : Int64?, title : String?, categoryIcon : String?, cost : Int64?) {
        self.routineId = routineId
        super.init(nibName: nil, bundle: nil)
        // 네트워크 요청을 통해 초기 데이터를 가져옵니다.
        if let routineId = routineId {
            viewModel.getRoutine(routineId: routineId)
                .subscribe(onNext: { [weak self] reponse in
                    // 네트워크 응답에 대한 처리
                    print("루틴 내역 불러오기 성공!")
                    print(reponse)
                    self?.initRoutine = reponse.result
                    self?.cateogoryTextField.text = self?.initRoutine?.categoryName
                    self?.memoTextField.text = self?.initRoutine?.routineMemo
                    self?.titleTextField.text = title
                    self?.cateogoryTextField.changeIcon(iconName: categoryIcon ?? "icon_category")
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal // 1,000,000
                    formatter.locale = Locale.current
                    formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
                    if let cost = cost {
                            // cost가 nil이 아닌 경우에만 아래 코드 실행
                            // costString이 nil이 아닌 경우에만 아래 코드 실행
                        let costString = String(cost)
                        self?.amountTextField.text = costString
                        let changedCost : String = self?.numberToKorean(cost) ?? ""
                        self?.amountLabel.text = "\t\(changedCost)원" // 숫자 -> 한국어로 변경하여 입력함
                        
    
                    }
                    


                    

                    // 데이터를 설정하고 UI를 업데이트합니다.
                }, onError: { error in
                    // 에러 처리
                    print("Error: \(error)")
                })
                .disposed(by: disposeBag)
        }
       
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupUI()
    }
    
    private func setupUI() {
        // 배경색상 추가
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mpWhite")
        view.backgroundColor = .systemBackground
        
        
        // 완료 버튼 추가
        setupCompleteButton()
        setupLayout()
        // 헤더
        setupHeader()
        // 소비금액
        setupAmountTextField()
        // 카테고리
        setupCategoryTextField()
        // 제목
        setuptitleTextField()
        // 메모
        setupMemoTextField()
        // 반복
        setupAmountLabel()

        // 텍스트필드 접근 불가
        amountTextField.isUserInteractionEnabled = false
        cateogoryTextField.isUserInteractionEnabled = false
        titleTextField.isUserInteractionEnabled = false
        memoTextField.isUserInteractionEnabled = false

        
        
    }
  
    
    // 세팅 : 헤더
    private func setupHeader(){
        //headerView.backgroundColor = .red
        headerView.addRightButton() // 오
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addBackButtonTarget(target: self, action: #selector(previousScreen), for: .touchUpInside)  // 이전 화면으로 돌아가기
        headerView.addRightButtonTarget(target: self, action: #selector(deleteExpense), for: .touchUpInside) // 소비 내역 삭제하기
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: StackView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: StackView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    @objc private func previousScreen(){
        dismiss(animated: true)
    }
    @objc private func deleteExpense(){
        print("소비 내역 삭제하기")
        // 네트워크 요청을 통해 초기 데이터를 가져옵니다.
        if let id = routineId{
            viewModel.deleteRoutine(routineId: id)
                .subscribe(onNext: { repos in
                    // 네트워크 응답에 대한 처리
                    NotificationCenter.default.post(name: Notification.Name("changeRoutine"), object: nil)
                    print("소비 내역 삭제하기 성공!")
                    print(repos)
                }, onError: { error in
                    // 에러 처리
                    print("Error: \(error)")
                })
                .disposed(by: disposeBag)
        }
        
        dismiss(animated: true)
    }
   
    // 세팅 : 소비금액 추가
    private func setupAmountTextField() {

        NSLayoutConstraint.activate([
            amountTextField.heightAnchor.constraint(equalToConstant: 64),
            amountTextField.leadingAnchor.constraint(equalTo: StackView.leadingAnchor),
            amountTextField.trailingAnchor.constraint(equalTo: StackView.trailingAnchor)
        ])
        
        amountTextField.delegate = self
        amountTextField.translatesAutoresizingMaskIntoConstraints = false

        // 원 추가
        let infoLabel: UILabel = {
            let label = UILabel()
            label.text = "원"
            label.textColor = UIColor.mpDarkGray
            label.font = UIFont.mpFont20M()
            return label
        }()
        
        let wonContainerView = UIStackView()

        NSLayoutConstraint.activate([
   
            wonContainerView.widthAnchor.constraint(equalToConstant: 45),
            wonContainerView.heightAnchor.constraint(equalToConstant: 50),
        ])
        wonContainerView.addSubview(infoLabel)

        // Set the frame for infoLabel relative to wonContainerView
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
   
            infoLabel.leadingAnchor.constraint(equalTo: wonContainerView.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: wonContainerView.trailingAnchor),
            infoLabel.topAnchor.constraint(equalTo: wonContainerView.topAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: wonContainerView.bottomAnchor),
        ])
        // amountTextField의 rightAnchor를 이용하여 wonContainerView의 위치를 설정합니다.
        // 여백을 조절하여 텍스트 필드에서 원을 떨어뜨립니다.
        amountTextField.rightView = wonContainerView
        amountTextField.rightViewMode = .always
    
    }

    private func setupAmountLabel(){
       
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            amountLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    // 세팅 : 카테고리 텍스트 필트
    private func setupCategoryTextField(){
                NSLayoutConstraint.activate([
            
//            catContainerView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 10),
                    catContainerView.leadingAnchor.constraint(equalTo: StackView.leadingAnchor),
                    catContainerView.trailingAnchor.constraint(equalTo: StackView.trailingAnchor),
            catContainerView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        let buttonContainerView = UIView()
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
        catContainerView.addSubview(buttonContainerView)
        
        NSLayoutConstraint.activate([
            buttonContainerView.widthAnchor.constraint(equalToConstant: 40),
            buttonContainerView.heightAnchor.constraint(equalToConstant: 40),
            buttonContainerView.centerYAnchor.constraint(equalTo: catContainerView.centerYAnchor),
            buttonContainerView.trailingAnchor.constraint(equalTo: catContainerView.trailingAnchor, constant: -16)
            
            
            
        ])
        buttonContainerView.addSubview(categoryChooseButton)
        
        // 클릭 되게 하려고.... 시도 중
        buttonContainerView.isUserInteractionEnabled = false
        self.view.bringSubviewToFront(categoryChooseButton)
        categoryChooseButton.isUserInteractionEnabled = true
        buttonContainerView.layer.zPosition = 999
        
        
        NSLayoutConstraint.activate([
            categoryChooseButton.widthAnchor.constraint(equalToConstant: 40),  // 버튼의 폭 제약 조건 추가
            categoryChooseButton.heightAnchor.constraint(equalToConstant: 40), // 버튼의 높이 제약 조건 추가
            categoryChooseButton.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            categoryChooseButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            categoryChooseButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            categoryChooseButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor)
        ])
        
        buttonContainerView.addSubview(cateogoryTextField)
        cateogoryTextField.translatesAutoresizingMaskIntoConstraints = false
        cateogoryTextField.isUserInteractionEnabled = false // 수정 불가능하도록 설정
        cateogoryTextField.textColor = UIColor.mpBlack
        cateogoryTextField.text = initRoutine?.categoryName
        cateogoryTextField.backgroundColor = .clear
        NSLayoutConstraint.activate([
            
            cateogoryTextField.topAnchor.constraint(equalTo: catContainerView.topAnchor),
            cateogoryTextField.bottomAnchor.constraint(equalTo: catContainerView.bottomAnchor),
            cateogoryTextField.leadingAnchor.constraint(equalTo: catContainerView.leadingAnchor),
            cateogoryTextField.trailingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            
            
        ])
        
        
        
        
    }
    
    // 세팅 : 제목 텍스트 필트
    private func setuptitleTextField(){

        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.delegate = self
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: StackView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: StackView.trailingAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
        // 삭제 버튼 추가
        NSLayoutConstraint.activate([
   
            titleDeleteContainer.widthAnchor.constraint(equalToConstant: 45),
            titleDeleteContainer.heightAnchor.constraint(equalToConstant: 18),
        ])

        // Set the frame for infoLabel relative to wonContainerView
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //deleteButton.centerYAnchor.constraint(equalTo: titleDeleteContainer.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 18),
            deleteButton.heightAnchor.constraint(equalToConstant: 18),
           
        ])
        // amountTextField의 rightAnchor를 이용하여 wonContainerView의 위치를 설정합니다.
        // 여백을 조절하여 텍스트 필드에서 원을 떨어뜨립니다.
        titleTextField.rightView = titleDeleteContainer
        titleTextField.rightViewMode = .always
        
    }
    
    
    // 세팅 : 메모 텍스트 필트
    private func setupMemoTextField() {
        memoTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            memoTextField.leadingAnchor.constraint(equalTo: StackView.leadingAnchor),
            memoTextField.trailingAnchor.constraint(equalTo: StackView.trailingAnchor),
            memoTextField.heightAnchor.constraint(equalToConstant: 64)
        ])

    }

    
    private func setupLayout(){
        StackView.axis = .vertical
        StackView.distribution = .fill
        StackView.alignment = .leading
        StackView.spacing = 12
        
        view.addSubview(StackView)
        StackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            StackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            StackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            StackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            StackView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: 10)
        ])
        StackView.addArrangedSubview(headerView)
        StackView.addArrangedSubview(amountTextField)
        StackView.addArrangedSubview(amountLabel)
        StackView.addArrangedSubview(catContainerView)
        StackView.addArrangedSubview(titleTextField)
        StackView.addArrangedSubview(memoTextField)

        let blank = UIView()
        StackView.addArrangedSubview(blank)


    }
    // 세팅 : 완료 버튼
    private func setupCompleteButton(){
        completeButton.isEnabled = true
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)    }
  
    
    // 숫자 천단위로 끊는 함수
    func formatAmount(_ amountString: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let number = formatter.number(from: amountString)?.intValue {
            let formattedAmount = formatter.string(from: NSNumber(value: number))
            return formattedAmount
        }

        return nil
    }
    
    //숫자를 한글로 표현하는 함수(2000 -> 0부터 9999999999999999까지가능)
    func numberToKorean(_ number: Int64) -> String {
        let unitLarge = ["", "만", "억", "조"]
        
        var result = ""
        var num = number
        var unitIndex = 0
        
        while num > 0 {
            let segment = num % 10000
            if segment != 0 {
                result = "\((segment))\(unitLarge[unitIndex]) \(result)"
            }
            num /= 10000
            unitIndex += 1
        }
        
        return result.isEmpty ? "0" : result
    }
    

    
    @objc
    private func completeButtonTapped(){
        print("확인이 완료되었습니다")
        dismiss(animated: true)
    }
}

