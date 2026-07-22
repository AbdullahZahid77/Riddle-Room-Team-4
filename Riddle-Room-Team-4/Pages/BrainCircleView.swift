import SwiftUI
import UIKit

// Small wrapper so String is Identifiable for fullScreenCover(item:)
private struct CircleIDItem: Identifiable {
    let id: String
}

struct BrainCircleView: View {
    @EnvironmentObject var userData: UserData
    @StateObject private var manager = BrainCircleManager()
    @Environment(\.appFontScale) var fontScale

    @State private var showingStart = false
    @State private var showingJoin  = false
    @State private var selectedCircleId: CircleIDItem? = nil

    var body: some View {
        Group {
            if manager.joinedCircles.isEmpty {
                firstTimeView
            } else {
                circleListView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea())
        .sheet(isPresented: $showingStart) {
            StartCircleView(manager: manager, username: userData.username)
                .onDisappear {
                    // Open detail of newly created circle
                    if let last = manager.joinedCircles.last {
                        selectedCircleId = CircleIDItem(id: last.id)
                    }
                }
        }
        .sheet(isPresented: $showingJoin) {
            JoinCircleView(manager: manager, username: userData.username) { joined in
                selectedCircleId = CircleIDItem(id: joined.id)
            }
        }
        .fullScreenCover(item: $selectedCircleId) { item in
            CircleDetailView(circleId: item.id, manager: manager)
                .environmentObject(userData)
        }
    }

    // MARK: - First-time screen

    private var firstTimeView: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 6) {
                Text("Brain Circle")
                    .font(.system(size: 30 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                Text("Stay connected with your friends and family\nwhile exercising your brain together.")
                    .font(.system(size: 15 * fontScale, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(AppColors.ink.opacity(0.65))
                    .lineSpacing(5)
            }
            .padding(.top, 48)
            .padding(.horizontal, 28)

            Image("group")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .padding(.top, 24)

            VStack(spacing: 14) {
                actionCard(
                    title: "Start a Circle",
                    subtitle: "Create a new Brain Circle and invite others.",
                    icon: "person.3.fill",
                    action: { showingStart = true }
                )
                actionCard(
                    title: "Join a Circle",
                    subtitle: "Enter a code to join an existing Brain Circle.",
                    icon: "arrow.right.circle.fill",
                    action: { showingJoin = true }
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)

            Spacer()
        }
    }

    // MARK: - Circle list screen

    private var circleListView: some View {
        VStack(spacing: 0) {
            // Top bar
            HStack {
                Text("Brain Circle")
                    .font(.system(size: 24 * fontScale, weight: .bold))
                    .foregroundStyle(AppColors.ink)
                Spacer()
                Button { showingJoin = true } label: {
                    Image(systemName: "person.badge.plus")
                        .font(.title2)
                        .foregroundStyle(AppColors.purple)
                }
                Button { showingStart = true } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(AppColors.purple)
                }
                .padding(.leading, 12)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 14)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(manager.joinedCircles) { circle in
                        circleRow(circle)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
    }

    private func circleRow(_ circle: BrainCircle) -> some View {
        Button {
            selectedCircleId = CircleIDItem(id: circle.id)
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.purple.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(AppColors.purple)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(circle.familyName)
                        .font(.system(size: 16 * fontScale, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                    Text(statusText(for: circle))
                        .font(.system(size: 13 * fontScale, weight: .semibold))
                        .foregroundStyle(statusColor(for: circle))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.ink.opacity(0.35))
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 14).fill(AppColors.panel))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppColors.ink.opacity(0.08), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func statusText(for circle: BrainCircle) -> String {
        if circle.finalResult == true  { return "Solved! ✓" }
        if circle.finalResult == false { return "Guessed — try again" }
        if circle.allMembersCompleted  { return "Ready to guess the final word!" }
        return "\(circle.completedCount) of \(circle.members.count) members done"
    }

    private func statusColor(for circle: BrainCircle) -> Color {
        if circle.finalResult == true  { return AppColors.green }
        if circle.allMembersCompleted  { return AppColors.orange }
        return AppColors.ink.opacity(0.5)
    }

    // MARK: - Reusable card

    private func actionCard(title: String, subtitle: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(AppColors.purple.opacity(0.12))
                        .frame(width: 56, height: 56)
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(AppColors.purple)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 18 * fontScale, weight: .bold))
                        .foregroundStyle(AppColors.ink)
                    Text(subtitle)
                        .font(.system(size: 13 * fontScale, weight: .semibold))
                        .foregroundStyle(AppColors.ink.opacity(0.60))
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColors.ink.opacity(0.35))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(RoundedRectangle(cornerRadius: 16).fill(AppColors.panel))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColors.ink.opacity(0.08), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    BrainCircleView()
        .environmentObject(UserData())
}
