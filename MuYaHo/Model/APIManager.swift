import Foundation

// MARK: - APIManager

class APIManager {
    
    static let shared = APIManager()
    private let baseURL = "http://158.247.255.105:8000"
    private let session = URLSession.shared
    
    private init() {}
}

// MARK: - Endpoints and Methods

extension APIManager {
    
    enum APIEndpoint: String {
        case test = "/test"
        case signIn = "/v1/auth/sign-in"
        case updateUser = "/v1/users/me"
        case sendLetter = "/v1/letters"
        case randomLetter = "/v1/letters/random"
        case specificLetter = "/v1/letters/{letterUUID}"
        case likeLetter = "/v1/letters/{letterUUID}/like"
    }

    enum RequestMethod: String {
        case get = "GET"
        case post = "POST"
    }
}

// MARK: - Data Models

extension APIManager {
    
    struct TokenRequest: Codable {
        let deviceId: String
    }
    
    struct TokenResponse: Codable {
        let data: TokenData
    }
    
    struct TokenData: Codable {
        let accessToken: String
    }
    
    struct LetterRequest: Codable {
        let content: String
    }
    
    struct LetterResponse: Codable {
        let data: Bool
    }
    
    struct UpdateUserRequest: Codable {
        let nickname: String
        let sound: Bool
        let alarm: Bool
    }
    
    struct UserResponse: Codable {
        let data: UserData
    }
    
    struct UserData: Codable {
        let nickname: String
        let point: Int
        let send: Int
        let receive: Int
        let sound: Bool
        let alarm: Bool
    }
    
    struct LetterError: Codable {
        let message: String
        let code: Int
        let errors: ErrorData
    }
    
    struct ErrorData: Codable {
        let data: String?
        let message: String?
    }
}



// MARK: - API Calls

extension APIManager {


    //1
    func fetchTestData(completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = APIEndpoint.test.rawValue
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestMethod.get.rawValue
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            if let message = String(data: data, encoding: .utf8) {
                completion(.success(message))
            } else {
                completion(.failure(APIError.dataDecodingError))
            }
        }
        
        task.resume()
    }

    
    
    //2
    static func storeUUIDInKeychain(uuid: String) {
        let uuidData = Data(uuid.utf8)
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userUUID",
            kSecValueData as String: uuidData
        ]
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }

    
    
    //3
    static func getUUIDFromKeychain() -> String? {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userUUID",
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data, let uuid = String(data: data, encoding: .utf8) {
                return uuid
            }
        }
        
        return nil
    }

    
    
    //4
    static func storeTokenInKeychain(token: String) {
        let tokenData = Data(token.utf8)
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userToken",
            kSecValueData as String: tokenData
        ]
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }

    
    //5
    func requestTokenWithUUID(uuid: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = APIEndpoint.signIn.rawValue
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestMethod.post.rawValue
        
        let body = TokenRequest(deviceId: uuid)
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            completion(.failure(APIError.dataEncodingError))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    let tokenResponse = try decoder.decode(TokenResponse.self, from: jsonData)
                    completion(.success(tokenResponse.data.accessToken))
                } catch {
                    completion(.failure(APIError.dataDecodingError))
                }
            } else {
                completion(.failure(APIError.unknownError))
            }
        }
        task.resume()
    }
    
    
    //6
    static func getTokenFromKeychain() -> String? {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "userToken",
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data, let token = String(data: data, encoding: .utf8) {
                return token
            }
        }
        
        return nil
    }

    
    // Send Message
    func sendMessage(content: String, accessToken: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = APIEndpoint.sendLetter.rawValue
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestMethod.post.rawValue
        
        let body = LetterRequest(content: content)
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } catch {
            completion(.failure(APIError.dataEncodingError))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            if response.statusCode == 200 {
                if let jsonData = data {
                    do {
                        let decoder = JSONDecoder()
                        let letterResponse = try decoder.decode(LetterResponse.self, from: jsonData)
                        completion(.success(letterResponse.data))
                    } catch {
                        completion(.failure(APIError.dataDecodingError))
                    }
                } else {
                    completion(.failure(APIError.unknownError))
                }
            } else {
                
                
                if let jsonData = data {
                    do {
                        let decoder = JSONDecoder()
                        let errorResponse = try decoder.decode(LetterError.self, from: jsonData)
                        print("Received error response: \(errorResponse)")
                        completion(.failure(APIError.unknownError)) // Modify this to handle specific errors if needed
                    } catch {
                        print("Failed to decode error response. Raw data: \(String(data: jsonData, encoding: .utf8) ?? "N/A")")
                        completion(.failure(APIError.dataDecodingError))
                    }
                } else {
                    completion(.failure(APIError.unknownError))
                }
            }
        }
        task.resume()
    }
    
    // Update User Details
    func updateUserDetails(nickname: String, sound: Bool, alarm: Bool, accessToken: String, completion: @escaping (Result<UserData, Error>) -> Void) {
        let endpoint = APIEndpoint.updateUser.rawValue
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestMethod.post.rawValue
        
        let body = UpdateUserRequest(nickname: nickname, sound: sound, alarm: alarm)
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } catch {
            completion(.failure(APIError.dataEncodingError))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    let userResponse = try decoder.decode(UserResponse.self, from: jsonData)
                    completion(.success(userResponse.data))
                } catch {
                    completion(.failure(APIError.dataDecodingError))
                }
            } else {
                completion(.failure(APIError.unknownError))
            }
        }
        task.resume()
    }
}


// MARK: - API Errors

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case dataDecodingError
    case dataEncodingError
    case unknownError
}
