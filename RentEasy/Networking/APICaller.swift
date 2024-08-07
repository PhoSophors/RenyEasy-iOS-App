import Foundation

enum NetworkError: Error {
    case urlError
    case canNotParseData
    case serverError(String)
    case invalidCredentials(String)
    case unauthorized
    case forbidden
    case notFound
}

struct UpdateProfile: Codable {
    var username: String
    var email: String
    var profilePhoto: String?
    var coverPhoto: String?
    var bio: String?
    var location: String?  
}

public class APICaller {
    
    // MARK: - Login function
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
    
    // MARK: - Get user info
    static func getUserInfo(completion: @escaping (Result<UserInfo, NetworkError>) -> Void) {
        guard let url = URL(string: NetworkConstants.Endpoints.getUserInfo) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Assuming you have a method to get the stored token
        if let token = AuthManager.getToken() {
            print("Token retrieved: \(token)")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("No token found")
            completion(.failure(.serverError("No token found")))
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
            
            // Print the raw response data
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                guard let data = data else {
                    completion(.failure(.canNotParseData))
                    return
                }
                
                // Define and set up the DateFormatter
                let dateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // Adjust format to match your server's date format
                    return formatter
                }()
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                do {
                    let userInfo = try decoder.decode(UserInfo.self, from: data)
                    completion(.success(userInfo))
                } catch {
                    completion(.failure(.canNotParseData))
                    print("Decoding Error: \(error)")
                }
                
            case 401:
                completion(.failure(.serverError("Unauthorized access")))
                
            default:
                let errorMessage = "Error with status code: \(httpResponse.statusCode)"
                completion(.failure(.serverError(errorMessage)))
            }
        }
        task.resume()
    }
    
    // MARK: - Update user profile
    // MARK: - Update user profile
    static func updateUserProfile(profile: UpdateProfile, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard let url = URL(string: NetworkConstants.Endpoints.updateUserInfo) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" // Assuming your API uses PUT for updates
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Assuming you have a method to get the stored token
        if let token = AuthManager.getToken() {
            print("Token retrieved: \(token)")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("No token found")
            completion(.failure(.serverError("No token found")))
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(profile)
            request.httpBody = jsonData
        } catch {
            completion(.failure(.canNotParseData))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.canNotParseData))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                completion(.success(()))
                
            case 401:
                completion(.failure(.unauthorized))
                
            case 403:
                completion(.failure(.forbidden))
                
            case 404:
                completion(.failure(.notFound))
                
            default:
                let errorMessage = "Error with status code: \(httpResponse.statusCode)"
                if let data = data, let serverMessage = String(data: data, encoding: .utf8) {
                    completion(.failure(.serverError("\(errorMessage): \(serverMessage)")))
                } else {
                    completion(.failure(.serverError(errorMessage)))
                }
            }
        }
        task.resume()
    }

}
