import Foundation

enum NetworkError: Error {
    case urlError
    case canNotParseData
    case serverError(String)
    case invalidCredentials(String)
}

public class APICaller {

    // MARK: Login function
    static func login(email: String, password: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let loginModel = LoginModel(email: email, password: password)
        
        guard let url = URL(string: NetworkConstants.Endpoints.login) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(loginModel)
            request.httpBody = jsonData
        } catch {
            completion(.failure(.canNotParseData))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.canNotParseData))
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.canNotParseData))
                return
            }
            
            // Check for successful status code
            switch httpResponse.statusCode {
            case 200...299:
                guard let data = data else {
                    completion(.failure(.canNotParseData))
                    return
                }
                
                do {
                    let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let token = responseDict?["accessToken"] as? String {
                        completion(.success(token))
                    } else {
                        let message = responseDict?["message"] as? String ?? "Unknown error"
                        completion(.failure(.serverError(message)))
                    }
                } catch {
                    completion(.failure(.canNotParseData))
                }
                
            case 400:
                completion(.failure(.invalidCredentials("Incorrect email or password")))
                
            default:
                let errorMessage = "Error with status code: \(httpResponse.statusCode)"
                completion(.failure(.serverError(errorMessage)))
            }
        }
        task.resume()
    }
}
