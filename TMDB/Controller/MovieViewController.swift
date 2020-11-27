//
//  MovieViewController.swift
//  TMDB
//
//  Created by Denny Arfansyah on 26/11/20.
//

import UIKit
import youtube_ios_player_helper
import Toast_Swift

class MovieViewController: BaseViewController, YTPlayerViewDelegate {
    
    @IBOutlet weak var youtubePlayer: YTPlayerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var selectedMovie: Movie!
    var service: Service!
    var baseUrl: String!
    var videos: [Video]?
    
    override func loadView() {
        super.loadView()
        
        titleLabel.text = selectedMovie.title
        overviewLabel.text = selectedMovie.overview
        ratingLabel.text = String(format: "Rating : %.1f/10.0", selectedMovie.vote_average ?? 0.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        youtubePlayer.delegate = self
        videos = []
        let videUrl = String(format: "%@/%d/videos?api_key=%@", K.movieUrl, selectedMovie.id ?? "", K.apiKey)
        service = Service()
        service.delegate = self
        service.request(videUrl)
    }
    
    @IBAction func gotoReviewPage(_ sender: Any) {
        performSegue(withIdentifier: K.Segue.listReviewSegue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setBackButtonTitle(to: "Reviews")
        let destinationVC = segue.destination as! ListReviewViewController
        destinationVC.movieId = selectedMovie.id
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        youtubePlayer.playVideo()
    }
    
}

extension MovieViewController: ServiceDelegate {
    
    func didFailWithError(with errorMessage: String) {
        view.makeToast(errorMessage)
    }
    
    func didSuccessWithData(to data: Data) {
        do {
            let decodedData = try JSONDecoder().decode(Videos.self, from: data)
            if let results = decodedData.results, results.count > 0 {
                for video in results {
                    if video.type?.lowercased() == "trailer" {
                        videos?.append(video)
                    }
                }
            }
            DispatchQueue.main.async {
                if let v = self.videos, v.count > 0, let key = v[0].key {
                    self.youtubePlayer.load(withVideoId: key, playerVars: ["playsinline": 1])
                }
            }
        } catch {
            view.makeToast(error.localizedDescription)
        }
    }
    
}

