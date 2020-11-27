//
//  Service.swift
//  TMDB
//
//  Created by Denny Arfansyah on 26/11/20.
//

import Alamofire

protocol ServiceDelegate {
    
    func didFailWithError(with errorMessage: String)
    func didSuccessWithData(to data: Data)
    
}

struct Service {
    
    var delegate: ServiceDelegate?
    
    func request(_ url: String) {
        guard let manager = NetworkReachabilityManager(host: "www.apple.com") else { return }
        if !manager.isReachable {
            self.delegate?.didFailWithError(with: K.noInternetConnection)
            return
        }
        let r = AF.request(url)
        r.responseJSON { (response) in
            print(response)
            switch response.result {
            case .failure(let error):
                self.delegate?.didFailWithError(with: error.localizedDescription)
            case .success(_):
                guard let data = response.data else {
                    self.delegate?.didFailWithError(with: K.generalErrorMessage)
                    return
                }
                if let res = response.response {
                    if res.statusCode >= 200, res.statusCode < 300 {
                        self.delegate?.didSuccessWithData(to: data)
                    } else {
                        self.delegate?.didFailWithError(with: response.error?.localizedDescription ?? K.generalErrorMessage)
                    }
                }
            }
        }
    }
    
}
