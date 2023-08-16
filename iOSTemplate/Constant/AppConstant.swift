//
//  AppConstant.swift
//  iOSTemplate
//
//  Created by ThangTQ on 14/08/2023.
//

import Foundation

struct AppConstant {
    
    struct Authorization {
        public static let AUTH_TOKEN: String = "AUTH_TOKEN"
        public static let REFRESH_TOKEN: String = "REFRESH_TOKEN"
    }
    
    struct Api {
        public static let BASE_URL = "http://localhost:8085/api"
        public static let LOGIN = "/login"
        public static let GET_POST = "/post"
        public static let REFRESH_TOKEN = "/refresh-token"
        public static let GET_CATEGORY = "/category"
        public static let GET_POST_BY_CATEGORY_ID = "/post/category"
    }
}

