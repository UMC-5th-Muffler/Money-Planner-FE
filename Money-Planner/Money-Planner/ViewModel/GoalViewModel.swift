//
//  GoalViewModel.swift
//  Money-Planner
//
//  Created by 유철민 on 1/12/24.
//

import Foundation
import Moya

class GoalViewModel: ObservableObject {
    
    static let shared = GoalViewModel()
    
    @Published var goals: [Goal]
    
    var pastGoals: [Goal] {
        print(goals.filter { $0.goalEnd < Date() })
        return goals.filter { $0.goalEnd < Date() }
    }
    
    var currentGoals: [Goal] {
        return goals.filter { $0.goalStart <= Date() && Date() <= $0.goalEnd }
    }
    
    var futureGoals: [Goal] {
        return goals.filter { $0.goalStart > Date() }
    }
    
    var notCurrentGoals: [Goal] {
        return goals.filter { $0.goalStart > Date() || Date() > $0.goalEnd }
    }
    
    enum GoalError: String, Error {
        case goalNameExists = "goal name already exists"
        case unknownError = "Unknown error occurred"
    }
    
    init() {
//        self.goals = [pastGoal1, pastGoal2, pastGoal3, currentGoal] //dummy data
//        self.goals = [currentGoal] //dummy data
        self.goals = [futureGoal, pastGoal1, pastGoal2, pastGoal3] //dummy data
    }
    
