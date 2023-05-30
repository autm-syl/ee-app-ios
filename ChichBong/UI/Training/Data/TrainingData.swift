//
//  TrainingData.swift
//  ChichBong
//
//  Created by autm on 31/12/2021.
//

import Foundation

class TrainingData: NSObject {

    func getAllQuestCategoryData(completion: @escaping([QuestCategory], BaseResponseError?) -> Void) {
        MonConnection.requestCustom(APIRouter.getAllQuestCategories) { result, error in
            //
            if error == nil {
                // xu ly result
                let questCateResult = QuestCategoryResult.init(JSON: result!)
                
                if questCateResult!.categories.count > 0 {
                    completion(questCateResult!.categories, nil)
                } else {
                    completion([], BaseResponseError.init(.API_ERROR, 40001, "Data empty"))
                }
                
            } else {
                completion([], error)
            }
        }
    }
    
    func getAllQuestLevelData(completion: @escaping([QuestLevel], BaseResponseError?) -> Void) {
        MonConnection.requestCustom(APIRouter.getAllQuestLevel) { result, error in
            //
            if error == nil {
                // xu ly result
                let questCateResult = QuestLevelResult.init(JSON: result!)
                
                if questCateResult!.levels.count > 0 {
                    completion(questCateResult!.levels, nil)
                } else {
                    completion([], BaseResponseError.init(.API_ERROR, 40001, "Data empty"))
                }
                
            } else {
                completion([], error)
            }
        }
    }
    
    func getQuestbyCategoryId(categoryId: Int, completion: @escaping(QuestsData?, BaseResponseError?) -> Void) {
        MonConnection.requestCustom(APIRouter.getQuestsByCategoryId(categoryId)) { result, error in
            if error == nil {
                // xu ly result
                let questResult = QuestsResult.init(JSON: result!)
                
                if questResult!.data != nil {
                    completion(questResult!.data, nil)
                } else {
                    completion(nil, BaseResponseError.init(.API_ERROR, 40001, "Data empty"))
                }
                
            } else {
                completion(nil, error)
            }
        }
    }
    
    func getQuestbyCategoryLevel(level: Int, completion: @escaping(QuestsData?, BaseResponseError?) -> Void) {
        MonConnection.requestCustom(APIRouter.getQuestsByLevel(level)) { result, error in
            if error == nil {
                // xu ly result
                let questResult = QuestsResult.init(JSON: result!)
                
                if questResult!.data != nil {
                    completion(questResult!.data, nil)
                } else {
                    completion(nil, BaseResponseError.init(.API_ERROR, 40001, "Data empty"))
                }
                
            } else {
                completion(nil, error)
            }
        }
    }
}
