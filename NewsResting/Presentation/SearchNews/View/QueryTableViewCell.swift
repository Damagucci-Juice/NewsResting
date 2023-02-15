//
//  QueryTableViewCell.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/15.
//

import UIKit

class QueryTableViewCell: UITableViewCell {
    private let queryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(queryLabel)
        
        queryLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
        }
    }
    
    public func fillUp(_ query: String) {
        self.queryLabel.text = query
    }
}

