
import Foundation
final class APICaller {
    static let shared = APICaller()
    struct Constants {
        static let topHeadlineURL = URL(string: "https://newsapi.org/v2/top-headlines?country=jp&apiKey=a4b12193217846e7babb0ef285a4b032")
        static let searchUrl = "https://newsapi.org/v2/everything?apiKey=a4b12193217846e7babb0ef285a4b032&q="
    }
    private init() {}
    public func getTopStory(completion: @escaping (Result<[Articles], Error>) -> Void) {
        guard let url = Constants.topHeadlineURL else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    public func Searchs(with query: String, completion: @escaping (Result<[Articles], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        
        let urlString = Constants.searchUrl + query
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

//MARK: -Models
struct APIResponse: Codable {
    let articles: [Articles]
}
struct Articles: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    
}
struct Source: Codable {
    let name: String
}
