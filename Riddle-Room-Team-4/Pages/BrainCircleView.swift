//
//  BrainCircleView.swift
//  Riddle-Room-Team-4
//
//  Placeholder for the Brain Circle / Friends page.
//

import SwiftUI

struct BrainCircleView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundStyle(.indigo)

            Text("Brain Circle")
                .font(.title)
                .fontWeight(.bold)

            Text("Coming soon")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview {
    BrainCircleView()
}
