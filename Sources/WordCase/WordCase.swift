import Foundation

// MARK: - Internal

extension CharacterSet {
    func contains(charactersIn string: String) -> Bool {
        return isSuperset(of: CharacterSet(charactersIn: string))
    }

    func contains(_ character: Character) -> Bool {
        return contains(charactersIn: String(character))
    }

    func onlyContains(charactersIn string: String) -> Bool {
        return isStrictSuperset(of: CharacterSet(charactersIn: string))
    }
}

extension String {
    static func + (lhs: String, rhs: Character) -> String {
        return lhs + String(rhs)
    }

    static func += (lhs: inout String, rhs: Character) {
        lhs = lhs + rhs
    }
}

extension String {
    func contains(charactersIn characterSet: CharacterSet) -> Bool {
        return !CharacterSet(charactersIn: self).isDisjoint(with: characterSet)
    }

    func onlyContains(charactersIn characterSet: CharacterSet) -> Bool {
        return characterSet.isStrictSuperset(of: CharacterSet(charactersIn: self))
    }
}

extension String {
    var isUppercase: Bool {
        return self == uppercased()
    }
}

// MARK: - Public

extension String {
    public enum CaseStyle {
        /// Example: UpperCamelCase
        case upperCamelCase

        /// Example: lowerCamelCase
        case lowerCamelCase

        /// Example: snake_case
        case snakeCase
    }
}

extension String {
    public struct WordOption: OptionSet {
        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Hyphenated words will be returned as two separate words.
        ///
        /// Example: `"thick-skinned"` would be returned as `"thick"` and `"skinned"`.
        ///
        public static let distinguishHyphenatedWords = WordOption(rawValue: 1)

        /// Hyphens (`-`) will be stripped from the return value.
        ///
        /// Example: `"thick-skinned"` would be returned as `"thickskinned"`.
        ///
        public static let stripHyphens = WordOption(rawValue: 2)

        /// Apostrophes (`'`) will be stripped from the return value.
        ///
        /// Example: `"won't"` would be returned as `"wont"`.
        ///
        public static let stripApostrophes = WordOption(rawValue: 4)

        /// Common acronyms will automatically be uppercased.
        ///
        /// Example: `"Url"` would be returned as `"URL"`
        ///
        /// **Common Acronyms:**
        /// - `api`
        /// - `url`
        /// - `id`
        ///
        public static let automaticallyUppercaseCommonAcronyms = WordOption(rawValue: 8)
    }
}

extension String {
    public func words(withOptions options: WordOption = []) -> [String] {
        var words = [String]()
        var currentWord = ""
        let hyphen = "-"
        let apostrophe = "'"

        func saveCurrentWord() {
            defer { currentWord = "" }
            currentWord = currentWord.trimmingCharacters(in: CharacterSet(charactersIn: "-"))
            currentWord = currentWord.filter { character in
                if String(character) == hyphen && options.contains(.stripHyphens) {
                    return false
                } else if String(character) == apostrophe && options.contains(.stripApostrophes) {
                    return false
                }

                return true
            }

            if options.contains(.automaticallyUppercaseCommonAcronyms) {
                let commonAcronyms = [
                    "api",
                    "url",
                    "id"
                ]

                if commonAcronyms.contains(currentWord.lowercased()) {
                    currentWord = currentWord.uppercased()
                }
            }

            guard currentWord.contains(charactersIn: .letters), !currentWord.isEmpty else { return }
            words.append(currentWord)
        }

        for character in self {
            if CharacterSet.uppercaseLetters.contains(character) {
                if currentWord.isEmpty || currentWord.onlyContains(charactersIn: .uppercaseLetters) {
                    currentWord += character
                } else {
                    saveCurrentWord()
                    currentWord = String(character)
                }
            } else if String(character) == apostrophe {
                currentWord += character
            } else if !options.contains(.distinguishHyphenatedWords), String(character) == hyphen {
                currentWord += character
            } else if CharacterSet.letters.contains(character) {
                if currentWord.onlyContains(charactersIn: .uppercaseLetters), currentWord.count > 1 {
                    saveCurrentWord()
                    currentWord = String(character)
                } else {
                    currentWord += character
                }
            } else {
                saveCurrentWord()
            }
        }
        saveCurrentWord()
        return words
    }

    public func acronym(withOptions options: WordOption = []) -> String {
        var options = options
        options.formUnion([.stripHyphens, .stripApostrophes])
        return words(withOptions: options)
            .flatMap { $0.first }
            .map(String.init)
            .joined()
            .uppercased()
    }

    public func dashDelimeted(withOptions options: WordOption = []) -> String {
        return words(withOptions: options).joined(separator: "-")
    }

    public func lowerCamelCased(withOptions options: WordOption = []) -> String {
        var options = options
        options.formUnion([.stripHyphens, .stripApostrophes, .automaticallyUppercaseCommonAcronyms])
        var words = self.words(withOptions: options)
        for (index, word) in words.enumerated() {
            if index == 0 {
                words[index] = word.lowercased()
            } else if word.isUppercase {
                if words.indices ~= index - 1, words[index - 1].isUppercase {
                    words[index] = word.lowercased()
                }
            } else {
                words[index] = word.capitalized
            }
        }
        return words.joined()
    }

    public func upperCamelCased(withOptions options: WordOption = []) -> String {
        var options = options
        options.formUnion([.stripHyphens, .stripApostrophes, .automaticallyUppercaseCommonAcronyms])
        var words = self.words(withOptions: options)
        for (index, word) in words.enumerated() {
            if word.isUppercase {
                if words.indices ~= index - 1, words[index - 1].isUppercase {
                    words[index] = word.lowercased()
                }
            } else {
                words[index] = word.capitalized
            }
        }
        return words.joined()
    }

    public func snakeCased(withOptions options: WordOption = []) -> String {
        var options = options
        options.formUnion([.stripHyphens, .stripApostrophes])
        return words(withOptions: options)
            .joined(separator: "_")
            .lowercased()
    }

    public func applying(caseStyle: CaseStyle, withOptions options: WordOption) -> String {
        switch caseStyle {
        case .upperCamelCase: return upperCamelCased(withOptions: options)
        case .lowerCamelCase: return lowerCamelCased(withOptions: options)
        case .snakeCase: return snakeCased(withOptions: options)
        }
    }
}
