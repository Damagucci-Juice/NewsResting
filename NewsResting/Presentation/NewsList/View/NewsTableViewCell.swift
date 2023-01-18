//
//  NewsTableViewCell.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/18.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    private lazy var title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewsTableViewCell {
    
    func setupConstraint() {
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            title.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func fill(_ viewModel: NewsViewModel) {
        self.title.text = viewModel.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.title.text = .none
    }
}
