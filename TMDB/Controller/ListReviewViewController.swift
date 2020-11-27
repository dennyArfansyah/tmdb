//
//  ListReviewViewController.swift
//  TMDB
//
//  Created by Denny Arfansyah on 26/11/20.
//

import UIKit
import Toast_Swift

class ListReviewViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshController = UIRefreshControl()
    
    var service: Service!
    var baseUrl: String!
    var page: Int!
    var movieId: Int!
    var reviews: [Review]?
    var isLoadMore: Bool!
    
    override func loadView() {
        super.loadView()
        
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoadMore = false
        service = Service()
        service.delegate = self
        baseUrl = ""
        baseUrl += String(format: "%@/%d/reviews?api_key=%@", K.movieUrl, movieId, K.apiKey)
        setFirstRequest()
    }
    
    func setupTableView() {
        tableView.register(ReviewTableViewCell.nib(), forCellReuseIdentifier: ReviewTableViewCell.reusedIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        let footer = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20)
        tableView.tableFooterView = UIView(frame: footer)
        
        refreshController.attributedTitle = NSAttributedString(string: "")
        refreshController.addTarget(self, action: #selector(refreshControl), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshController)
    }
    
    @objc func refreshControl(sender: AnyObject) {
        setFirstRequest()
        sender.endRefreshing()
    }
    
    func setFirstRequest() {
        reviews = []
        page = 1
        setUrl()
    }
    
    func setUrl() {
        let endPoint = baseUrl + String(format: "&page=%d", page)
        service.request(endPoint)
    }
    
}

extension ListReviewViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = reviews?.count ?? 0
        tableView.setTableViewBackground(count: count)
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = reviews?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.reusedIdentifier, for: indexPath) as! ReviewTableViewCell
        cell.authorLabel.text = review?.author
        cell.contentLabel.text = review?.content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let r = reviews, r.count > 0 {
            if indexPath.row == r.count - 1 && isLoadMore {
                page += 1
                perform(#selector(loadMore), with: nil, afterDelay: 1.0)
            }
        }
    }
    
    @objc func loadMore() {
        setUrl()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension ListReviewViewController: ServiceDelegate {
    
    func didFailWithError(with errorMessage: String) {
        view.makeToast(errorMessage)
    }
    
    func didSuccessWithData(to data: Data) {
        do {
            let decodedData = try JSONDecoder().decode(Reviews.self, from: data)
            if let results = decodedData.results, results.count > 0 {
                isLoadMore = true
                for review in results {
                    reviews?.append(review)
                }
            } else {
                isLoadMore = false
                // show toast -> no more data
            }
        } catch {
            view.makeToast(error.localizedDescription)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
