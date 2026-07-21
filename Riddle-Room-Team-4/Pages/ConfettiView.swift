import SwiftUI

struct ConfettiView: View {
    private let particles: [ConfettiParticle] = (0..<160).map { index in
        let colors = [AppColors.orange, AppColors.green, AppColors.purple, AppColors.red]
        let shapes: [ConfettiShape] = [.rectangle, .circle, .capsule]
        let side: ConfettiSide = randomValue(seed: index, salt: 7) < 0.5 ? .left : .right
        let direction: Double = side == .left ? 1 : -1
        let launchAngle = degreesToRadians(38 + randomValue(seed: index, salt: 17) * 92)
        let speed = 420 + randomValue(seed: index, salt: 31) * 380

        return ConfettiParticle(
            side: side,
            startXOffset: randomValue(seed: index, salt: 43) * 96,
            startYOffset: randomValue(seed: index, salt: 59) * 90,
            xVelocity: direction * cos(launchAngle) * speed,
            yVelocity: sin(launchAngle) * speed,
            xDrift: direction * (randomValue(seed: index, salt: 73) * 280 - 140),
            wobbleAmount: randomValue(seed: index, salt: 89) * 42,
            wobbleSpeed: 2.4 + randomValue(seed: index, salt: 97) * 4.2,
            gravity: 360 + randomValue(seed: index, salt: 109) * 220,
            delay: randomValue(seed: index, salt: 127) * 0.62,
            color: colors[Int(randomValue(seed: index, salt: 139) * Double(colors.count)) % colors.count],
            rotation: randomValue(seed: index, salt: 151) * 360,
            spin: direction * (220 + randomValue(seed: index, salt: 167) * 760),
            shape: shapes[Int(randomValue(seed: index, salt: 181) * Double(shapes.count)) % shapes.count],
            sizeScale: 0.68 + randomValue(seed: index, salt: 197) * 0.78,
            lifetime: 2.15 + randomValue(seed: index, salt: 211) * 1.1
        )
    }

    @State private var startDate = Date()

    var body: some View {
        TimelineView(.animation) { timeline in
            GeometryReader { geometry in
                ForEach(particles) { particle in
                    let elapsedTime = max(0, timeline.date.timeIntervalSince(startDate) - particle.delay)
                    let position = particle.position(in: geometry.size, elapsedTime: elapsedTime)

                    RoundedRectangle(cornerRadius: particle.cornerRadius)
                        .fill(particle.color)
                        .frame(width: particle.width, height: particle.height)
                        .rotationEffect(.degrees(particle.rotation + particle.spin * elapsedTime))
                        .position(position)
                        .opacity(particle.opacity(elapsedTime: elapsedTime))
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .onAppear {
            startDate = Date()
        }
    }
}

private struct ConfettiParticle: Identifiable {
    let id = UUID()
    let side: ConfettiSide
    let startXOffset: Double
    let startYOffset: Double
    let xVelocity: Double
    let yVelocity: Double
    let xDrift: Double
    let wobbleAmount: Double
    let wobbleSpeed: Double
    let gravity: Double
    let delay: Double
    let color: Color
    let rotation: Double
    let spin: Double
    let shape: ConfettiShape
    let sizeScale: Double
    let lifetime: Double

    var width: CGFloat {
        CGFloat(shape == .circle ? 9 : 8) * sizeScale
    }

    var height: CGFloat {
        CGFloat(shape == .circle ? 9 : 15) * sizeScale
    }

    var cornerRadius: CGFloat {
        switch shape {
        case .circle:
            return 4.5
        case .rectangle:
            return 1
        case .capsule:
            return 4
        }
    }

    func position(in size: CGSize, elapsedTime: TimeInterval) -> CGPoint {
        let startX = side == .left ? -24.0 + startXOffset : Double(size.width) + 24.0 - startXOffset
        let startY = Double(size.height) + 22.0 - startYOffset
        let wobble = sin(elapsedTime * wobbleSpeed) * wobbleAmount
        let x = startX + xVelocity * elapsedTime + xDrift * elapsedTime * elapsedTime + wobble
        let y = startY - yVelocity * elapsedTime + 0.5 * gravity * elapsedTime * elapsedTime

        return CGPoint(x: x, y: y)
    }

    func opacity(elapsedTime: TimeInterval) -> Double {
        guard elapsedTime > 0, elapsedTime < lifetime else { return 0 }
        let fadeStart = lifetime * 0.76

        if elapsedTime < fadeStart {
            return 1
        }

        return max(0, 1 - (elapsedTime - fadeStart) / (lifetime - fadeStart))
    }
}

private enum ConfettiSide {
    case left
    case right
}

private enum ConfettiShape {
    case circle
    case rectangle
    case capsule
}

private func randomValue(seed: Int, salt: Int) -> Double {
    var value = UInt64(seed &+ salt &* 374_761_393)
    value = (value ^ (value >> 13)) &* 1_274_126_177
    value = value ^ (value >> 16)
    return Double(value % 10_000) / 10_000.0
}

private func degreesToRadians(_ degrees: Double) -> Double {
    degrees * .pi / 180
}
