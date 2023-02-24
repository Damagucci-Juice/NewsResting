//
//  SearchToolViewController.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/24.
//

import UIKit
import SnapKit

final class SearchToolViewController: UIViewController {
    private var onTappedDoneButton: (DetailSearchRequestValue) -> Void = { _ in }
    private var detailSearchRequestValue: DetailSearchRequestValue
    
    private var includeTerm: UILabel = {
        let label = UILabel()
        label.text = "include searchTerm".localized()
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var includeArea: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill  // 이 상당히 야무진 이놈을 어떻게 하면 좋을까???
        view.spacing = 4
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private var excludeArea: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillProportionally
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.setTitleColor(UIColor.tintColor, for: .normal)
        return button
    }()
    
    private var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.setTitleColor(UIColor.red, for: .disabled)
        return button
    }()
    
    private var excludeTerm: UILabel = {
        let label = UILabel()
        label.text = "exclude searchTerm".localized()
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var periodLabel: UILabel = {
        let label = UILabel()
        label.text = "period".localized()
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var fromButton: UIButton = {
        let button = UIButton()
        button.setTitle("from".localized(), for: .normal)
        return button
    }()
    
    private var toButton: UIButton = {
        let button = UIButton()
        button.setTitle("to".localized(), for: .normal)
        return button
    }()
    
    init(detailSearchRequestValue: DetailSearchRequestValue? = nil) {
        if let detailSearchRequestValue {
            self.detailSearchRequestValue = detailSearchRequestValue
        } else {
            self.detailSearchRequestValue = DetailSearchRequestValue()
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        setupNavigation()
        setupLayout()
        setupAttribute()
    }
        
    @objc func injectToolViewModel() {
        onTappedDoneButton(detailSearchRequestValue)
        Task {
            self.dismiss(animated: true)
        }
    }
}

//MARK: - Private
extension SearchToolViewController {
    private func setupNavigation() {
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Done",
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(injectToolViewModel)),
                                         animated: false)
        self.title = "검색 상세 조건"
    }
    
    private func setupLayout() {
        let constraintFromWall: CGFloat = 15
        let areaSpace: CGFloat = 50
        
        [
            includeTerm, plusButton, includeArea,
            excludeTerm, minusButton, excludeArea,
            periodLabel, fromButton, toButton
        ].forEach { view in
            self.view.addSubview(view)
        }
        
        includeTerm.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(constraintFromWall)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(constraintFromWall)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(includeTerm)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(constraintFromWall)
            make.bottom.equalTo(includeTerm)
            make.width.equalTo(plusButton.snp.height)
        }
        
        includeArea.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(constraintFromWall)
            make.top.equalTo(includeTerm.snp.bottom).offset(constraintFromWall)
            make.height.equalTo(areaSpace)
        }
        
        excludeTerm.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(constraintFromWall)
            make.top.equalTo(includeArea.snp.bottom).offset(constraintFromWall)
        }
        
        minusButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(constraintFromWall)
            make.top.equalTo(excludeTerm)
            make.bottom.equalTo(excludeTerm)
            make.width.equalTo(minusButton.snp.height)
        }
        
        excludeArea.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(constraintFromWall)
            make.top.equalTo(excludeTerm.snp.bottom).offset(constraintFromWall)
            make.height.equalTo(areaSpace)
        }
        
        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(excludeArea.snp.bottom).offset(constraintFromWall)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(constraintFromWall)
        }
        
        fromButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(constraintFromWall)
            make.top.equalTo(periodLabel.snp.bottom).offset(constraintFromWall)
        }
        
        toButton.snp.makeConstraints { make in
            make.top.equalTo(fromButton)
            make.leading.equalTo(fromButton.snp.trailing).offset(constraintFromWall)
        }
    }
    
    private func setupAttribute() {
        
        
        plusButton.addAction(UIAction(handler: { _ in
            let alert = UIAlertController(title: "alert", message: "textField", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default) {[unowned self] _ in
                
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.backgroundColor = .blue
                button.frame = .zero
                button.setTitle(alert.textFields?[0].text, for: .normal)
                button.layer.cornerRadius = 10
                button.addAction(UIAction(handler: { _ in
                    Task {
                        button.removeFromSuperview()
                    }
                }), for: .touchUpInside)
                self.includeArea.addArrangedSubview(button)
            }
            
            let cancel = UIAlertAction(title: "cancel", style: .cancel)
            alert.addTextField { textField in
                textField.placeholder = "검색어를 입력하세요."
            }
            
            alert.addAction(cancel)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }), for: .touchUpInside)
        
        fromButton.addAction(UIAction(handler: { _ in
            print("from button tapped")
        }), for: .touchUpInside)
        
        toButton.addAction(UIAction(handler: { _ in
            print("To button tapped")
        }), for: .touchUpInside)
        
        [includeArea, excludeArea].forEach { area in
            area.layer.cornerRadius = 10
        }
        
        
    }
}


//MARK: - Public
extension SearchToolViewController {
    func bidnig(completion: @escaping (DetailSearchRequestValue) -> Void) {
        onTappedDoneButton = completion
    }
}
