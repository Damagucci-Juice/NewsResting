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
        tableView.register(QueryTableViewCell.self,
                           forCellReuseIdentifier: QueryTableViewCell.reusableIdentifier)
        tableView.delegate = self
        tableView.dataSource = self 
    }
    
    private func setupBinding() {
        recentQueriesViewModel.bindingFilter { [unowned self] in
            Task {
                self.tableView.reloadData()
            }
        }
    }
    
    public func filterQueries(_ text: String) {
        recentQueriesViewModel.filterQuries(text)
    }
}

extension QueryResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recentQueriesViewModel.filteredQueries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QueryTableViewCell.reusableIdentifier, for: indexPath) as? QueryTableViewCell else { return UITableViewCell() }
        let (query, _) = recentQueriesViewModel.filteredQueries[indexPath.row]
        cell.fillUp(query.query)
        return cell
    }
}
