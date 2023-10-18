//
//  CtaLarge.swift
//  RGRG
//
//  Created by kiakim on 2023/10/13.
//

import Foundation
import UIKit
import SnapKit

class CtaLargeButton : UIView {
    
    let title: UILabel = {
        let label = UILabel()
        return label
    }()
    
    init(titleText: String) {
        self.title.text = titleText
        super.init(frame:  CGRect())
        setupUI()
    

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
//        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.systemGray
        self.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        
        self.addSubview(title)
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
}

