//
//  ExpensePopupModalView.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/17/24.
//

import Foundation
import UIKit
import ImageIO
//import Gifu

extension UIImage {
    static func loadGif(name: String) -> UIImage? {
        guard let gifUrl = Bundle.main.url(forResource: name, withExtension: "gif") else {
            return nil
        }
        
        guard let imageData = try? Data(contentsOf: gifUrl) else {
            return nil
        }
        
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            return nil
        }
        
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
        }
        
        return UIImage.animatedImage(with: images, duration: TimeInterval(count) * 0.1)
    }
}

protocol ExpensePopupDelegate : AnyObject {
    func popupChecked()
}
class ExpensePopupModalView : UIViewController {
        
        var dateText = ""
        var rateInfo : RateInfo?
    weak var delegate : ExpensePopupDelegate?
        //amount = 목표금액 - 쓴금액
        var amount = 3000 //임시값
        
        let customModal = UIView(frame: CGRect(x: 0, y: 0, width: 322, height: 400))
        
        let titleLabel: MPLabel = {
            let label = MPLabel()
            label.text = ""
            label.numberOfLines = 0
            label.font = UIFont.mpFont20B()
            
            return label
        }()
        
        let contentLabel : UnregisterTitleLabel = {
            let label = UnregisterTitleLabel()
            label.text = ""
            label.numberOfLines = 2
            label.lineSpacing = 2.0
            label.font = UIFont.mpFont16M()
            
            return label
        }()
        
        let ImageView : UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()

        
        let completeButton : UIButton = {
            let button = UIButton()
            button.setTitle("확인", for: .normal)
            button.setTitleColor(UIColor.mpWhite, for: .normal)
            button.backgroundColor = UIColor.mpMainColor
            button.layer.cornerRadius = 12
            button.clipsToBounds = true
            
            return button
        }()
        
        // 모달 제목 바꾸는 함수
        func changeTitle(title : String){
            titleLabel.text = title
        }
    
        // 모달 내용 바꾸는 함수
        func changeContents (content : String){
            contentLabel.text = content
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            presentCustomModal()
            setupBackground()
            setupView()
            DispatchQueue.main.async {
                if let gifImage = UIImage.loadGif(name: "muffler_surprised") {
                    self.ImageView.image = gifImage // 이미지 뷰에 GIF 이미지 설정
                }
            }

            completeButton.addTarget(self, action: #selector(complete), for: .touchUpInside)
        }
    @objc private func complete(){
        delegate?.popupChecked()
        dismiss(animated: true)
    }
        
        func presentCustomModal() {
            customModal.backgroundColor = UIColor.mpWhite
            view.addSubview(customModal)
            customModal.center = view.center
            
        }
        
        
        private func setupBackground() {
            customModal.layer.cornerRadius = 25
            customModal.layer.masksToBounds = true
        }

        private func setupView() {
            customModal.addSubview(titleLabel)
            customModal.addSubview(contentLabel)

            titleLabel.textAlignment = .center
            contentLabel.textAlignment = .center
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            contentLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 35),
                titleLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
                
                contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
                contentLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor)
                
            ])
            
            ImageView.translatesAutoresizingMaskIntoConstraints = false
            completeButton.translatesAutoresizingMaskIntoConstraints = false
            
            customModal.addSubview(ImageView)
            customModal.addSubview(completeButton)
            
            NSLayoutConstraint.activate([
                ImageView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
                ImageView.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
                ImageView.heightAnchor.constraint(equalToConstant: 174),
                ImageView.widthAnchor.constraint(equalToConstant: 174),
                
                completeButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -15),
                completeButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 15),
                completeButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -15),
                completeButton.heightAnchor.constraint(equalToConstant: 58)
            ])
        }
        
      

    }
