//
//  StandardData.swift
//  ChichBong
//
//  Created by autm on 18/01/2022.
//

import Foundation

class StandardData: NSObject {

    func getAllStandardData(completion: @escaping(Documentations?, BaseResponseError?) -> Void) {
        MonConnection.requestCustom(APIRouter.getAllDocumentation(documentType: DocumentType.File, pageSize: 10000, pageIndex: 1, nameQuery: "", status: -1)) { result, error in
            //
            if error == nil {
                // xu ly result
                let documentationResult = DocumentationResult.init(JSON: result!)
                
                if documentationResult!.Data != nil {
                    completion(documentationResult!.Data, nil)
                } else {
                    completion(nil, BaseResponseError.init(.API_ERROR, 40001, "Data empty"))
                }
                
            } else {
                completion(nil, error)
            }
        }
    }
}
