import SwiftUI

struct DifficultyCard: View {
    let title: String
    let subtitle: String
    let symbol: String
    let symbolCount: Int
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                HStack(spacing: 4) {
                    ForEach(0..<symbolCount, id: \.self) { _ in
                        Image(systemName: symbol)
                    }
                }
                .font(.system(size: 23, weight: .bold))
                .foregroundStyle(color)
                .frame(width: 86, alignment: .leading)

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(color)

                    Text(subtitle)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(AppColors.ink)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(color)
                    .frame(width: 20)
            }
            .padding(.leading, 24)
            .padding(.trailing, 18)
            .frame(height: 108)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.035))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.24), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}
