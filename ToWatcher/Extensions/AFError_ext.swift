//
//  AFError_ext.swift
//  ToWatcher
//
//  Created by Alex Delin on 13.03.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Alamofire

extension AFError {
    var description: String {
        let error: Error!
        
        switch self {
        case .sessionTaskFailed(let err): error = err
        default: error = self
        }
        
        return error.localizedDescription.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .punctuationCharacters)
    }
}
