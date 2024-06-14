//
//  File.swift
//  SwiftApp
//
//  Created by KUN on 2024/6/7.
//

import SnapKit
import UIKit

extension UIView {
    func setBorderWidth(width: CGFloat = 1.0 / UIScreen.main.scale, color: UIColor = .gray) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }

    // 添加底部横线
    func addBottomLineView(color: UIColor = .gray, lineHeight: CGFloat = 1.0 / UIScreen.main.scale) {
        let bottomLine = UIView()
        bottomLine.backgroundColor = color
        bottomLine.frame = CGRect(x: 0, y: self.bounds.height - lineHeight, width: self.bounds.width, height: lineHeight)
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.height.equalTo(lineHeight)
            make.left.bottom.right.equalTo(0)
        }
    }

    func addBottomLineLayer(withColor lineColor: UIColor = .lightGray, lineHeight: CGFloat = 1.0 / UIScreen.main.scale) {
        let lineLayer = CALayer()
        lineLayer.backgroundColor = lineColor.cgColor
        let lineFrame = CGRect(x: 0, y: self.bounds.height - lineHeight, width: self.bounds.width, height: lineHeight)
        lineLayer.frame = lineFrame
        self.layer.addSublayer(lineLayer)
    }
}
