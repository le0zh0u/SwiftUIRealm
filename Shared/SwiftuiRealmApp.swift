//
//  SwiftuiRealmApp.swift
//  Shared
//
//  Created by 周椿杰 on 2022/5/23.
//

import SwiftUI
import RealmSwift

@main
struct SwiftuiRealmApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.realmConfiguration, Realm.Configuration())
        }
    }
}
