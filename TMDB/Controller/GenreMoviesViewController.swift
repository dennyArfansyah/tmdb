//
//  ViewController.swift
//  TMDB
//
//  Created by Denny Arfansyah on 26/11/20.
//

import UIKit
import Toast_Swift

class GenreMoviesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshController = UIRefreshControl()
    
    var genres: [Genre]?
    var service: Service!
    
    override func loadView() {
        super.loadView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshController.attributedTitle = NSAttributedString(string: "")
        refreshController.addTarget(self, action: #selector(refreshControl), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = Service()
        service.delegate = self
        setRequest()
    }
    
    @objc func refreshControl(sender: AnyObject) {
        setRequest()
        sender.endRefreshing()
    }
    
    func setRequest() {
        genres = []
        service.request(K.genresUrl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ListMovieViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            if let genre = genres?[indexPath.row] {
                setBackButtonTitle(to: genre.name ?? "")
                destinationVC.selectedGenre = genre
            }
        }
    }

}

extension GenreMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = genres?.count ?? 0
        tableView.setTableViewBackground(count: count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = genres?[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segue.listMoviewSegue, sender: self)
    }
    
}

extension GenreMoviesViewController: ServiceDelegate {
    
    func didFailWithError(with errorMessage: String) {
        view.makeToast(errorMessage)
    }
    
    func didSuccessWithData(to data: Data) {
        do {
            let decodedData = try JSONDecoder().decode(Genres.self, from: data)
            for genre in decodedData.genres ?? [] {
                genres?.append(genre)
            }
        } catch {
            view.makeToast(error.localizedDescription)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
