import Foundation

struct ExpenseCreateResponse: Decodable {
    let isSuccess: Bool
    let message: String
    let result: ExpenseResponse

    enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
  
    struct ExpenseResponse: Decodable {
        let expenseId: Int64
        let alarms: [AlarmControlDTO]?

        enum CodingKeys: String, CodingKey {
            case expenseId
            case alarms
            
        }

        struct AlarmControlDTO: Decodable {
            let alarmTitle: String?
            let budget: Int64?
            let excessAmount: Int64?

            enum CodingKeys: String, CodingKey {
                case alarmTitle
                case budget
                case excessAmount
                init(from decoder: Decoder) throws {
                       let container = try decoder.container(keyedBy: CodingKeys.self)
                       
                       if container.contains(.alarmTitle) {
                           self = .alarmTitle
                       } else if container.contains(.budget) {
                           self = .budget
                       } else if container.contains(.excessAmount) {
                           self = .excessAmount
                       } else {
                           // Handle unknown case or set a default value
                           throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unknown key"))
                       }
                   }
            }

            enum AlarmTitle: String, Decodable {
                case day = "하루"
                case category = "카테고리"
                case all = "전체"
            }
        }
    }
    

    
}