    func goalExistsWithName(goalName: String?) -> Bool {
        return goals.contains { $0.goalName == goalName }
    }
    
//    private func requestUsergoal(uuid: String, completion: @escaping ([Goal]?) -> Void) {
//        NetworkManager.shared.goal_provider.request(
//            .loadGoal(type: "uuid", identifier: uuid)
//        ) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    let loadGoalResponse = try JSONDecoder().decode(LoadGoalResponse.self, from: response.data)
//                    let Goals = loadGoalResponse.map {
////                        Goal(
////                            id: $0.id,
////                            goal_name: $0.name,
////                            goal_icon: $0.icon,
////                            goal_time: $0.alarmTime,
////                            created_at: ISO8601DateFormatter().date(from: $0.createdAt) ?? Date()
////                        )
//                    }
//                    completion(Goals)
//                } catch {
//                    print("JSON decoding error: \(error)")
//                    completion(nil)
//                }
//            case .failure(let error):
//                print("네트워크 에러: \(error)")
//                completion(nil)
//            }
//        }
//    }
    
    
    
//    func browseGoalFromServer(uuid: String) {
//        //        /// TODO : 서버에서 사용자 goal 불러오기
//        //        let response: [Goal] = requestUsergoal(uuid: uuid)
//        //
//        //        /// GET /goal
//        //        /// queryString : type=uuid&identifier={uuid}
//        //
//        //        self.goals = response
//
//        requestUsergoal(uuid: uuid) { [weak self] Goals in
//            if let Goals = Goals {
//                self?.goals = Goals
//            }
//        }
//    }
    
//    func getGoalList(uuid: String) -> [Goal] {
//        self.browseGoalFromServer(uuid: uuid)
//        return self.goals
//    }
//
//    func addGoal(uuid: String!, name: String, icon: String, time: String, completion: @escaping (Result<String, Error>) -> Void) {
//        /// TODO :: User의 UUID와 Alarm goal 정보 받고 처리
//
//        /// POST /goal
//        /// body : type, identifier, name, icon, alarm_time
//        let requestBody = CreateGoalRequest(
//            type: "uuid",
//            identifier: uuid,
//            name: name,
//            icon: icon,
//            alarmTime: time
//        )
//
//        /// - alarm_time 형식 -> "HH:MM:SS" (10 미만이면 0 끼워 넣어야함 ex: "08:00:00")
//
//        /// 성공적으로 추가했다면, 응답에서 id을 반환받아서, Goal 객체를 새로 정의해서 goals 배열에 넣고
//        /// 실패했다면 alert 등을 띄우기
//        ///
//        NetworkManager.shared.goal_provider.request(.createGoal(params: requestBody)) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    let addedGoal = try JSONDecoder().decode(GoalResponse.self, from: response.data)
//                    if addedGoal.msg == "Alarm goal created and linked with user" {
//                        self.browseGoalFromServer(uuid: requestBody.identifier)
//                        completion(.success("Alarm goal created"))
//                    }
//                    else if addedGoal.msg == "goal name already exists" {
//                        completion(.failure(GoalError.goalNameExists))
//                    }
//                    else{
//                        completion(.failure(GoalError.unknownError))
//                    }
//
//                } catch {
//                    print("JSON decoding error: \(error)")
//                    completion(.failure(error))
//                    // Handle decoding error or show an alert
//                }
//            case .failure(let error):
//                print("Network error: \(error)")
//                completion(.failure(error))
//                // Handle network error or show an alert
//            }
//        }
//
//    }
//
//    func editGoal(uuid: String!, goal_id: Int, name: String?, icon: String?, alarm_time: String?, completion: @escaping (Result<String, Error>) -> Void) {
//        /// TODO :: User의 UUID와 Alarm goal 정보 받고 처리
//
//        /// PUT /goal/:goal_id
//        /// queryString : type=uuid&identifier={uuid}
//        /// body: 수정되는 부분만 body에 담아서 보내면 됨
//        ///  ex: { title: "수정할 제목" }
//
//        /// 성공적으로 수정했다면, 수정한 부분만 값 반영
//        /// 실패했다면 alert 등을 띄우기
//        /// "Alarm goal and its references deleted successfully"
//        var params: [String: Any] = ["type": "uuid", "identifier": uuid!]
//
//        if let name = name { params["name"] = name }
//        if let icon = icon { params["icon"] = icon }
//        if let alarm_time = alarm_time { params["alarm_time"] = alarm_time }
//
//        NetworkManager.shared.goal_provider.request(.updateGoal(type: "uuid", identifier: uuid, goal_id: goal_id, name: name, icon: icon, alarm_time: alarm_time)) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    let editedGoal = try JSONDecoder().decode(GoalResponse.self, from: response.data)
//                    if editedGoal.msg == "Alarm goal updated successfully" {
//                        self.browseGoalFromServer(uuid: uuid)
//                        completion(.success("Alarm goal updated"))
//                    } else {
//                        completion(.failure(GoalError.unknownError))
//                    }
//                } catch {
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func deleteGoal(uuid: String!, goal_id: Int, completion: @escaping (Result<String, Error>) -> Void) {
//        /// TODO :: User의 UUID와 goal_id를 받아서 삭제
//
//        /// DELETE /goal/:goal_id
//        /// queryString : type=uuid&identifier={uuid}
//
//        /// 성공적으로 삭제했다면, 리스트에서 메모 삭제
//        /// 실패했다면 alert 등을 띄우기
//        if(goal_id <= 2){ //2번까지는 디폴트니까 건들지 말아야 됨.
//            return //귀찮,,,
//        }
//
//        NetworkManager.shared.goal_provider.request(.deleteGoal(type: "uuid", identifier: uuid, goal_id: goal_id)) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    let deleteResponse = try JSONDecoder().decode(GoalResponse.self, from: response.data)
//                    if deleteResponse.msg == "Alarm goal and its references deleted successfully" {
//                        // Delete the goal from the local array
//                        self.goals.removeAll { $0.id == goal_id }
//                        completion(.success("Alarm goal deleted"))
//                    } else {
//                        completion(.failure(GoalError.unknownError))
//                    }
//                } catch {
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
}

// GoalCreationManager
class GoalCreationManager {
    static let shared = GoalCreationManager()

    var goalEmoji: String?
    var goalName: String?
    var goalAmount: Int64?
    var goalStart: Date?
    var goalEnd: Date?
 
    private init() {} // Private initializer to ensure singleton usage

    func createGoalRequest() -> CreateGoalRequest? {
        guard let goalEmoji = goalEmoji,
              let goalName = goalName,
              let goalAmount = goalAmount,
              let goalStart = goalStart,
              let goalEnd = goalEnd else {
            return nil
        }

        return CreateGoalRequest(goalEmoji: goalEmoji, goalName: goalName, goalAmount: goalAmount, goalStart: goalStart, goalEnd: goalEnd)
    }

    func clear() {
        goalEmoji = nil
        goalName = nil
        goalAmount = nil
        goalStart = nil
        goalEnd = nil
    }
}
