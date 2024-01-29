import Foundation
import UIKit

class CategoryCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mpGypsumGray
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mpFont14M()
        label.textColor = UIColor.black // Change the text color to black
        label.textAlignment = .center // Center the text within the label
        return label
    }()
    
    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        // 이미지뷰를 원 모양으로 자르기
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        //
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        addSubview(containerView)
        
        containerView.addSubview(categoryImageView)
        containerView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor),
            categoryImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            categoryImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            categoryImageView.widthAnchor.constraint(equalToConstant: 32),
            categoryImageView.heightAnchor.constraint(equalToConstant: 32),
            categoryLabel.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func configure(with category: CategoryModalViewController.Category) {
        categoryLabel.text = category.name
        // Uncomment the following line if you want to set an image
        categoryImageView.image = UIImage(systemName: category.imageName)
    }
}

