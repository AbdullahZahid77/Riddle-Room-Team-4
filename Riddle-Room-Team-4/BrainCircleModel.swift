import Foundation
import SwiftUI
import Combine

// MARK: - Riddle Data

struct BCMemberRiddle {
    let question: String
    let answer: String   // lowercase expected answer
}

struct BCGroupRiddle {
    let question: String
    let answer: String   // lowercase expected answer
}

struct BCRiddleSet {
    let theme: String
    let memberRiddles: [BCMemberRiddle]
    let groupRiddle: BCGroupRiddle
}

// MARK: - Circle Member

struct CircleMember: Identifiable {
    let id: UUID
    let name: String
    var hasCompleted: Bool
    var submittedAnswer: String
    let memberRiddleIndex: Int

    init(name: String, hasCompleted: Bool, submittedAnswer: String, memberRiddleIndex: Int) {
        self.id = UUID()
        self.name = name
        self.hasCompleted = hasCompleted
        self.submittedAnswer = submittedAnswer
        self.memberRiddleIndex = memberRiddleIndex
    }
}

// MARK: - Brain Circle

struct BrainCircle: Identifiable {
    let id: String          // circle code
    let familyName: String
    var members: [CircleMember]
    let riddleSet: BCRiddleSet
    let currentUserIndex: Int
    var finalGuess: String
    var finalResult: Bool?  // nil = not guessed yet

    var allMembersCompleted: Bool { members.allSatisfy { $0.hasCompleted } }
    var completedCount: Int { members.filter { $0.hasCompleted }.count }

    var currentUserMember: CircleMember { members[currentUserIndex] }
    var currentUserHasCompleted: Bool { members[currentUserIndex].hasCompleted }

    func riddleFor(member: CircleMember) -> BCMemberRiddle {
        let idx = min(member.memberRiddleIndex, riddleSet.memberRiddles.count - 1)
        return riddleSet.memberRiddles[idx]
    }
}

// MARK: - Riddle Sets

extension BrainCircle {
    static let riddleSnowman = BCRiddleSet(
        theme: "Snowman",
        memberRiddles: [
            BCMemberRiddle(
                question: "I fall from clouds in winter — cold, silent, and white. Children play in me, roll me into balls, and make angels on the ground.",
                answer: "snow"
            ),
            BCMemberRiddle(
                question: "Long and colourful, I am worn around the neck on chilly days. I am often knitted from soft wool.",
                answer: "scarf"
            ),
            BCMemberRiddle(
                question: "Orange and crunchy, I grow underground in gardens. On cold winter days, I sometimes lend my shape as a nose.",
                answer: "carrot"
            )
        ],
        groupRiddle: BCGroupRiddle(
            question: "Your family gathered three things — snow for the body, a scarf around the neck, and a carrot for the nose. Together you built something that stands in gardens until spring melts it away. What is it?",
            answer: "snowman"
        )
    )

    static let riddlePizza = BCRiddleSet(
        theme: "Pizza",
        memberRiddles: [
            BCMemberRiddle(
                question: "I am stretchy and golden. I melt beautifully when heat finds me, and I am sprinkled generously on top of dishes.",
                answer: "cheese"
            ),
            BCMemberRiddle(
                question: "Red and round, I grow on vines in summer heat. Blend me into a rich, tangy sauce.",
                answer: "tomato"
            ),
            BCMemberRiddle(
                question: "Knead me, roll me flat, and let warmth help me rise. I am the soft, floury base beneath everything else.",
                answer: "dough"
            ),
            BCMemberRiddle(
                question: "Spicy and round, I am sliced thin and cured. A classic topping beloved in Italian cooking.",
                answer: "pepperoni"
            )
        ],
        groupRiddle: BCGroupRiddle(
            question: "Italy's most famous dish — a flat dough base spread with tomato sauce, loaded with melted cheese, and crowned with pepperoni. What is it?",
            answer: "pizza"
        )
    )

    static let riddleGarden = BCRiddleSet(
        theme: "Garden",
        memberRiddles: [
            BCMemberRiddle(
                question: "Colourful and fragrant, I bloom in spring and summer. Bees love to visit me, and I brighten any room.",
                answer: "flower"
            ),
            BCMemberRiddle(
                question: "Dark and rich, I hold plant roots firmly in place and give them food. Earthworms happily call me home.",
                answer: "soil"
            ),
            BCMemberRiddle(
                question: "From clouds I fall on rainy days. Plants open their leaves to drink me, and rivers are full of me.",
                answer: "rain"
            )
        ],
        groupRiddle: BCGroupRiddle(
            question: "A peaceful outdoor space where flowers bloom in rich soil and gentle rain feeds everything around you. Where are you?",
            answer: "garden"
        )
    )
}

// MARK: - Demo Families

