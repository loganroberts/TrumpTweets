//
//  GameViewController.swift
//  TrumpTweets
//
//  Created by Logan Roberts on 8/28/18.
//  Copyright © 2018 Logan Roberts. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import Social
import NaturalLanguage


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
        if playSeconds == 0 {
            feedbackLabel.text = "ready."
        }
        if playSeconds == 1 {
            feedbackLabel.text = "ready.."
        }
        if playSeconds == 2 {
            feedbackLabel.text = "ready..."
        }
        if playSeconds == 3 {
            playTimer.invalidate()
            showGameplayScreen()
            setupTweetForPlay()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        SentenceView.presentScene(sentenceScene)
        sentenceScene.backgroundColor = .white
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
    
    @IBOutlet weak var SentenceView: SKView!
    
    
    //Sources
    var Verb: Set = ["ask", "be", "become", "begin", "call", "can", "come", "could", "do", "feel", "find", "get", "give", "go", "have", "hear", "help", "keep", "know", "leave", "let", "like", "live", "look", "make", "may", "mean", "might", "move", "need", "play", "put", "run", "say", "see", "seem", "should", "show", "start", "take", "talk", "tell", "think", "try", "turn", "use", "want", "will", "work", "would"]
    
    var Adjective: Set = ["able", "bad", "best", "better", "big", "black", "certain", "clear", "different", "early", "easy", "economic", "federal", "free", "full", "good", "great", "hard", "high", "human", "important", "international", "large", "late", "little", "local", "long", "low", "major", "military", "national", "new", "old", "only", "other", "political", "possible", "public", "real", "recent", "right", "small", "social", "special", "strong", "sure", "true", "white", "whole", "young"]
    
    var Noun: Set = ["area", "book", "business", "case", "child", "company", "country", "day", "eye", "fact", "family", "government", "group", "hand", "home", "job", "life", "lot", "man", "money", "month", "mother", "night", "number", "part", "people", "place", "point", "problem", "program", "question", "right", "room", "school", "state", "story", "student", "study", "system", "thing", "time", "water", "way", "week", "woman", "word", "work", "world", "year"]
    
    var Article: Set = ["the"]
    
    var Adverb: Set = ["gone"]
    
    var tweets: Set = ["This is a book.", "How many sisters do you have?", "There is not any book on the table.", "Did you miss the bus?", "My mouth is really wet.", "I suppose you dance too much"]
    
    var lexicalOptions: Set = ["Verb", "Noun", "Adjective"]
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
    var wordsTaggedWithLexicalType: [LexicalType] = []
    
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
                wordsTaggedWithLexicalType.append(LexicalType(text: part, lexicalType: tag.rawValue))
                }
                return true
        }
    }
    
    func filterForRemovedWords() {
        let typeToRemove = lexicalOptions.randomObject()
        for member in wordsTaggedWithLexicalType {
            if (member.lexicalType == typeToRemove!) && (member.text != "WORDREMOVED") {
                member.text = "WORDREMOVED"
            }
        }
    }
    
    lazy var sentenceScene = SKScene(size: (SentenceView.bounds.size))
    
    func setupSentenceLabel(withText: String) -> SKSpriteNode {
    
        let sentenceLabel = SKLabelNode(text: withText)
        
        let sentenceWordNodeSize = CGSize(width: (sentenceLabel.frame.width), height: (sentenceLabel.frame.height + 20))
        let sentenceWordNode = SKSpriteNode(color: .black, size: sentenceWordNodeSize)
        
        sentenceWordNode.anchorPoint = CGPoint(x: 0, y: 0)
        sentenceWordNode.position = CGPoint(x: 60, y: (110))
       
        sentenceLabel.fontSize = 25
        sentenceLabel.fontColor = .white
        sentenceLabel.fontName = "Helvetica-Bold"
        sentenceLabel.position = CGPoint(x: (sentenceWordNodeSize.width / 2), y: (sentenceWordNodeSize.height / 4))
        sentenceWordNode.addChild(sentenceLabel)
        
        return sentenceWordNode
    }
    
    
    func createSentenceLabel() {
        var previousXValue: CGFloat = 40
        var previousYValue: CGFloat = 110
        
        for member in wordsTaggedWithLexicalType {
            let sentenceLabelNode = setupSentenceLabel(withText: member.text)
            sentenceScene.addChild(sentenceLabelNode)
            sentenceLabelNode.position.x = previousXValue
            sentenceLabelNode.position.y = previousYValue
            previousXValue += (sentenceLabelNode.frame.width + 10)
            if (sentenceLabelNode.position.x + sentenceLabelNode.frame.width) > 355 {
                previousYValue -= 60
                sentenceLabelNode.position.y = previousYValue
                sentenceLabelNode.position.x = 60
                previousXValue = 40
            }
            print(member.text)
        }
    }
    
    
    func setupTweetForPlay() {
        createBaseTweet()
        filterForRemovedWords()
        createSentenceLabel()
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


