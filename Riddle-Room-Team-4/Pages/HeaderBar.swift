import SwiftUI

struct HeaderBar: View {
    let title: String
    var onBack: (() -> Void)?
    @Environment(\.appFontScale) var fontScale

    var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: 18 * fontScale, weight: .bold))
                .foregroundStyle(AppColors.ink)

            HStack {
                Button {
                    onBack?()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(AppColors.ink)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Back")

                Spacer()

                Image(systemName: "lightbulb")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(AppColors.ink)
                    .frame(width: 44, height: 44)
                    .accessibilityLabel("Hint")
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 48)
    }
}
