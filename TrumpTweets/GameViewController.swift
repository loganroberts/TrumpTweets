//
//  GameViewController.swift
//  TrumpTweets
//
//  Created by Logan Roberts on 8/28/18.
//  Copyright © 2018 Logan Roberts. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import Social


//custom extensions
extension Set {
    public func randomObject() -> Element? {
        let n = Int(arc4random_uniform(UInt32(self.count)))
        let index = self.index(self.startIndex, offsetBy: n)
        return self.count > 0 ? self[index] : nil
    }
}

extension Int: Sequence {
    public func makeIterator() -> CountableRange<Int>.Iterator {
        return (0..<self).makeIterator()
    }
}



extension String {
    func stringByReplacingFirstOccurrenceOfString(
        target: String, withString replaceString: String) -> String
    {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
}


class GameViewController: UIViewController {
    
    var playSeconds = 0 //starting time options
    var startTimer = Timer()
    
    
    func runPlayTimer() {
        playTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameViewController.updatePlayTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updatePlayTimer() {
        playSeconds += 1

        if playSeconds == 3 {
            playTimer.invalidate()
            parseTweet()
            showGameplayScreen()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        runPlayTimer()
    }
    
    func showGameplayScreen() {
        feedbackLabel.isHidden = true
        GameInfoView.isHidden = false
        InteractionView.isHidden = false
        SentenceView.isHidden = false
        
    }
    
    //Interface setup
    @IBOutlet weak var GameInfoView: UIView!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var InteractionView: UIView!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var word1Button: UIButton!
    @IBOutlet weak var word2Button: UIButton!
    @IBOutlet weak var word3Button: UIButton!
    @IBOutlet weak var word4Button: UIButton!
    @IBOutlet weak var word5Button: UIButton!
    
    @IBOutlet weak var SentenceView: UIView!
    @IBOutlet weak var sentenceLabel: UILabel!
    
    //Sources
    var Verb: Set = ["ask", "be", "become", "begin", "call", "can", "come", "could", "do", "feel", "find", "get", "give", "go", "have", "hear", "help", "keep", "know", "leave", "let", "like", "live", "look", "make", "may", "mean", "might", "move", "need", "play", "put", "run", "say", "see", "seem", "should", "show", "start", "take", "talk", "tell", "think", "try", "turn", "use", "want", "will", "work", "would"]
    
    var Adjective: Set = ["able", "bad", "best", "better", "big", "black", "certain", "clear", "different", "early", "easy", "economic", "federal", "free", "full", "good", "great", "hard", "high", "human", "important", "international", "large", "late", "little", "local", "long", "low", "major", "military", "national", "new", "old", "only", "other", "political", "possible", "public", "real", "recent", "right", "small", "social", "special", "strong", "sure", "true", "white", "whole", "young"]
    
    var Noun: Set = ["area", "book", "business", "case", "child", "company", "country", "day", "eye", "fact", "family", "government", "group", "hand", "home", "job", "life", "lot", "man", "money", "month", "mother", "night", "number", "part", "people", "place", "point", "problem", "program", "question", "right", "room", "school", "state", "story", "student", "study", "system", "thing", "time", "water", "way", "week", "woman", "word", "work", "world", "year"]
    
    var Article: Set = ["the"]
    
    var Adverb: Set = ["gone"]
    
    var tweets: Set = ["This is a book.", "How many sisters do you have?", "There is not any book on the table.", "Did you miss the bus?", "My mouth is watering.", "I suppose you dance too much"]
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //NLP Logic

   
    var lexicalOptions: Set = ["Verb", "Noun", "Adjective", "Adverb", "Article"]
    var lexicalTypeToRemove = "Verb"
    var lexicalTypesRemoved: Set = [""]
    var baseTweet = " "
    var baseTweetArray: Array = [""]
    var workingTweet: Array = [""]
    var wordsRemoved = 0
    var removedWordsCount = 0
    
    func parseTweet() {
        let text = tweets.randomObject()!
        baseTweetArray = text.components(separatedBy: " ")
        getSentenceLength()
    }
    
    func getSentenceLength() {
        if baseTweetArray.count < 10 {
            removeLexicalType()
            if removedWordsCount == 0 {
                removeLexicalTypeAgain()
            }
            setSentenceLabel()
        } else if (baseTweetArray.count > 10) && (baseTweetArray.count < 15) {
            removeLexicalType()
            removeLexicalTypeAgain()
            if removedWordsCount == 0 {
                removeLexicalTypeAgain()
            }
            setSentenceLabel()
            print("Between 10 and 15 words")
        } else if (baseTweetArray.count > 15) && (baseTweetArray.count < 25) {
            removeLexicalType()
            removeLexicalTypeAgain()
            if removedWordsCount == 0 {
                removeLexicalTypeAgain()
            }
            setSentenceLabel()
            print("Between 15 and 25 words")
        } else if baseTweetArray.count > 25 {
                print("Over 25 words")
                //parseTweet()
        }
    }
    
    func setSentenceLabel() {
        let tweetToPrint = workingTweet.joined(separator: " ")
        print(tweetToPrint)
        sentenceLabel.text = tweetToPrint
        setupAllButtons()
    }
    
    func removeLexicalType() {
        lexicalTypeToRemove = lexicalOptions.randomObject()!
        removedWordsCount = 0
        print(lexicalTypeToRemove)
        for member in baseTweetArray {
            let memberIndex = baseTweetArray.index(of: member)
            let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
            let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
            let range = NSRange(location: 0, length: member.utf16.count)
            tagger.string = member
            tagger.setOrthography(NSOrthography.defaultOrthography(forLanguage: "en-US"), range: range)
            tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, stop in
                let word = (member as NSString).substring(with: tokenRange)
                print("\(tag!.rawValue):\(word)")
                if tag!.rawValue == lexicalTypeToRemove {
                    workingTweet.insert(" \(lexicalTypeToRemove)", at: memberIndex!)
                    removedWordsCount += 1
                } else {
                    workingTweet.insert(" \(word)", at: memberIndex!)
                }
                if !lexicalTypesRemoved.contains(tag!.rawValue) {
                    lexicalTypesRemoved.insert(tag!.rawValue)
                }
            }
        }
    }
    
    
    func removeLexicalTypeAgain() {
        removedWordsCount = 0
        lexicalTypeToRemove = lexicalOptions.randomObject()!
        print(lexicalTypeToRemove)
        for member in workingTweet {
            let memberIndex = workingTweet.index(of: member)
            let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
            let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
            let range = NSRange(location: 0, length: member.utf16.count)
            tagger.string = member
            tagger.setOrthography(NSOrthography.defaultOrthography(forLanguage: "en-US"), range: range)
            tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, stop in
                let word = (member as NSString).substring(with: tokenRange)
                if tag!.rawValue == lexicalTypeToRemove {
                    workingTweet[memberIndex!] = lexicalTypeToRemove
                    print(word)
                    if !lexicalTypesRemoved.contains(tag!.rawValue) {
                        lexicalTypesRemoved.insert(tag!.rawValue)
                    }
                }
            }
        }
    }
    
