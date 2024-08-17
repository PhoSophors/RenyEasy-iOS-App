import Foundation

enum NetworkError: Error {
    case urlError
    case canNotParseData
    case serverError(String)
    case invalidCredentials(String)
    case unauthorized
    case forbidden
    case notFound
//    case invalidURL
//    case noData
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
    
    // MARK: - Helper Methods
    private static func makeRequest(urlString: String, method: String, body: Data? = nil, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = AuthManager.getToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = body
        
        print("Making request to: \(urlString)")
        print("Method: \(method)")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network request failed with error: \(error.localizedDescription)")
                completion(.failure(.canNotParseData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response received")
                completion(.failure(.canNotParseData))
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            switch httpResponse.statusCode {
            case 200...299:
                if let data = data {
                    completion(.success(data))
                } else {
                    print("No data received")
                    completion(.failure(.canNotParseData))
                }
            case 400:
                completion(.failure(.invalidCredentials("Incorrect email or password")))
            case 401:
                completion(.failure(.unauthorized))
            case 403:
                completion(.failure(.forbidden))
            case 404:
                completion(.failure(.notFound))
            default:
                let errorMessage = "Error with status code: \(httpResponse.statusCode)"
                let serverMessage = (data != nil) ? String(data: data!, encoding: .utf8) ?? "No additional info" : "No additional info"
                print("Error: \(errorMessage) - \(serverMessage)")
                completion(.failure(.serverError("\(errorMessage): \(serverMessage)")))
            }
        }
        task.resume()
    }
    
    // MARK: - Login function
    static func login(email: String, password: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let loginModel = LoginModel(email: email, password: password)
        
        do {
            let jsonData = try JSONEncoder().encode(loginModel)
            makeRequest(urlString: NetworkConstants.Endpoints.login, method: "POST", body: jsonData) { result in
                switch result {
                case .success(let data):
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
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(.canNotParseData))
        }
    }
    
    // MARK: - Register function
    static func register(username: String, email: String, password: String, confirmPassword: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let registerModel = RegisterModel(username: username, email: email, password: password, confirmPassword: confirmPassword)
        
        do {
            let jsonData = try JSONEncoder().encode(registerModel)
            makeRequest(urlString: NetworkConstants.Endpoints.register, method: "POST", body: jsonData) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(.canNotParseData))
        }
    }
    
    // MARK: Register verify OTP function
    static func verifyRegisterOTP(email: String, otp: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let verifyModel = VerifyRegisterOTP(email: email, otp: otp)
        
        do {
            let jsonData = try JSONEncoder().encode(verifyModel)
            makeRequest(urlString: NetworkConstants.Endpoints.registerVerifyOTP, method: "POST", body: jsonData) { result in
                switch result {
                case .success(let data):
                    // Assuming the response is in JSON format and contains the token
                    if let response = try? JSONDecoder().decode(VerifyRegisterOTPResponse.self, from: data) {
                        completion(.success(response.token))
                    } else {
                        completion(.failure(.canNotParseData))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(.canNotParseData))
        }
    }
    
    // MARK: - Request New Password
    static func requestNewPassword(email: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let requestNewPasswordModel = RequestNewPasswordModel(email: email)
        
        do {
            let jsonData = try JSONEncoder().encode(requestNewPasswordModel)
            makeRequest(urlString: NetworkConstants.Endpoints.forgotPassword, method: "POST", body: jsonData) { result in
                switch result {
                case .success:
                    completion(.success("Password reset request successful"))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(.canNotParseData))
        }
    }
        
    // MARK: - Verify Reset Password OTP
    static func verifyResetPasswordOTP(email: String, otp: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let verifyNewPasswordOTPModel = VerifyNewPasswordOTPModel(email: email, otp: otp)
        
        do {
            let jsonData = try JSONEncoder().encode(verifyNewPasswordOTPModel)
            makeRequest(urlString: NetworkConstants.Endpoints.verifyResetPasswordOTP, method: "POST", body: jsonData) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(VerifyNewPasswordOTPResponse.self, from: data)
                        completion(.success(response.message))
                    } catch {
                        completion(.failure(.canNotParseData))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(.canNotParseData))
        }
    }
    
    // MARK: - Set New Password
    static func setNewPassword(email: String, newPassword: String, confirmPassword: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let newPasswordModel = NewPasswordModel(email: email, password: newPassword, confirmPassword: confirmPassword)
        
        do {
            let jsonData = try JSONEncoder().encode(newPasswordModel)
            makeRequest(urlString: NetworkConstants.Endpoints.setNewPassword, method: "POST", body: jsonData) { result in
                switch result {
                case .success:
                    completion(.success("Password has been successfully reset"))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(.canNotParseData))
        }
    }

    /**
     *
     * User data
     * ============================================================================================
     */
    
    // MARK: - Get user info
    static func getUserInfo(completion: @escaping (Result<UserInfo, NetworkError>) -> Void) {
        makeRequest(urlString: NetworkConstants.Endpoints.getUserInfo, method: "GET") { result in
            switch result {
            case .success(let data):
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                do {
                    let userInfo = try decoder.decode(UserInfo.self, from: data)
                    completion(.success(userInfo))
                } catch {
                    completion(.failure(.canNotParseData))
                    print("Decoding Error: \(error)")
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Update user profile
    static func updateUserProfile(profile: UpdateProfile, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(profile)
            makeRequest(urlString: NetworkConstants.Endpoints.updateUserInfo, method: "PUT", body: jsonData) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(.canNotParseData))
        }
    }
    
    /**
     *
     * Favorites data
     * ============================================================================================
     */
    // MARK: - Fetch User Favorites
    static func fetchUserFavorites(completion: @escaping (Result<[Favorite], NetworkError>) -> Void) {
        makeRequest(urlString: NetworkConstants.Endpoints.fetchUserFavorites, method: "GET") { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(FavoriteResponse.self, from: data)
                    completion(.success(response.data.favorites))
                } catch {
                    completion(.failure(.canNotParseData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Remove favorite
    static func removeFavorites(postId: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        // Update the URL to include the postId
        let urlString = "\(NetworkConstants.Endpoints.removeFavorites)/\(postId)"
        print("Request URL: \(urlString)") // Log the request URL for debugging
        
        makeRequest(urlString: urlString, method: "POST") { result in
            switch result {
            case .success(let data):
                do {
                    if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = responseDict["message"] as? String {
                        print("Success response: \(message)") // Log the success message
                        completion(.success(message))
                    } else {
                        let errorMsg = "Response data could not be parsed or message not found"
                        print("Error: \(errorMsg)") // Log the error message
                        completion(.failure(.canNotParseData))
                    }
                } catch {
                    print("Error: JSONSerialization failed with error: \(error.localizedDescription)")
                    completion(.failure(.canNotParseData))
                }
            case .failure(let error):
                print("Network request failed with error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    /**
     *
     * Posts
     * ============================================================================================
     */
    
    // MARK: - fetch all post by property
    static func fetchAllPostByProperty(propertytype: String, completion: @escaping (Result<AllPostsResponse, Error>) -> Void) {
        // Construct the URL with query parameters
        let urlString = "\(NetworkConstants.Endpoints.fetchPostByProperty)?propertytype=\(propertytype)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.urlError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.canNotParseData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let allPostByProperty = try decoder.decode(AllPostsResponse.self, from: data)
                completion(.success(allPostByProperty))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    

    // MARK: - Fetch all posts
    static func fetchAllPosts(completion: @escaping (Result<AllPostsResponse, Error>) -> Void) {
        makeRequest(urlString: NetworkConstants.Endpoints.fetchAllPost, method: "GET") { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(AllPostsResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


}
