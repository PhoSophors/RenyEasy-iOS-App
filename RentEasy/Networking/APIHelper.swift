//
//  APIHelper.swift
//  RentEasy
//
//  Created by Apple on 28/8/24.
//

import Foundation

struct APIHelper {
    
    static func appendFormData(
        named name: String,
        with images: [Data],
        to body: inout Data,
        boundary: String,
        appendString: (String, inout Data) -> Void
    ) {
        for (index, imageData) in images.enumerated() {
            appendString("--\(boundary)\r\n", &body)
            appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"image\(index).jpg\"\r\n", &body)
            appendString("Content-Type: image/jpeg\r\n\r\n", &body)
            body.append(imageData)
            appendString("\r\n", &body)
        }
    }

    // Existing methods
    static func makeMultipartRequest(
        urlString: String,
        method: String,
        body: Data? = nil,
        boundary: String? = nil,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let boundary = boundary {
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        } else {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let token = AuthManager.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = body
        
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
            
            switch httpResponse.statusCode {
            case 200...299:
                if let data = data {
                    completion(.success(data))
                } else {
                    print("No data received")
                    completion(.failure(.canNotParseData))
                }
            case 400:
                let errorMsg = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Bad request"
                print("400 Bad Request: \(errorMsg)")
                completion(.failure(.invalidCredentials(errorMsg)))
            case 401:
                print("401 Unauthorized")
                completion(.failure(.unauthorized))
            case 403:
                print("403 Forbidden")
                completion(.failure(.forbidden))
            case 404:
                print("404 Not Found")
                let errorMsg = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Not found"
                completion(.failure(.notFound))
            default:
                let errorMessage = "Error with status code: \(httpResponse.statusCode)"
                let serverMessage = (data != nil) ? String(data: data!, encoding: .utf8) ?? "No additional info" : "No additional info"
                print("\(errorMessage): \(serverMessage)")
                completion(.failure(.serverError("\(errorMessage): \(serverMessage)")))
            }
        }
        task.resume()
    }

    
    // MARK: - Helper Methods for make Request
    static func makeRequest(urlString: String, method: String, body: Data? = nil, completion: @escaping (Result<Data, NetworkError>) -> Void) {
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
        
//        print("Making request to: \(urlString)")
//        print("Method: \(method)")
//        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        
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
            
//            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            switch httpResponse.statusCode {
            case 200...299:
                if let data = data {
                    completion(.success(data))
                } else {
                    print("No data received")
                    completion(.failure(.canNotParseData))
                }
            case 400:
                let errorMsg = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Bad request"
                completion(.failure(.invalidCredentials(errorMsg)))
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
}
