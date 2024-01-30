//
//  cell.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/30/24.
//

import Foundation
import UIKit
class MyPageTableViewCell: UITableViewCell {

    // 셀에 추가할 이미지 뷰
    let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName:"pencil") // 이미지 이름을 적절히 변경
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // 셀에 이미지 뷰를 추가
        addSubview(cellImageView)

        // 이미지 뷰에 대한 제약 조건 설정
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: topAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellImageView.widthAnchor.constraint(equalToConstant: 60) // 이미지 뷰의 폭 조정
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