extension BrainCircle {
    static func demoFamilies(username: String) -> [BrainCircle] {
        let displayName = username.isEmpty ? "You" : username
        return [
            // AXB778 — The Adams Family (3 members, NONE completed)
            BrainCircle(
                id: "AXB778",
                familyName: "The Adams Family",
                members: [
                    CircleMember(name: displayName,   hasCompleted: false, submittedAnswer: "",          memberRiddleIndex: 0),
                    CircleMember(name: "Sarah Adams",  hasCompleted: false, submittedAnswer: "",          memberRiddleIndex: 1),
                    CircleMember(name: "Mike Adams",   hasCompleted: false, submittedAnswer: "",          memberRiddleIndex: 2)
                ],
                riddleSet: riddleSnowman,
                currentUserIndex: 0,
                finalGuess: "",
                finalResult: nil
            ),
            // APPLE1 — The Kumar Family (4 members, ALL completed — ready to guess)
            BrainCircle(
                id: "APPLE1",
                familyName: "The Kumar Family",
                members: [
                    CircleMember(name: displayName,    hasCompleted: true, submittedAnswer: "cheese",     memberRiddleIndex: 0),
                    CircleMember(name: "Raj Kumar",    hasCompleted: true, submittedAnswer: "tomato",     memberRiddleIndex: 1),
                    CircleMember(name: "Priya Kumar",  hasCompleted: true, submittedAnswer: "dough",      memberRiddleIndex: 2),
                    CircleMember(name: "Arun Kumar",   hasCompleted: true, submittedAnswer: "pepperoni",  memberRiddleIndex: 3)
                ],
                riddleSet: riddlePizza,
                currentUserIndex: 0,
                finalGuess: "",
                finalResult: nil
            ),
            // APPLE2 — The Chen Family (3 members, 2 done, 1 not)
            BrainCircle(
                id: "APPLE2",
                familyName: "The Chen Family",
                members: [
                    CircleMember(name: displayName,  hasCompleted: true,  submittedAnswer: "flower", memberRiddleIndex: 0),
                    CircleMember(name: "Lily Chen",  hasCompleted: true,  submittedAnswer: "soil",   memberRiddleIndex: 1),
                    CircleMember(name: "James Chen", hasCompleted: false, submittedAnswer: "",        memberRiddleIndex: 2)
                ],
                riddleSet: riddleGarden,
                currentUserIndex: 0,
                finalGuess: "",
                finalResult: nil
            )
        ]
    }
}

// MARK: - Manager

class BrainCircleManager: ObservableObject {
    @Published var joinedCircles: [BrainCircle] = []

    // Returns the circle if found (demo or already joined), nil if code is invalid
    func join(code: String, username: String) -> BrainCircle? {
        let normalised = code.uppercased().trimmingCharacters(in: .whitespaces)
        // Already joined?
        if let existing = joinedCircles.first(where: { $0.id == normalised }) {
            return existing
        }
        // Demo lookup
        let demos = BrainCircle.demoFamilies(username: username)
        guard let demo = demos.first(where: { $0.id == normalised }) else { return nil }
        joinedCircles.append(demo)
        return joinedCircles.last
    }

    // Generates a preview code without committing anything to joinedCircles
    static func previewCode() -> String { generateCode() }

    // Creates a brand new circle with a given code, adds it to joined list, returns the circle
    func commitCircle(code: String, familyName: String, username: String) -> BrainCircle {
        let name = familyName.trimmingCharacters(in: .whitespaces)
        let circle = BrainCircle(
            id: code,
            familyName: name.isEmpty ? "My Family" : name,
            members: [
                CircleMember(name: username.isEmpty ? "You" : username, hasCompleted: false, submittedAnswer: "", memberRiddleIndex: 0)
            ],
            riddleSet: BrainCircle.riddleSnowman,
            currentUserIndex: 0,
            finalGuess: "",
            finalResult: nil
        )
        joinedCircles.append(circle)
        return joinedCircles.last!
    }

    // Marks current user's riddle as completed
    func completeMyRiddle(circleId: String, answer: String) {
        guard let ci = joinedCircles.firstIndex(where: { $0.id == circleId }) else { return }
        let ui = joinedCircles[ci].currentUserIndex
        joinedCircles[ci].members[ui].hasCompleted = true
        joinedCircles[ci].members[ui].submittedAnswer = answer
    }

    // Submits final group guess; returns whether correct
    @discardableResult
    func submitFinalGuess(circleId: String, guess: String) -> Bool {
        guard let ci = joinedCircles.firstIndex(where: { $0.id == circleId }) else { return false }
        let expected = joinedCircles[ci].riddleSet.groupRiddle.answer.lowercased()
        let guessNorm = guess.lowercased().trimmingCharacters(in: .whitespaces)
        let correct = !guess.isEmpty && guessNorm == expected
        joinedCircles[ci].finalGuess = guess
        joinedCircles[ci].finalResult = correct
        return correct
    }

    func circle(id: String) -> BrainCircle? {
        joinedCircles.first { $0.id == id }
    }

    private static func generateCode() -> String {
        let chars = Array("ABCDEFGHJKLMNPQRSTUVWXYZ23456789")
        return String((0..<6).map { _ in chars.randomElement()! })
    }
}
