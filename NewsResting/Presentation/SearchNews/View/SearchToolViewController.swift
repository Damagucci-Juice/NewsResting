//
//  SearchToolViewController.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/24.
//

import UIKit

final class SearchToolViewController: UIViewController {
    private var onTappedDoneButton: (DetailSearchRequestValue) -> Void = { _ in }
    private var detailSearchRequestValue: DetailSearchRequestValue
    
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
    }
    
    func bidnig(completion: @escaping (DetailSearchRequestValue) -> Void) {
        onTappedDoneButton = completion
    }
    
    func setupNavigation() {
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Done",
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(injectToolViewModel)),
                                         animated: false)
        self.title = "검색 상세 조건"
    }
    
    
    @objc func injectToolViewModel() {
        onTappedDoneButton(detailSearchRequestValue)
        Task {
            self.dismiss(animated: true)
        }
    }
}
