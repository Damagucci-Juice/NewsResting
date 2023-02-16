//
//  SearchViewController.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/15.
//

import UIKit
import SnapKit



class SearchViewController: UIViewController {
    private var searchNewsViewModel = SearchNewsViewModel(usecase: SearchNewsUseCaseImpl(newsRepository: NewsRepositoryImpl(responseCache: CoreDataNewsResponseStorage())))
    
    private var recentQueriesViewModel = RecentQueriesViewModel(fetchRecentQueriesUseCase: FetchRecentQueriesUseCaseImpl(queryRepository: NewsQueryRepositoryImpl(newsQueryStorage: CoreDataNewsQueryStorage())))
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(QueryTableViewCell.self, forCellReuseIdentifier: QueryTableViewCell.reusableIdentifier)
        return tableView
    }()
    
    var searchController: UISearchController?
    
    //MARK: - View Contoller's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttribute()
        setupNavigation()
    }
}

//MARK: - Private
extension SearchViewController {
    private func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupAttribute() {
        searchController = UISearchController(searchResultsController: QueryResultsViewController(recentQueriesViewModel: recentQueriesViewModel))
        view.backgroundColor = .white
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigation() {
        navigationItem.searchController = searchController
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "search term".localized()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recentQueriesViewModel.queries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QueryTableViewCell.reusableIdentifier, for: indexPath) as? QueryTableViewCell else { return UITableViewCell() }
        let viewModel = recentQueriesViewModel.queries[indexPath.row]
        cell.fillUp(viewModel.query)
        return cell
    }
}

//MARK: - Public
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
              let resultVC = searchController.searchResultsController as? QueryResultsViewController
        else { return }
        resultVC.filterQueries(text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        Task {
            let viewModel = try await searchNewsViewModel.fetchNewsListViewModel(searchTerm)
            self.navigationController?.pushViewController(NewsListViewController(newsListViewModel: viewModel), animated: true)
        }
    }
}
