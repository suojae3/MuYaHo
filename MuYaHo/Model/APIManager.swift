import Foundation
import Alamofire
// MARK: - APIManager

class APIManager {
    
    static let shared = APIManager()
    private let baseURL = "http://158.247.255.105:8000"
    
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
    
    struct LetterSuccess: Codable {
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
    
    struct LetterResponse: Codable {
        let data: LetterData
    }
    
    struct LetterData: Codable {
        let user: String
        let content: String
        let like: Int
    }
    
    
}



// MARK: - API Calls

extension APIManager {
    
    
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
    
    
    // Request Token
    func requestTokenWithUUID(uuid: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = baseURL + APIEndpoint.signIn.rawValue
        let parameters: [String: Any] = ["deviceId": uuid]
        
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: TokenResponse.self) { response in
            switch response.result {
            case .success(let tokenResponse):
                completion(.success(tokenResponse.data.accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
        let endpoint = baseURL + APIEndpoint.sendLetter.rawValue
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = ["content": content]
        
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: LetterSuccess.self) { response in
            switch response.result {
            case .success(let letterResponse):
                completion(.success(letterResponse.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Update User Details
    func fetchUserDetails(accessToken: String, completion: @escaping (Result<UserData, Error>) -> Void) {
        let endpoint = baseURL + APIEndpoint.updateUser.rawValue
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(endpoint, headers: headers).responseDecodable(of: UserResponse.self) { response in
            switch response.result {
            case .success(let userResponse):
                completion(.success(userResponse.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    // Fetch Random Letter
    func fetchRandomLetter(accessToken: String, completion: @escaping (Result<LetterData, APIError>) -> Void) {
        let endpoint = baseURL + APIEndpoint.randomLetter.rawValue
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(endpoint, headers: headers).responseDecodable(of: LetterResponse.self) { response in
            switch response.result {
            case .success(let letterResponse):
                completion(.success(letterResponse.data))
            case .failure(_):
                if let data = response.data {
                    do {
                        let errorResponse = try JSONDecoder().decode(LetterError.self, from: data)
                        switch errorResponse.code {
                        case 1202:
                            completion(.failure(.pointNotEnough))
                        case 1205:
                            completion(.failure(.letterNotLeft))
                        default:
                            completion(.failure(.unknownError))
                        }
                    } catch {
                        completion(.failure(.dataDecodingError))
                    }
                } else {
                    completion(.failure(.unknownError))
                }
            }
        }
    }
    
}


// MARK: - API Errors
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case dataDecodingError
    case dataEncodingError
    case unknownError
    
    case pointNotEnough
    case letterNotLeft
}


