//
//  FirebaseRemoteConfigManager.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 15.08.2024.
//

import FirebaseRemoteConfig

class RemoteConfigManager {
    static let shared = RemoteConfigManager()
    private var remoteConfig = RemoteConfig.remoteConfig()

    private init() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600 // 1 hour
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults([
            "openAIKey": "" as NSObject,
            "revenueCatKey": "" as NSObject
        ])
    }

    func fetchOpenAIAPIKey(completion: @escaping (String?) -> Void) {
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                let apiKey = self.remoteConfig["openAIKey"].stringValue
                completion(apiKey)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchRevenueCatAPIKey(completion: @escaping (String?) -> Void) {
        remoteConfig.fetchAndActivate { status, error in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                let sdkKey = self.remoteConfig["revenueCatKey"].stringValue
                completion(sdkKey)
            } else {
                completion(nil)
            }
        }
    }
}

