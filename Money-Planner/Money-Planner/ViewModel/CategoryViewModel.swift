//
//  CategoryViewModel.swift
//  Money-Planner
//
//  Created by 유철민 on 1/27/24.
//

import Foundation

class CategoryViewModel: ObservableObject {
    
    static let shared = CategoryViewModel()
    
    @Published var categories: [Category]
    
    init() {
        // 예시 데이터로 초기화
        self.categories = [
            // 초기화할 Category 객체들
        ]
    }
    
    // 카테고리가 이미 있는지 확인하는 메서드
    func categoryExistsWithName(_ categoryName: String) -> Bool {
        return categories.contains { $0.name == categoryName }
    }
    
    // 카테고리를 추가하는 메서드
    func addCategory(name: String, budget: Int) {
        // 카테고리 이름 중복 확인
        guard !categoryExistsWithName(name) else {
            // 처리: 카테고리 이름이 이미 존재할 경우
            return
        }
        
        // 새 카테고리 객체 생성 및 목록에 추가
        let newCategory = Category(id: categories.count + 1, name: name, categoryBudget: budget)
        categories.append(newCategory)
        
        // TODO: 서버에 카테고리 추가 요청 보내기
    }
    
    // 기타 필요한 메서드들...
}


class CategoryCreationManager {
    static let shared = CategoryCreationManager()

    // 생성 중인 카테고리들을 저장할 배열
    var creatingCategories: [Category] = []

    private init() {} // Private initializer to ensure singleton usage

    // 카테고리 생성 요청 메서드
    func createCategory(name: String, budget: Int) {
        let newCategory = Category(id: creatingCategories.count + 1, name: name, categoryBudget: budget)
        creatingCategories.append(newCategory)
    }

    // 모든 생성 중인 카테고리를 클리어하는 메서드
    func clearCreatingCategories() {
        creatingCategories.removeAll()
    }

    // 실제 네트워크 요청을 보낼 때 사용될 데이터 구조체를 만드는 메서드
    // 예를 들어, 여러 카테고리를 한 번에 서버로 전송하는 경우에 사용될 수 있습니다.
    func createCategoriesRequest() -> [CreateCategoryRequest] {
        return creatingCategories.map { category in
            CreateCategoryRequest(name: category.name, budget: category.categoryBudget ?? 0)
        }
    }
}

// 카테고리 생성 요청에 사용될 구조체
struct CreateCategoryRequest: Codable {
    let name: String
    let budget: Int
}

