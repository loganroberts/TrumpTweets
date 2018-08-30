import UIKit
import NaturalLanguage

 var tweets: Set = ["This is a book.", "How many sisters do you have?", "There is not any book on the table.", "Did you miss the bus?", "My mouth is really wet.", "I suppose you dance too much"]
extension Set {
    public func randomObject() -> Element? {
        let n = Int(arc4random_uniform(UInt32(self.count)))
        let index = self.index(self.startIndex, offsetBy: n)
        return self.count > 0 ? self[index] : nil
    }
}

//NLP Logic

class LexicalType {
    var text: String
    var lexicalType: String
    
    init(text: String, lexicalType: String) {
        self.text = text
        self.lexicalType = lexicalType
    }
}

var parts: [String] = []
var lexicalTypes: [LexicalType] = []

func createBaseTweet() {
    let input = tweets.randomObject()
    let tagger = NLTagger(tagSchemes: [.lexicalClass])
    let options: NLTagger.Options = [.omitOther, .omitPunctuation, .omitWhitespace]
    tagger.string = input
    
    tagger.enumerateTags(
    in: input!.startIndex..<input!.endIndex, unit: .word, scheme: .lexicalClass, options: options) {
        (tag, tokenRange) in
        if let tag = tag {
            let part = String(input![tokenRange])
            parts.append(part)
            lexicalTypes.append(LexicalType(text: part, lexicalType: tag.rawValue))
        }
        return true
    }
}

let lexicalTypeToRemove = "Verb"

func filterForRemovedWords() {
    for member in lexicalTypes {
        if member.lexicalType == "Verb" {
            member.text = "FOUND"
        }
    }
}

createBaseTweet()
filterForRemovedWords()
lexicalTypes
    
var sentenceToPrint = ""
for member in lexicalTypes {
    sentenceToPrint.append(contentsOf: member.text)
    sentenceToPrint.append(contentsOf: " ")
}
