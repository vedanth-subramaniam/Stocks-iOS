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
    
    func fetchStockData(symbol: String, completion: @escaping (StockSummaryResponse?, Error?) -> Void) {
        let endpoint = "/search/\(symbol)"
        AF.request("\(baseURL)\(endpoint)").responseDecodable(of: StockSummaryResponse.self) { response in
            switch response.result {
            case .success(let stockSummaryApiResponse):
                completion(stockSummaryApiResponse, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchInsightsData(symbol: String, completion: @escaping (StockInsightsResponse?, Error?) -> Void) {
        let endpoint = "/insights/\(symbol)"
        AF.request("\(baseURL)\(endpoint)").responseDecodable(of: StockInsightsResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                completion(apiResponse, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchNewsData(symbol: String, completion: @escaping ([NewsArticle]?, Error?) -> Void) {
        let endpoint = "/news/\(symbol)"
        AF.request("\(baseURL)\(endpoint)").responseDecodable(of: [NewsArticle].self) { response in
            switch response.result {
            case .success(let newsArticles):
                completion(newsArticles, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
