//
//  SearchViewController.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/15.
//

import UIKit
import SnapKit



class SearchViewController: UIViewController {
    private var detailSearchRequestValue: DetailSearchRequestValue? = nil {
        didSet {
            let image = detailSearchRequestValue == nil
            ? UIImage(systemName: "wrench.and.screwdriver")
            : UIImage(systemName: "wrench.and.screwdriver.fill")
            navigationItem.rightBarButtonItem?.image = image
            navigationItem.rightBarButtonItem?.tintColor = detailSearchRequestValue == nil ? .tintColor : .green
        }
    }
    
    private var onDetailVCTappedDone: (DetailSearchRequestValue) -> Void = { _ in }
    
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
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refrashSearchController()
    }
}

//MARK: - Private
extension SearchViewController {
    private func refrashSearchController() {
        searchController?.isActive = false
    }
    
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
    
    private func setupBinding() {
        recentQueriesViewModel.bindingQueries { [unowned self] in
            Task {
                self.tableView.reloadData()
            }
        }
        
        recentQueriesViewModel.bindingTapped { [unowned self] searchTerm, newsResult in
            Task {
                let newsVC = NewsListViewController(newsListViewModel: newsResult)
                newsVC.title = searchTerm.query
                self.navigationController?.pushViewController(newsVC, animated: false)
            }
        }
        
        onDetailVCTappedDone = { [unowned self] value in
            self.detailSearchRequestValue = value
        }
    }
    
    private func setupNavigation() {
        navigationItem.searchController = searchController
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "search term".localized()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.setRightBarButton(UIBarButtonItem.init(image: UIImage(systemName: "wrench.and.screwdriver"),
                                                              style: .done,
                                                              target: self,
                                                              action: #selector(openSearchToolsViewController)), animated: false)
    }
    
    @objc func openSearchToolsViewController() {
        Task {
            let searchToolVC = SearchToolViewController()
            searchToolVC.bidnig(completion: onDetailVCTappedDone)
            let navController = UINavigationController(rootViewController: searchToolVC)
            navController.modalPresentationStyle = .formSheet
            self.present(navController, animated: true)
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recentQueriesViewModel.queriesAndViewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QueryTableViewCell.reusableIdentifier, for: indexPath) as? QueryTableViewCell else { return UITableViewCell() }
        let (query, _) = recentQueriesViewModel.queriesAndViewModel[indexPath.row]
        cell.fillUp(query.query)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recentQueriesViewModel.cellTapped(indexPath.row)
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
            do {
                let newsQuery = NewsQuery(query: searchTerm, detailSearchRequestValue: self.detailSearchRequestValue)
                let (query, viewModel) = try await searchNewsViewModel.fetchNewsListViewModel(newsQuery, page: 1)
                recentQueriesViewModel.append(query: query, newsListViewModel: viewModel)
                let vc = NewsListViewController(newsListViewModel: viewModel)
                vc.title = query.query
                self.navigationController?.pushViewController(vc, animated: true)
            } catch {
                debugPrint("Fetching \(searchTerm) News failed")
            }
        }
    }
}
