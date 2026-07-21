import SwiftUI

struct ProgressPill: View {
    let currentRiddle: Int
    let totalRiddles: Int

    private var progress: Double {
        guard totalRiddles > 0 else { return 0 }
        return min(Double(currentRiddle) / Double(totalRiddles), 1)
    }

    var body: some View {
        HStack(spacing: 10) {
            Text("\(currentRiddle) of \(totalRiddles)")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(Capsule().fill(AppColors.purple))

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppColors.purple.opacity(0.28))
                        .frame(height: 3)

                    Capsule()
                        .fill(AppColors.purple)
                        .frame(width: geometry.size.width * progress, height: 3)
                }
                .frame(maxHeight: .infinity)
            }
            .frame(height: 26)
        }
    }
}
