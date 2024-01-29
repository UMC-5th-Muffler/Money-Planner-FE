//
//  RepeatIntervalViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/28/24.
//

import Foundation
import UIKit

protocol RepeatIntervalDelegate : AnyObject{
    func didIntervalSelected(_ Interval: String,_ num : Int)
}
class RepeatIntervalViewController : UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    weak var delegate: RepeatIntervalDelegate?
    
    // 뷰 변경을 위한 NSLayoutConstraint
    var dayContainerViewBottomConstraint: NSLayoutConstraint?
    var dateContainerViewBottomConstraint: NSLayoutConstraint?
    var ChooseDayHeightConstraint : NSLayoutConstraint?
    var ChooseDateHeightConstraint : NSLayoutConstraint?
    var lineConstraint : NSLayoutConstraint?
    var containerViewBottomConstraint : NSLayoutConstraint?
    
    
    var pickerView: UIPickerView!
    var returnValue : Int = 0
    var intervals = ["1주마다 반복", "2주마다 반복", "3주마다 반복"]
    var return2 = [""]
    var type : Int = 0
    
    

    let customModal = UIView(frame: CGRect(x: 0, y: 0, width: 361, height: 343))
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "언제 반복할까요?"
        label.textAlignment = .center
        label.font = UIFont.mpFont20B()
        return label
    }()
    let containerView = UIView()

  
    let cancelNcomplte = SmallBtnView()
    
    // 날짜 선택 시 나오는 화면
    // 모달 제목 바꾸는 함수
    func changeTitle(title : String){
        titleLabel.text = title
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presentCustomModal()
        setupBackground()
        setuptitleLabel()
        setupCancelNComplte()
        setupRepeatView()
    
        // 요일 선택
     

    }
    func presentCustomModal() {
        // Instantiate your custom modal view
        customModal.backgroundColor = UIColor.mpWhite
        view.addSubview(customModal)
        customModal.center = view.center
        
    }
    private func setupBackground() {
        customModal.backgroundColor = .white
        customModal.layer.cornerRadius = 25
        customModal.layer.masksToBounds = true
    }
    
    private func setuptitleLabel() {
        let modalBar = UIView()
        modalBar.layer.cornerRadius = 8
        modalBar.backgroundColor = .mpLightGray
        
        customModal.addSubview(modalBar)
        customModal.addSubview(titleLabel)
        modalBar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modalBar.widthAnchor.constraint(equalToConstant: 49),
            modalBar.heightAnchor.constraint(equalToConstant: 4),
            modalBar.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 12),
            modalBar.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            titleLabel.topAnchor.constraint(equalTo: modalBar.bottomAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
        ])
        
        
        
    }
    
   
    
    private func setupCancelNComplte(){
        
        customModal.addSubview(cancelNcomplte)
        cancelNcomplte.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelNcomplte.bottomAnchor.constraint(equalTo: customModal.bottomAnchor,constant: -20),
            cancelNcomplte.heightAnchor.constraint(equalToConstant: 56),
            cancelNcomplte.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            cancelNcomplte.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20),
        ])
        cancelNcomplte.addCancelAction(target: self, action: #selector(cancelButtonTapped))
        cancelNcomplte.addCompleteAction(target: self, action: #selector(completeButtonTapped))
    }
    
    

    private func setupRepeatView() {
           containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
           customModal.addSubview(containerView)
           containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: cancelNcomplte.topAnchor, constant: -60)
           NSLayoutConstraint.activate([
               containerView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
               containerView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -24),
               containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
               containerView.heightAnchor.constraint(equalToConstant: 103),
               containerViewBottomConstraint!
           ])
           
           // UIPickerView 설정
           pickerView = UIPickerView()
           pickerView.delegate = self
           pickerView.dataSource = self
           pickerView.translatesAutoresizingMaskIntoConstraints = false
        
           containerView.addSubview(pickerView)
           
           NSLayoutConstraint.activate([
               pickerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
               pickerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
               pickerView.topAnchor.constraint(equalTo: containerView.topAnchor),
               pickerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
           ])
       }
       
       // MARK: - UIPickerViewDataSource

       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return intervals.count
       }

       // MARK: - UIPickerViewDelegate

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           
           return intervals[row]
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           
           returnValue = row
           let selectedInterval = intervals[row]
           print(returnValue)
           print("Selected Interval: \(selectedInterval)")
           // 선택된 항목을 처리하거나 delegate를 통해 전달할 수 있습니다.
       }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
           var label: UILabel

           if let view = view as? UILabel {
               label = view
           } else {
               label = UILabel()
           }

           label.text = intervals[row]
            label.font = UIFont.mpFont20B()// 원하는 글꼴 및 크기로 변경
           label.textAlignment = .center
           return label
       }

    @objc private func cancelButtonTapped() {
        print("취소 버튼이 탭되었습니다.")
        // 취소 버튼 액션 처리
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func completeButtonTapped() {
        print("완료 버튼이 탭되었습니다.")
        print(returnValue)
        var  stirngReturnValue = ""
        if type == 1{
            print("요일 선택 화면에서 작업 중 ...")
            print(returnValue)
            stirngReturnValue = "\(returnValue+1)"

        }
        if type == 2{
            print("날짜 선택 화면에서 작업 중 ...")
            print(return2)
            print(returnValue)
            stirngReturnValue = return2[returnValue]

        }
        print("반복 버튼 완료 : 결과) \(stirngReturnValue)")
        print(type)
        delegate?.didIntervalSelected(stirngReturnValue, type)
        // 완료 버튼 액션 처리
        dismiss(animated: true, completion: nil)
    }
    
    
}


