//
//  DetailNewsViewController.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/20.
//

import UIKit
import SnapKit

class DetailNewsViewController: UIViewController {

    private let viewModel: NewsItemViewModel
    private let imageRepository = ImageRepositoryImpl()
    private var isFetchImageSussecc = true
    
    private lazy var imageView = UIImageView()
    private var imageViewHeight: Constraint?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    init(newsItemViewModel: NewsItemViewModel) {
        self.viewModel = newsItemViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttribute()
        fillContents()
    }
}

extension DetailNewsViewController {
    private func setupLayout() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            self.imageViewHeight = make.height.equalTo(300).constraint
        }
    }
    
    private func setupAttribute() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .gray
        view.backgroundColor = .white
    }
    
    private func fillContents() {
        Task {
            if let imagePath = viewModel.imagePath {
                let start = Date.timeIntervalSinceReferenceDate
                let data = try await imageRepository.fetchImage(path: imagePath)
                imageView.image = UIImage(data: data)
            } else {
                //MARK: ImageView 조정
                closeImageView()
            }
        }
        titleLabel.text = viewModel.title
    }
    
    private func closeImageView() {
        self.imageViewHeight?.update(offset: 0)
        view.layoutIfNeeded()
    }
}
