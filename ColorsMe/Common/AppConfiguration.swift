//
//  AppConfiguration.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 26.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

class AppConfiguration {
    
    static let `default` = AppConfiguration()
    
    var backendlessServerUrl: String!
    var backendlessApiKey: String!
    var backendlessAppKey: String!
    
    var swiftyBeaverAppId: String!
    var swiftyBeaverAppSecret: String!
    var swiftyBeaverEncryptionKey: String!
    
    var sentryDsn: String!
    
    var appStoreUrl: String!
    var appUrlHost: String!
    
    var aboutUs: String!
    var privacyPolicy: String!
    
    var aboutUsUrl: String!
    var privacyPolicyUrl: String!
    
    init() {
        let bundleURL = Bundle.main.url(forResource: "AppProperties", withExtension: "plist")!
        let plist = NSDictionary(contentsOf: bundleURL)!
        
        backendlessServerUrl = plist["backendless_server_url"] as? String
        backendlessApiKey = plist["backendless_api_key"] as? String
        backendlessAppKey = plist["backendless_application_key"] as? String
        
        swiftyBeaverAppId = plist["swiftybeaver_app_id"] as? String
        swiftyBeaverAppSecret = plist["swiftybeaver_app_secret"] as? String
        swiftyBeaverEncryptionKey = plist["swiftybeaver_encryption_key"] as? String
        sentryDsn = plist["sentry_dsn"] as? String
        
        appStoreUrl = plist["app_store_url"] as? String
        appUrlHost = plist["app_url_host"] as? String
        
        aboutUs = plist["about_us"] as? String
        privacyPolicy = plist["data_protection"] as? String
        
        aboutUsUrl = plist["about_us_url"] as? String
        privacyPolicyUrl = plist["data_protection_url"] as? String
    }
    
}
