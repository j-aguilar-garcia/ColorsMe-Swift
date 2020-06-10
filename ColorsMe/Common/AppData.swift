//
//  AppData.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 25.05.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import Foundation

/// Wrapper for the UserDefaults
struct AppData {
    
    /// Checks the iCloud sync status
    @Storage(key: "allowCloudSync", defaultValue: true)
    static var iCloudDataSyncIsEnabled: Bool
    
    /// Checks when the Snapshots should be displayed
    @Storage(key: "allowSnapshotsColorMe", defaultValue: true)
    static var shouldDisplaySnapshots: Bool

    /// Checks whether a synchronization has already taken place
    @Storage(key: "cloudSyncHasData", defaultValue: false)
    static var iCloudHasData: Bool
    
    /// Checks whether a synchronization has already taken place
    @Storage(key: "cloudSyncDone", defaultValue: false)
    static var iCloudHasSynced: Bool
    
    /// Last cloud sync as date
    @Storage(key: "lastCloudSync", defaultValue: Date())
    static var lastCloudSync: Date
    
    /// Determines the first start of the app
    @Storage(key: "isFirstStart", defaultValue: false)
    static var isFirstStart: Bool
    
    /// Last backendless sync as date
    @Storage(key: "backendlessLastSyncTimeStamp", defaultValue: nil)
    static var backendlessSyncTimeStamp: Date?
    
    /// Last selected ColorMapLayerItem - .defaultmap - .heatmap - .clustermap
    @Storage(key: "ColorMapLayerItemCurrentVisible", defaultValue: ColorMapLayerType.defaultmap.rawValue)
    static var colorMapLayerItem: ColorMapLayerType.RawValue
    
    
    // MARK: - PickerDialog
    
    /// The index of the filter of the ColorMap
    @Storage(key: "selected", defaultValue: 0)
    static var selectedFilterIndex: Int
    
    /// Selected index of DialogPicker
    @Storage(key: "selectedFilterCount", defaultValue: 0)
    static var selectedFilterCount: Int
    
    /// Selected name of DialogPicker
    @Storage(key: "selectedFilterName", defaultValue: "All Colors")
    static var selectedFilterName: String
    
    /// Store selected Date
    @Storage(key: "selectedFilterDate", defaultValue: Date())
    static var selectedFilterDate: Date
    
}


@propertyWrapper
struct Storage<T> {
    
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}


