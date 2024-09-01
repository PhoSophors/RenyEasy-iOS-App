struct MessageResponse: Codable {
    let status: String
    let results: Int
    let data: MessageData
}

struct AllUserMessageResponse: Codable {
    let status: String
    let results: Int
    let data: UserData
}



struct UserData: Codable {
    let users: [UserInfo]
}

struct MessageData: Codable {
    let messages: [MessageModel]
}

struct MessageModel: Codable {
    let id: String
    let senderId: String
    let receiverId: String
    let content: String
    let status: String
    let timestamp: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case senderId
        case receiverId
        case content
        case status
        case timestamp
    }
}

// MARK: - Send message model

// Model for the full response from the API
struct SendMessageModel: Codable {
    let status: String
    let data: SendMessageData
}

// Model for the 'data' field in the response
struct SendMessageData: Codable {
    let message: SendMessage
}

// Model for the message details
struct SendMessage: Codable {
    let senderId: String
    let receiverId: String
    let content: String
    let status: String
    let _id: String
    let timestamp: String
    
    private enum CodingKeys: String, CodingKey {
        case senderId = "senderId"
        case receiverId = "receiverId"
        case content = "content"
        case status = "status"
        case _id = "_id"
        case timestamp = "timestamp"
    }
}
