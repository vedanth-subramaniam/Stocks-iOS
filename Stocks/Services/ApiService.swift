import Foundation
import Alamofire

class ApiService {
    static let shared = ApiService() // Singleton instance
    
    private let baseURL = "http://localhost:8080"
    
    func fetchPortfolioData(completion: @escaping ([Stock]?, Error?) -> Void) {
        AF.request("\(baseURL)/getAllPortfolioData").responseDecodable(of: [Stock].self) { response in
            switch response.result {
            case .success(let stocks):
                completion(stocks, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchFavoriteStocks(completion: @escaping ([Stock]?, Error?) -> Void) {
        AF.request("\(baseURL)/getAllStocks").responseDecodable(of: [Stock].self) { response in
            switch response.result {
            case .success(let favouriteStocks):
                completion(favouriteStocks, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
