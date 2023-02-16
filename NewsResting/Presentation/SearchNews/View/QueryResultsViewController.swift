//
//  QueryResultsViewController.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/02/15.
//

import UIKit


class QueryResultsViewController: UIViewController {
    private var recentQueriesViewModel: RecentQueriesViewModel
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(recentQueriesViewModel: RecentQueriesViewModel) {
        self.recentQueriesViewModel = recentQueriesViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttribute()
        setupBinding()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupAttribute() {
        tableView.register(QueryTableViewCell.self, forCellReuseIdentifier: QueryTableViewCell.reusableIdentifier)
    }
    
    public func loadInitialQueries(_ text: String) {
//        
    }
}

extension QueryResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recentQueriesViewModel.queries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QueryTableViewCell.reusableIdentifier, for: indexPath) as? QueryTableViewCell else { return UITableViewCell() }
        let viewModel = recentQueriesViewModel.queries[indexPath.row]
        cell.fillUp(viewModel.query)
        return cell
    }
    //TODO: - Need [Query: NewsListViewModel] Dictionary
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}