    //setup buttons with words
    
    func populateButton(forButton: UIButton) {
        var buttonWord = " "
        if lexicalTypesRemoved.count > 0 {
            let buttonWordType = lexicalTypesRemoved.first
        
        lexicalTypesRemoved.removeFirst()
        
        if buttonWordType == "Verb" {
            buttonWord = Verb.randomObject()!
        } else if buttonWordType == "Noun" {
            buttonWord = Noun.randomObject()!
        } else if buttonWordType == "Adjective" {
            buttonWord = Adjective.randomObject()!
        } else if buttonWordType == "Adverb" {
            buttonWord = Adverb.randomObject()!
        } else if buttonWordType == "Article" {
            buttonWord = Article.randomObject()!
        } else {
            let buttonFillerType = lexicalOptions.randomObject()

            if buttonFillerType == "Verb" {
                buttonWord = Verb.randomObject()!
            } else if buttonFillerType == "Noun" {
                buttonWord = Noun.randomObject()!
            } else if buttonFillerType == "Adjective" {
                buttonWord = Adjective.randomObject()!
            } else if buttonFillerType == "Adverb" {
                buttonWord = Adverb.randomObject()!
            } else if buttonFillerType == "Article" {
                buttonWord = Article.randomObject()!
            }
        }
        forButton.setTitle(buttonWord, for: UIControl.State.normal)
        print(buttonWord)
        }
    
    }
    func setupAllButtons() {
        populateButton(forButton: word1Button)
        populateButton(forButton: word2Button)
        populateButton(forButton: word3Button)
        populateButton(forButton: word4Button)
        populateButton(forButton: word5Button)
    }
    
    
    
    
    
    
    
    
    
    
    
//game timer setup
    
    var seconds = 30 //starting time options
    var playTimer = Timer()
    var isTimerRunning = false //only one timer at a time
    
    func runTimer() {
        playTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        if seconds == 0 {
            playTimer.invalidate()
        }
    }

    
    
    @IBAction func returnToMenu(_ sender: Any) {
    playTimer.invalidate()
    feedbackLabel.isHidden = false
    GameInfoView.isHidden = true
    InteractionView.isHidden = true
    SentenceView.isHidden = true
    }
    
}


