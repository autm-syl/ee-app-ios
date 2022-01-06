//
//  HomeViewData.swift
//  ChichBong
//
//  Created by autm on 17/12/2021.
//

import Foundation


class HomeViewData: NSObject {

    func getAllCategory(completion: @escaping([CategoryTreeData?], Error?) -> Void) {
        MonConnection.requestCustom(APIRouter.getAllCategory) { [self] result, error in
            //
            if error == nil {
                // xu ly result
                let update_result = CategoryResult.init(JSON: result!)

                var root:CategoryTreeData = CategoryTreeData(id: 0, name: "", description: "", content: "", docid: 0, created_at: "", updated_at: "")
                let resultx = foundAddChild(goctrave: update_result!.categories, hientai:[root])
                completion(resultx, nil)
            } else {
                completion([], nil)
            }
        }
        
        
    }
    
    
    
    func foundAddChild(goctrave: [Category], hientai: [CategoryTreeData]) -> [CategoryTreeData] {
        
        let cache_hientai = hientai;
        for i in 0...hientai.count - 1 {
            let childo = hientai[i]
            let hientaiChild:[CategoryTreeData] = []
            let parentIdHientai = childo.id
            cache_hientai[i].children = hientaiChild
            
            for x in 0...goctrave.count - 1 {
                if (goctrave[x].parent == parentIdHientai) {
                    let obj = CategoryTreeData(id: goctrave[x].id, name: goctrave[x].name, description: goctrave[x].description, content: goctrave[x].content, docid: goctrave[x].docid, created_at: goctrave[x].created_at, updated_at: goctrave[x].updated_at)
                    cache_hientai[i].children.append(obj)
                }
            }
            
            if cache_hientai[i].children.count > 0 {
                _ = foundAddChild(goctrave: goctrave, hientai: cache_hientai[i].children)
            } else {
                let obj = CategoryTreeData(id: cache_hientai[i].id, name: "",
                                           description: "", content: cache_hientai[i].content, docid: cache_hientai[i].docid, created_at: "", updated_at: "")
                obj.isHtml = true;
                cache_hientai[i].children.append(obj)
            }

        }
        return cache_hientai;
    }
}
