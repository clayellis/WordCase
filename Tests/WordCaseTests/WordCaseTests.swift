import XCTest
@testable import WordCase

class WordCaseTests: XCTestCase {
    func testWords() {
        let sentence = "Hello, World!"
        XCTAssertEqual(sentence.words(), ["Hello", "World"])
    }

    func testWordsEmpty() {
        let sentence = ""
        XCTAssertEqual(sentence.words(), [])
    }

    func testWordsWithStrayCharacters() {
        let sentence = "Hello, ' World - ! & ? is/ this . *thing! _ on?"
        XCTAssertEqual(sentence.words(), ["Hello", "World", "is", "this", "thing", "on"])
    }

    func testWordsNoSpaces() {
        let sentence = "HelloWorld_howAre.you"
        XCTAssertEqual(sentence.words(), ["Hello", "World", "how", "Are", "you"])
    }

    func testWordsNoSpacesWithNestedUppercaseWord() {
        let sentence = "HelloWorldWOWitWorks"
        XCTAssertEqual(sentence.words(), ["Hello", "World", "WOW", "it", "Works"])
    }

    func testDistinguishingHyphenatedWords() {
        let sentence = "The thick-skulled programmers."
        XCTAssertEqual(sentence.words(), ["The", "thick-skulled", "programmers"])
        XCTAssertEqual(sentence.words(withOptions: .distinguishHyphenatedWords), ["The", "thick", "skulled", "programmers"])
    }

    func testStrippingHyphens() {
        let sentence = "The thick-skulled programmers."
        XCTAssertEqual(sentence.words(withOptions: .stripHyphens), ["The", "thickskulled", "programmers"])
    }

    func testNoHyphensAtBeginningOrEndOfWords() {
        let sentence = "-Beginning -around- end-"
        XCTAssertEqual(sentence.words(), ["Beginning", "around", "end"])
    }

    func testStrippingApostrophes() {
        let sentence = "Don't you dare."
        XCTAssertEqual(sentence.words(withOptions: .stripApostrophes), ["Dont", "you", "dare"])
    }

    func testContractionsAtBeginningOrEndOfWords() {
        let sentence = "I'm 'bout to get 'em!"
        XCTAssertEqual(sentence.words(), ["I'm", "'bout", "to", "get", "'em"])
    }

    func testAutomaticallyUppercaseAcronyms() {
        let sentence = "api url some id"
        XCTAssertEqual(sentence.words(withOptions: .automaticallyUppercaseCommonAcronyms), ["API", "URL", "some", "ID"])
    }

    func testAcronym() {
        let sentence = "let's invent some acronym"
        XCTAssertEqual(sentence.acronym(), "LISA")
    }

    func testAcronymWithLeadingApostrophe() {
        let sentence = "let's 'nvent some acroynm"
        XCTAssertEqual(sentence.acronym(), "LNSA")
    }

    func testLowerCamelCase() {
        let name = "HelloWorld"
        XCTAssertEqual(name.lowerCamelCased(), "helloWorld")
    }

    func testLowerCamelCaseAcronym() {
        let name = "someObjectId"
        XCTAssertEqual(name.lowerCamelCased(), "someObjectID")
    }

    func testLowerCamelCaseAcronymBackToBack() {
        let name = "someObjectIdUrlApi"
        XCTAssertEqual(name.lowerCamelCased(), "someObjectIDurlAPI")
    }

    func testUpperCamelCase() {
        let name = "someObject"
        XCTAssertEqual(name.upperCamelCased(), "SomeObject")
    }

    func testUpperCamelCaseAcronym() {
        let name = "someObjectId"
        XCTAssertEqual(name.upperCamelCased(), "SomeObjectID")
    }

    func testUpperCamelCaseAcronymBackToBack() {
        let name = "someObjectIdUrlApi"
        XCTAssertEqual(name.upperCamelCased(), "SomeObjectIDurlAPI")
    }

    func testSnakeCase() {
        let name = "someObjectIdUrlApi"
        XCTAssertEqual(name.snakeCased(), "some_object_id_url_api")
    }

    // TODO: Create tests for casing while passing in options (casing should always strip apostrophes and hyphens)

    static var allTests = [
        ("testWords", testWords),
        ("testWordsEmpty", testWordsEmpty),
        ("testWordsWithStrayCharacters", testWordsWithStrayCharacters),
        ("testWordsNoSpaces", testWordsNoSpaces),
        ("testWordsNoSpacesWithNestedUppercaseWord", testWordsNoSpacesWithNestedUppercaseWord),
        ("testDistinguishingHyphenatedWords", testDistinguishingHyphenatedWords),
        ("testStrippingHyphens", testStrippingHyphens),
        ("testNoHyphensAtBeginningOrEndOfWords", testNoHyphensAtBeginningOrEndOfWords),
        ("testStrippingApostrophes", testStrippingApostrophes),
        ("testContractionsAtBeginningOrEndOfWords", testContractionsAtBeginningOrEndOfWords),
        ("testAutomaticallyUppercaseAcronyms", testAutomaticallyUppercaseAcronyms),
        ("testAcronym", testAcronym),
        ("testAcronymWithLeadingApostrophe", testAcronymWithLeadingApostrophe),
        ("testLowerCamelCase", testLowerCamelCase),
        ("testLowerCamelCaseAcronym", testLowerCamelCaseAcronym),
        ("testLowerCamelCaseAcronymBackToBack", testLowerCamelCaseAcronymBackToBack),
        ("testUpperCamelCase", testUpperCamelCase),
        ("testUpperCamelCaseAcronym", testUpperCamelCaseAcronym),
        ("testUpperCamelCaseAcronymBackToBack", testUpperCamelCaseAcronymBackToBack),
        ("testSnakeCase", testSnakeCase)
    ]
}
