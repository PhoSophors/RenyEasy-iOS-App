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
            
            switch httpResponse.statusCode {
            case 200...299:
                if let data = data {
                    completion(.success(data))
                } else {
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
}
