# WordCase

Swift utilities for getting words out of a sentence or a compound word and applying programmatic casing.

### Words

Retrieve words from a sentence or a compound word:
```swift
let sentence = "Hello, World!"
sentence.words() // ["Hello", "World"]

let compound = "HelloWorld"
compound.words() // ["Hello", "World"]
```

### Acronyms

Retrieve the acronym from a sentence or a compound word:
```swift
let sentence = "Let's invent some acronym."
sentence.acronym() // "LISA"

let compound = "UniversalResourceLocator"
compound.acronym() // "URL"
```

### Casing

Apply programmatic casing:

#### lowerCamelCase
```swift
let name = "not_Very_swifty"
name.lowerCamelCased() // "notVerySwifty"
```

Uses Swift best-practices when casing acronyms and abbreviations:
```swift
"someObjectId".lowerCamelCased() // "someObjectID"
"devApi".upperCamelCased() // "DevAPI"
"myUrl".lowerCamelCased() // "myURL"
```

#### UpperCamelCase
```swift
let name = "someClass"
name.upperCamelCased() // "SomeClass"
```

#### snake_case
```swift
let name = "SomeClass"
name.snakeCased() // "some_class"
```

#### Alternative
You can alternatively apply styling by using `.applying(caseStyle:)`:
```swift
let name = "SomeClass"
name.applying(caseStyle: .lowerCamelCase) // "someClass"
```

### Options
Specify options for customizing return values `.words(withOptions: String.WordOption)` (available on all of the above methods):
- `.distinguishHyphenatedWords`: Hyphenated words will be returned as two separate words.
- `.stripHyphens`: Hyphens (`-`) will be stripped from the return value.
- `.stripApostrophes`: Apostrophes (`'`) will be stripped from the return value.
- `.automaticallyUppercaseCommonAcronyms`: Common acronyms will automatically be uppercased.
