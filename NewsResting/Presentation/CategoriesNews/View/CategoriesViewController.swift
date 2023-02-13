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
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributes()
        setupLayout()
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
        
        NewsCategory.allCases.forEach {
            let button = UIButton()
            button.setTitle($0.text, for: .normal)
            button.setTitleColor(.black, for: .normal)
            
            shelvesStackView.addArrangedSubview(button)
        }
        
        shelvesStackView.backgroundColor = .red
        NSLayoutConstraint.activate([
            shelvesStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            shelvesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shelvesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: shelvesStackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        NewsCategory.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel[section].articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryViewItemCell.identifier, for: indexPath)
                as? CategoryViewItemCell else { return UITableViewCell() }
        let newsList = viewModel[indexPath.section].articles
        cell.fillInfomation(newsList[indexPath.row].toViewModel(), sectionNumber: indexPath.section)
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
    
    func fillInfomation(_ viewModel: NewsItemViewModel, sectionNumber: Int) {
        title.text = viewModel.title
        var color: UIColor
        switch sectionNumber {
        case 0:
            color = .yellow
        case 1:
            color = .brown
        case 2:
            color = .blue
        case 3:
            color = .cyan
        case 4:
            color = .green
        case 5:
            color = .gray
        default:
            color = .orange
        }
        self.backgroundColor = color
    }
    
    override func prepareForReuse() {
        title.text = nil
    }
}
