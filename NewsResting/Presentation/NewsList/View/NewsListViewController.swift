//
//  NewsListViewController.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import UIKit

final class NewsListViewController: UIViewController {

    let newsListViewModel = NewsListViewModel(newsRepository: NewsRepositoryImpl())
    
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
        setupBind()
        newsListViewModel.fetchNews("apple")
    }
}

extension NewsListViewController {
    
    private func setupAttribute() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupBind() {
        newsListViewModel.bind { [unowned self] in
            self.tableView.reloadData()
        }
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
        self.newsListViewModel.newsViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reusableIdentifier, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        let vm = newsListViewModel[indexPath.row]
        cell.fill(vm)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
