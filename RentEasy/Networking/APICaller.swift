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
        
        do {
            let jsonData = try JSONEncoder().encode(loginModel)
            APIHelper.makeRequest(urlString: NetworkConstants.Endpoints.login, method: "POST", body: jsonData) { result in
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
            APIHelper.makeRequest(urlString: NetworkConstants.Endpoints.register, method: "POST", body: jsonData) { result in
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
            APIHelper.makeRequest(urlString: NetworkConstants.Endpoints.registerVerifyOTP, method: "POST", body: jsonData) { result in
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
            APIHelper.makeRequest(urlString: NetworkConstants.Endpoints.forgotPassword, method: "POST", body: jsonData) { result in
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
            APIHelper.makeRequest(urlString: NetworkConstants.Endpoints.verifyResetPasswordOTP, method: "POST", body: jsonData) { result in
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
        let newPasswordModel = NewPasswordModel(email: email, newPassword: newPassword, confirmPassword: confirmPassword)
        
        do {
            let jsonData = try JSONEncoder().encode(newPasswordModel)
            APIHelper.makeRequest(urlString: NetworkConstants.Endpoints.setNewPassword, method: "POST", body: jsonData) { result in
                switch result {
                case .success:
                    completion(.success(("asdf")))
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
        APIHelper.makeRequest(urlString: NetworkConstants.Endpoints.getUserInfo, method: "GET") { result in
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
    static func updateUserProfile(
        profile: UpdateProfile,
        coverPhoto: [Data],
        profilePhoto: [Data],
        completion: @escaping (Result<UpdateUserInfoResponse, NetworkError>) -> Void
    ) {
        let urlString = NetworkConstants.Endpoints.updateUserInfo
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        
        func appendString(_ string: String, to data: inout Data) {
            guard let stringData = string.data(using: .utf8) else { return }
            data.append(stringData)
        }
        
        // Append profile data
        let updateProfileData: [String: Any] = [
            "username": profile.username,
            "email": profile.email,
            "bio": profile.bio ?? "Bio",
            "location": profile.location ?? "Location"
        ]
        
        // Append post data
        for (key, value) in updateProfileData {
            appendString("--\(boundary)\r\n", to: &body)
            appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n", to: &body)
            appendString("Content-Type: text/plain\r\n\r\n", to: &body)
            appendString("\(value)\r\n", to: &body)
        }
        
        // Append profile photos
        APIHelper.appendFormData(named: "profilePhoto", with: profilePhoto, to: &body, boundary: boundary, appendString: appendString)
       // Append cover photos
        APIHelper.appendFormData(named: "coverPhoto", with: coverPhoto, to: &body, boundary: boundary, appendString: appendString)

        
        appendString("--\(boundary)--\r\n", to: &body)
        
        APIHelper.makeMultipartRequest(
            urlString: urlString,
            method: "POST",
            body: body,
            boundary: boundary
        ) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(UpdateUserInfoResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(.failure(.canNotParseData))
                }
                
            case .failure(let error):
                print("Request failed with error: \(error.localizedDescription)")
                // Print the raw error if available
                if let underlyingError = (error as NSError).userInfo[NSUnderlyingErrorKey] as? NSError {
                    print("Underlying error: \(underlyingError.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }

    /**
     *
     * Favorites data
     * ============================================================================================
     */
    // MARK: - Fetch User Favorites
    static func fetchUserFavorites(completion: @escaping (Result<[Favorite], NetworkError>) -> Void) {
        APIHelper.makeRequest(urlString: NetworkConstants.Endpoints.fetchUserFavorites, method: "GET") { result in
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
        print("Request URL: \(urlString)")
        
        APIHelper.makeRequest(urlString: urlString, method: "POST") { result in
            switch result {
            case .success(let data):
                do {
                    if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = responseDict["message"] as? String {
                        print("Success response: \(message)")
                        completion(.success(message))
                    } else {
                        let errorMsg = "Response data could not be parsed or message not found"
                        print("Error: \(errorMsg)")
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
    
    // MARK: - Add Post to Favorites
    static func addFavorites(postId: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let urlString = "\(NetworkConstants.Endpoints.addFavorites)/\(postId)"
        print("Request URL: \(urlString)")
        
        APIHelper.makeRequest(urlString: urlString, method: "POST") { result in
            switch result {
            case .success(let data):
                do {
                    if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = responseDict["message"] as? String {
                        print("Success response: \(message)")
                        completion(.success(message))
                    } else {
                        let errorMsg = "Response data could not be parsed or message not found"
                        print("Error: \(errorMsg)")
                        completion(.failure(.canNotParseData))
                    }
                } catch {
                    print("Error: JSONSerialization failed with error: \(error.localizedDescription)")
                    completion(.failure(.canNotParseData))
                }
            case .failure(let error):
                // Provide detailed error information for debugging
                print("Error: Network request failed with error: \(error.localizedDescription)")
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
        APIHelper.makeRequest(urlString: NetworkConstants.Endpoints.fetchAllPost, method: "GET") { result in
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
    

    static func createNewPostWithImages(
        postData: [String: Any],
        images: [Data],
        completion: @escaping (Result<NewPostResponse, NetworkError>) -> Void
    ) {
        let urlString = NetworkConstants.Endpoints.createNewPost
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        
        func appendString(_ string: String, to data: inout Data) {
            guard let stringData = string.data(using: .utf8) else { return }
            data.append(stringData)
        }
    
        // Append post data
        for (key, value) in postData {
            appendString("--\(boundary)\r\n", to: &body)
            appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n", to: &body)
            appendString("Content-Type: text/plain\r\n\r\n", to: &body)
            appendString("\(value)\r\n", to: &body)
        }
        
        // Append images
        APIHelper.appendFormData(named: "images", with: images, to: &body, boundary: boundary, appendString: appendString)
        
        appendString("--\(boundary)--\r\n", to: &body)
        
        APIHelper.makeMultipartRequest(
            urlString: urlString,
            method: "POST",
            body: body,
            boundary: boundary
        ) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let newPostResponse = try decoder.decode(NewPostResponse.self, from: data)
                    completion(.success(newPostResponse))
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(.failure(.canNotParseData))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    /**
     *
     * Search
     * ============================================================================================
     */

    // MARK: - Search
    static func searchPostsAndUsers(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        let urlString = "\(NetworkConstants.Endpoints.searchPostAndUser)?query=\(query)"
        APIHelper.makeRequest(urlString: urlString, method: "GET") { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(SearchResponse.self, from: data)
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


