//
//  NewsListViewController.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import UIKit

final class NewsListViewController: UIViewController {

    private let viewModel: NewsListViewModel
    private var searchUseCase = SearchNewsUseCaseImpl(newsRepository: NewsRepositoryImpl(responseCache: CoreDataNewsResponseStorage()))
    private var currentPage = 1
    
    init(newsListViewModel: NewsListViewModel) {
        self.viewModel = newsListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self,
                           forCellReuseIdentifier: NewsTableViewCell.reusableIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupAttribute()
    }
}

extension NewsListViewController {
    
    private func setupAttribute() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupLayout() {
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}


extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reusableIdentifier, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        let vm = viewModel[indexPath.row]
        cell.fill(vm)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsItemViewModel = viewModel[indexPath.row]
        let detailVC = DetailNewsViewController(newsItemViewModel: newsItemViewModel)
        Task {
            self.navigationController?.pushViewController(detailVC, animated: false)
        }
    }
    
    //MARK: - When scroll reached to bottom
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let title = navigationItem.title,
              indexPath.row + 1 == viewModel.count else { return }
        Task {
            let nextPage = currentPage + 1
            do {
                let newsList = try await searchUseCase.excute(query: NewsQuery(query: title), page: nextPage)
                currentPage = nextPage
                let additionalViewModel = newsList.toViewModel().newsViewModel
                viewModel.append(newsItems: additionalViewModel)
                tableView.reloadData()
            } catch {
                debugPrint("Fetching \(title)'s \(nextPage) failed")
            }
        }
    }
}
