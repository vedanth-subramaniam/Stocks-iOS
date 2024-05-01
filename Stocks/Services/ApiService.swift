import Foundation
import Alamofire

class ApiService {
    static let shared = ApiService() // Singleton instance
    
    private let baseURL = "http://localhost:8080"
    
    func fetchAutocompleteData(query: String, completion: @escaping([StockAutocomplete]?, Error?) -> Void) {
        let endpoint = "/autoComplete/\(query)"
        print(endpoint)
        AF.request("\(baseURL)\(endpoint)").responseDecodable(of: [StockAutocomplete].self) { response in
            switch response.result {
            case .success(let stockAutocomplete):
                completion(stockAutocomplete, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchPortfolioData(completion: @escaping ([StockPortfolio]?, Error?) -> Void) {
        AF.request("\(baseURL)/getAllPortfolioData").responseDecodable(of: [StockPortfolio].self) { response in
            switch response.result {
            case .success(let stocks):
                completion(stocks, nil)
                print(stocks)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchSinglePortfolioRecord(symbol: String, completion: @escaping (StockPortfolio?, Error?) -> Void) {
        print("Fetching single portfolio record")
        let endpoint = "/getPortfolioData/\(symbol)"
        print(endpoint)
        AF.request("\(baseURL)\(endpoint)").responseDecodable(of: StockPortfolio.self) { response in
            switch response.result {
            case .success(let stockPortfolioResponse):
                completion(stockPortfolioResponse, nil)
                print(stockPortfolioResponse)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchFavoriteStocks(completion: @escaping ([StockWishlist]?, Error?) -> Void) {
        AF.request("\(baseURL)/getAllStocksWishlist").responseDecodable(of: [StockWishlist].self) { response in
            switch response.result {
            case .success(let favouriteStocks):
                completion(favouriteStocks, nil)
                print(favouriteStocks)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchWalletBalance(completion: @escaping (StockWalletBalance?, Error?) -> Void) {
        let endpoint = "/wallet"
        AF.request("\(baseURL)\(endpoint)").responseDecodable(of: StockWalletBalance.self) { response in
            switch response.result {
            case .success(let stockWalletBalance):
                completion(stockWalletBalance, nil)
                print("Wallet Balance is: ", stockWalletBalance)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func updateWalletBalance(completion: @escaping (StockWalletBalance?, Error?) -> Void) {
        let endpoint = "/wallet"
        AF.request("\(baseURL)\(endpoint)").responseDecodable(of: StockWalletBalance.self) { response in
            switch response.result {
            case .success(let stockWalletBalance):
                completion(stockWalletBalance, nil)
                print("Wallet Balance is: ", stockWalletBalance)
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
    
    func fetchChartsData(symbol: String, completion: @escaping ([StockChartsResponse]?, Error?) -> Void) {
        let endpoint = "/charts/\(symbol)"
        AF.request("\(baseURL)\(endpoint)").responseDecodable(of: [StockChartsResponse].self) { response in
            switch response.result {
            case .success(let chartsData):
                completion(chartsData, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchHourlyChartsData(symbol: String, completion: @escaping ([StockHourlyChartsResponse]?, Error?) -> Void) {
        let endpoint = "/chartsHourly/\(symbol)"
        AF.request("\(baseURL)\(endpoint)").responseDecodable(of: [StockHourlyChartsResponse].self) { response in
            switch response.result {
            case .success(let chartsData):
                completion(chartsData, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}
