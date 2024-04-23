import Foundation
import Alamofire

class ApiService {
    static let shared = ApiService() // Singleton instance
    
    private let baseURL = "http://localhost:8080"
    
    func fetchAutocompleteData(query: String, completion: @escaping([StockAutocomplete]?, Error?) -> Void) {
        let endpoint = "/autoComplete/\(query)"
        AF.request("\(baseURL)\(endpoint)").responseDecodable(of: [StockAutocomplete].self) { response in
            switch response.result {
            case .success(let stockAutocomplete):
                completion(stockAutocomplete, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
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
    
    func fetchStockData(query: String, completion: @escaping (StockSummaryAPIResponse?, Error?) -> Void) {
        let endpoint = "/search/\(query)"
        AF.request("\(baseURL)\(endpoint)").responseDecodable(of: StockSummaryAPIResponse.self) { response in
            switch response.result {
            case .success(let stockSummaryApiResponse):
                completion(stockSummaryApiResponse, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    
}
