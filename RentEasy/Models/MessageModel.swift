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
