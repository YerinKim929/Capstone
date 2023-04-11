//
//  CapstoneProjectApp.swift
//  CapstoneProject
//
//  Created by Yerin Kim on 2023/04/05.
//

import SwiftUI

@main
struct CapstoneProjectApp: App {
    var body: some Scene {
        WindowGroup {
            CalendarView()
            //ContentView()
        }
    }
}
struct CalendarView: UIViewControllerRepresentable{
    typealias UIViewControllerType = CalendarViewController
    
    func makeUIViewController(context: Context) -> CalendarViewController {
        let vc = CalendarViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
    }
     
}

