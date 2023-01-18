//
//  NewsListViewController.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import UIKit

class NewsListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let repo = NewsRepositoryImpl()
        repo.fetchNewsList(query: NewsQuery(query: "korea")) { result in
            switch result {
            case .success(let newsList):
                print(newsList)
            case .failure(let error):
                print(error)
            }
        }
    }
}
