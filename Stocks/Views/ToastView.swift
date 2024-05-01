//
//  ToastView.swift
//  Stocks
//
//  Created by Vedanth Subramaniam on 4/30/24.
//

import SwiftUI

struct ToastView: View {
    var message: String
    @Binding var isShowing: Bool

    var body: some View {
        Text(message)
            .padding()
            .background(Color.gray)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            .opacity(isShowing ? 1 : 0)
            .animation(.easeInOut, value: isShowing)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.isShowing = false
                }
            }
    }
}

