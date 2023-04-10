//
//  PlannerView.swift
//  CapstoneProject
//
//  Created by Yerin Kim on 2023/04/10.
//

import SwiftUI

struct PlannerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = PageViewControllor
    
    func makeUIViewController(context: Context) -> PageViewControllor {
        let vc = PageViewControllor()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: PageViewControllor, context: Context) {
    }
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}
