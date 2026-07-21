import Foundation

struct Riddle: Codable, Identifiable {
    let id: Int
    let question: String
    let answer: String
    let difficulty: String
    let category: String
    let hints: [String]
}

private struct RiddleBank: Codable {
    let riddles: [Riddle]
}

enum RiddleDifficulty: String {
    case easy, medium, hard

    var fileName: String {
        switch self {
        case .easy:   return "easy_riddles"
        case .medium: return "medium_riddles"
        case .hard:   return "hard_riddles"
        }
    }
}

func loadRiddle(difficulty: RiddleDifficulty) -> Riddle {
    guard
        let url = Bundle.main.url(forResource: difficulty.fileName, withExtension: "json"),
        let data = try? Data(contentsOf: url),
        let bank = try? JSONDecoder().decode(RiddleBank.self, from: data),
        let riddle = bank.riddles.randomElement()
    else {
        return Riddle(
            id: 0,
            question: "I speak without a mouth and hear without ears. What am I?",
            answer: "echo",
            difficulty: difficulty.rawValue,
            category: "Nature",
            hints: [
                "Think about sound.",
                "It repeats what you say.",
                "You hear it in mountains or empty rooms."
            ]
        )
    }
    return riddle
}

// Strips articles, pronouns, and punctuation so "a clock" matches "clock".
func normalizeAnswer(_ text: String) -> String {
    let ignored: Set<String> = ["a", "an", "the", "my", "your", "its"]
    let lettersAndSpaces = text.lowercased().map { c in c.isLetter || c.isWhitespace ? c : " " }
    return String(lettersAndSpaces)
        .split(separator: " ")
        .map(String.init)
        .filter { !ignored.contains($0) }
        .joined(separator: " ")
}
