//
//  LoadingView.swift
//  XKCDComicViewerApp
//
//  Created by milad yalda on 2026-02-05.
//

import SwiftUI

// MARK: - LoadingView

struct LoadingView: View {

    // MARK: - Properties

    let message: String

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text(message)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    LoadingView(message: "Loading...")
}
