//
//  CategoriesViewController.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/12.
//

import UIKit

final class CategoriesViewController: UIViewController {

    private let viewModel = CategoriesViewModel(useCase: FetchCategoriesUseCaseImpl(newsRepository: NewsRepositoryImpl(responseCache: CoreDataNewsResponseStorage())))
    
    private lazy var tableView = UITableView(frame: .zero)
    
    private lazy var shelvesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributes()
        setupLayout()
        setupBinding()
        setupNavigation()
        Task {
            try await viewModel.start()
            tableView.reloadData()
        }
    }
}

extension CategoriesViewController {
    private func setupAttributes() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryViewItemCell.self, forCellReuseIdentifier: CategoryViewItemCell.identifier)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(shelvesStackView)
        
        shelvesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - 카테고리 버튼 클래스 도입 고려
        NewsCategory.allCases.forEach { category in
            let button = UIButton()
            button.setTitle(category.text.localized(), for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addAction(UIAction(handler: { [unowned self] _ in
                viewModel.setSection(category: category)
            }), for: .touchUpInside)
            
            shelvesStackView.addArrangedSubview(button)
        }
        
        shelvesStackView.backgroundColor = .red
        NSLayoutConstraint.activate([
            shelvesStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            shelvesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            shelvesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: shelvesStackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBinding() {
        viewModel.binding { [unowned self] in
            Task {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc
    func showSearchVC() {
        self.navigationController?.pushViewController(SearchViewController(), animated: false)
    }
    
    private func setupNavigation() {
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .search,
                                                         target: self,
                                                         action: #selector(showSearchVC)),
                                         animated: false)
        
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryViewItemCell.identifier, for: indexPath)
                as? CategoryViewItemCell else { return UITableViewCell() }
        guard let newsItemViewModel = viewModel[indexPath.row] else { return UITableViewCell() }
        cell.fillInfomation(newsItemViewModel)
        return cell 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CategoriesViewModel.cellHeight
    }
 
}

class CategoryViewItemCell: UITableViewCell {
    static var identifier: String { String(describing: Self.self) }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }

    
    private func setupLayout() {
        self.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            title.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            title.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.showsExpansionTextWhenTruncated = false
        return label
    }()
    
    func fillInfomation(_ viewModel: NewsItemViewModel) {
        title.text = viewModel.title
    }
    
    override func prepareForReuse() {
        title.text = nil
    }
}
