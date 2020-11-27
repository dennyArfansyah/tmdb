//
//  ListMovieViewController.swift
//  TMDB
//
//  Created by Denny Arfansyah on 26/11/20.
//

import UIKit
import Foundation
import SDWebImage
import Toast_Swift

class ListMovieViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshController = UIRefreshControl()
    
    var service: Service!
    var selectedGenre: Genre!
    var movies: [Movie]?
    var baseUrl: String!
    var page: Int!
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
        baseUrl = K.moviesUrl
        if let g = selectedGenre, let id = g.id {
            baseUrl += String(format: "%d", id)
            setFirstRequest()
        }
    }
    
    func setupTableView() {
        tableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.reusedIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        let footer = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40)
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
        movies = []
        page = 1
        setRequest()
    }
    
    func setRequest() {
        let endPoint = baseUrl + String(format: "&page=%d", page)
        service.request(endPoint)
    }
    
}

extension ListMovieViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = movies?.count ?? 0
        tableView.setTableViewBackground(count: count)
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reusedIdentifier, for: indexPath) as! MovieTableViewCell
        let movie = movies?[indexPath.row]
        cell.titleLabel.text = movie?.title
        
        if let backdropPath = movie?.backdrop_path {
            let url = URL(string: K.baseImageUrl + backdropPath)
            cell.posterImageView.sd_setImage(with: url, placeholderImage: nil, options: .continueInBackground, completed: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let m = movies, m.count > 0 {
            if indexPath.row == m.count - 1 && isLoadMore {
                page += 1
                perform(#selector(loadMore), with: nil, afterDelay: 1.0)
            } 
        }
    }
    
    @objc func loadMore() {
        setRequest()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segue.movieSegue, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setBackButtonTitle(to: "Movie")
        let destinationVC = segue.destination as! MovieViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedMovie = movies?[indexPath.row]
        }
    }

}

extension ListMovieViewController: ServiceDelegate {
    
    func didFailWithError(with errorMessage: String) {
        view.makeToast(errorMessage)
    }
    
    func didSuccessWithData(to data: Data) {
        do {
            let decodedData = try JSONDecoder().decode(Movies.self, from: data)
            if let results = decodedData.results, results.count > 0 {
                isLoadMore = true
                for movie in decodedData.results ?? [] {
                    movies?.append(movie)
                }
            } else {
                isLoadMore = false
            }
        } catch {
            view.makeToast(error.localizedDescription)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
