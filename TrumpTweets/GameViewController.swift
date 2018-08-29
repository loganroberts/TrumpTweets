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

//Sources
var Verb: Set = ["ask", "be", "become", "begin", "call", "can", "come", "could", "do", "feel", "find", "get", "give", "go", "have", "hear", "help", "keep", "know", "leave", "let", "like", "live", "look", "make", "may", "mean", "might", "move", "need", "play", "put", "run", "say", "see", "seem", "should", "show", "start", "take", "talk", "tell", "think", "try", "turn", "use", "want", "will", "work", "would"]

var Adjective: Set = ["able", "bad", "best", "better", "big", "black", "certain", "clear", "different", "early", "easy", "economic", "federal", "free", "full", "good", "great", "hard", "high", "human", "important", "international", "large", "late", "little", "local", "long", "low", "major", "military", "national", "new", "old", "only", "other", "political", "possible", "public", "real", "recent", "right", "small", "social", "special", "strong", "sure", "true", "white", "whole", "young"]

var Noun: Set = ["area", "book", "business", "case", "child", "company", "country", "day", "eye", "fact", "family", "government", "group", "hand", "home", "job", "life", "lot", "man", "money", "month", "mother", "night", "number", "part", "people", "place", "point", "problem", "program", "question", "right", "room", "school", "state", "story", "student", "study", "system", "thing", "time", "water", "way", "week", "woman", "word", "work", "world", "year"]

var tweets: Set = ["The decision on Sergeant Bergdahl is a complete and total disgrace to our Country and to our Military.", "I nuked best North Korea", "Does anybody really believe that a reporter, who nobody ever heard of, 'went to his mailbox' and found my tax returns FAKE NEWS!", "The ABC/Washington Post Poll, even though almost 40% is not bad at this time, was just about the most inaccurate poll around election time!", "After Turkey call I will be heading over to Trump National Golf Club, Jupiter, to play golf (quickly) with Tiger Woods and Dustin Johnson. Then back to Mar-a-Lago for talks on bringing even more jobs and companies back to the USA!", "Watched protests yesterday but was under the impression that we just had an election! Why didn't these people vote? Celebs hurt cause badly.", "My son Donald openly gave his e-mails to the media & authorities whereas Crooked Hillary Clinton deleted (& acid washed) her 33,000 e-mails!", "Big increase in traffic into our country from certain areas, while our people are far more vulnerable, as we wait for what should be EASY D!", "The President has accomplished some absolutely historic things during this past year.", "Thank you Charlie Kirk of Turning Points USA. Sadly, the Fake Mainstream Media will NEVER talk about our accomplishments in their end of year reviews. We are compiling a long & beautiful list.", "Is Fake News Washington Post being used as a lobbyist weapon against Congress to keep Politicians from looking into Amazon no-tax monopoly?", "Will be having many meetings this weekend at The Southern White House. Big 5:00 P.M. speech in Melbourne, Florida. A lot to talk about!", "Is it legal for a sitting President to be 'wire tapping' a race for president prior to an election? Turned down by court earlier. A NEW LOW!", "Despite thousands of hours wasted and many millions of dollars spent, the Democrats have been unable to show any collusion with Russia - so now they are moving on to the false accusations and fabricated stories of women who I don’t know and/or have never met. FAKE NEWS!", "I call my own shots, largely based on an accumulation of data, and everyone knows it. Some FAKE NEWS media, in order to marginalize, lies!", "We should have a contest as to which of the Networks, plus CNN and not including Fox, is the most dishonest, corrupt and/or distorted in its political coverage of your favorite President (me). They are all bad. Winner to receive the FAKE NEWS TROPHY!", "My daughter Ivanka has been treated so unfairly by @Nordstrom. She is a great person -- always pushing me to do the right thing! Terrible!", "Our relationship with Russia is at an all-time & very dangerous  low. You can thank Congress, the same people that can't even give us HCare!", "Our relationship with Russia is at an all-time & very dangerous  low. You can thank Congress, the same people that can't even give us HCare!", "The only people who don’t like the Tax Cut Bill are the people that don’t understand it or the Obstructionist Democrats that know how really good it is and do not want the credit and success to go to the Republicans!", "The only people who don’t like the Tax Cut Bill are the people that don’t understand it or the Obstructionist Democrats that know how really good it is and do not want the credit and success to go to the Republicans!", "For every CEO that drops out of the Manufacturing Council, I have many to take their place. Grandstanders should not have gone on. JOBS!", "Jeff Sessions is an honest man. He did not say anything wrong. He could have stated his response more accurately, but it was clearly not....", "Lightweight Senator Kirsten Gillibrand, a total flunky for Chuck Schumer and someone who would come to my office “begging” for campaign contributions not so long ago (and would do anything for them), is now in the ring fighting against Trump. Very disloyal to Bill & Crooked-USED!", "Despite what you hear in the press, healthcare is coming along great. We are talking to many groups and it will end in a beautiful picture!", "I am pleased to inform you that I have just granted a full Pardon to 85 year old American patriot Sheriff Joe Arpaio. He kept Arizona safe!", "With all of the Fake News coming out of NBC and the Networks, at what point is it appropriate to challenge their License? Bad for country!", "President Andrew Jackson, who died 16 years before the Civil War started, saw it coming and was angry. Would never have let it happen!", "The people of Alabama will do the right thing. Doug Jones is Pro-Abortion, weak on Crime, Military and Illegal Immigration, Bad for Gun Owners and Veterans and against the WALL. Jones is a Pelosi/Schumer Puppet. Roy Moore will always vote with us. VOTE ROY MOORE!", "James Comey better hope that there are no 'tapes' of our conversations before he starts leaking to the press!", "Made additional remarks on Charlottesville and realize once again that the #Fake News Media will never be satisfied...truly bad people!", "We cannot keep FEMA, the Military & the First Responders, who have been amazing (under the most difficult circumstances) in P.R. forever!", "Crazy Joe Scarborough and dumb as a rock Mika are not bad people, but their low rated show is dominated by their NBC bosses. Too bad!", "I had a very respectful conversation with the widow of Sgt. La David Johnson, and spoke his name from beginning, without hesitation!", "That's right, we need a TRAVEL BAN for certain DANGEROUS countries, not some politically correct term that won't help us protect our people!", "I strongly pressed President Putin twice about Russian meddling in our election. He vehemently denied it. I've already given my opinion....."]


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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello world")
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
    
    var tweets: Set = ["The decision on Sergeant Bergdahl is a complete and total disgrace to our Country and to our Military.", "I nuked best North Korea", "Does anybody really believe that a reporter, who nobody ever heard of, 'went to his mailbox' and found my tax returns FAKE NEWS!", "The ABC/Washington Post Poll, even though almost 40% is not bad at this time, was just about the most inaccurate poll around election time!", "After Turkey call I will be heading over to Trump National Golf Club, Jupiter, to play golf (quickly) with Tiger Woods and Dustin Johnson. Then back to Mar-a-Lago for talks on bringing even more jobs and companies back to the USA!", "Watched protests yesterday but was under the impression that we just had an election! Why didn't these people vote? Celebs hurt cause badly.", "My son Donald openly gave his e-mails to the media & authorities whereas Crooked Hillary Clinton deleted (& acid washed) her 33,000 e-mails!", "Big increase in traffic into our country from certain areas, while our people are far more vulnerable, as we wait for what should be EASY D!", "The President has accomplished some absolutely historic things during this past year.", "Thank you Charlie Kirk of Turning Points USA. Sadly, the Fake Mainstream Media will NEVER talk about our accomplishments in their end of year reviews. We are compiling a long & beautiful list.", "Is Fake News Washington Post being used as a lobbyist weapon against Congress to keep Politicians from looking into Amazon no-tax monopoly?", "Will be having many meetings this weekend at The Southern White House. Big 5:00 P.M. speech in Melbourne, Florida. A lot to talk about!", "Is it legal for a sitting President to be 'wire tapping' a race for president prior to an election? Turned down by court earlier. A NEW LOW!", "Despite thousands of hours wasted and many millions of dollars spent, the Democrats have been unable to show any collusion with Russia - so now they are moving on to the false accusations and fabricated stories of women who I don’t know and/or have never met. FAKE NEWS!", "I call my own shots, largely based on an accumulation of data, and everyone knows it. Some FAKE NEWS media, in order to marginalize, lies!", "We should have a contest as to which of the Networks, plus CNN and not including Fox, is the most dishonest, corrupt and/or distorted in its political coverage of your favorite President (me). They are all bad. Winner to receive the FAKE NEWS TROPHY!", "My daughter Ivanka has been treated so unfairly by @Nordstrom. She is a great person -- always pushing me to do the right thing! Terrible!", "Our relationship with Russia is at an all-time & very dangerous  low. You can thank Congress, the same people that can't even give us HCare!", "Our relationship with Russia is at an all-time & very dangerous  low. You can thank Congress, the same people that can't even give us HCare!", "The only people who don’t like the Tax Cut Bill are the people that don’t understand it or the Obstructionist Democrats that know how really good it is and do not want the credit and success to go to the Republicans!", "The only people who don’t like the Tax Cut Bill are the people that don’t understand it or the Obstructionist Democrats that know how really good it is and do not want the credit and success to go to the Republicans!", "For every CEO that drops out of the Manufacturing Council, I have many to take their place. Grandstanders should not have gone on. JOBS!", "Jeff Sessions is an honest man. He did not say anything wrong. He could have stated his response more accurately, but it was clearly not....", "Lightweight Senator Kirsten Gillibrand, a total flunky for Chuck Schumer and someone who would come to my office “begging” for campaign contributions not so long ago (and would do anything for them), is now in the ring fighting against Trump. Very disloyal to Bill & Crooked-USED!", "Despite what you hear in the press, healthcare is coming along great. We are talking to many groups and it will end in a beautiful picture!", "I am pleased to inform you that I have just granted a full Pardon to 85 year old American patriot Sheriff Joe Arpaio. He kept Arizona safe!", "With all of the Fake News coming out of NBC and the Networks, at what point is it appropriate to challenge their License? Bad for country!", "President Andrew Jackson, who died 16 years before the Civil War started, saw it coming and was angry. Would never have let it happen!", "The people of Alabama will do the right thing. Doug Jones is Pro-Abortion, weak on Crime, Military and Illegal Immigration, Bad for Gun Owners and Veterans and against the WALL. Jones is a Pelosi/Schumer Puppet. Roy Moore will always vote with us. VOTE ROY MOORE!", "James Comey better hope that there are no 'tapes' of our conversations before he starts leaking to the press!", "Made additional remarks on Charlottesville and realize once again that the #Fake News Media will never be satisfied...truly bad people!", "We cannot keep FEMA, the Military & the First Responders, who have been amazing (under the most difficult circumstances) in P.R. forever!", "Crazy Joe Scarborough and dumb as a rock Mika are not bad people, but their low rated show is dominated by their NBC bosses. Too bad!", "I had a very respectful conversation with the widow of Sgt. La David Johnson, and spoke his name from beginning, without hesitation!", "That's right, we need a TRAVEL BAN for certain DANGEROUS countries, not some politically correct term that won't help us protect our people!", "I strongly pressed President Putin twice about Russian meddling in our election. He vehemently denied it. I've already given my opinion....."]
    
    /////////////////////////////////////
    //NLP Logic

   
    var lexicalOptions: Set = ["Verb", "Noun", "Adjective", "Adverb", "Article"]
    var lexicalTypeToRemove = "Verb"
    var baseTweet = " "
    var baseTweetSet: Set = [""]
    var workingTweet: Array = [""]
    var wordsRemoved = 0
    
    func parseTweet() {
        let text = tweets.randomObject()!
        let tagger = NSLinguisticTagger(tagSchemes: [.tokenType], options: 0)
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { _, tokenRange, _ in
            let word = (text as NSString).substring(with: tokenRange)
            baseTweetSet.insert(word)
        }
        getSentenceLength()
    }
    
    func getSentenceLength() {
        if baseTweetSet.count < 10 {
            removeLexicalType()
        } else if (baseTweetSet.count > 10) && (baseTweetSet.count < 15) {
            for _ in 1...2 {
                removeLexicalType()
            }
        } else if (baseTweetSet.count > 15) && (baseTweetSet.count < 25) {
            for _ in 1...3 {
                removeLexicalType()
            }
        } else if baseTweetSet.count > 25 {
            print("Over 25 words")
        }
    }
    
    func removeLexicalType() {
        lexicalTypeToRemove = lexicalOptions.randomObject()!
        for member in baseTweetSet {
            let tagger = NSLinguisticTagger(tagSchemes: [.lexicalClass], options: 0)
            let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
            let range = NSRange(location: 0, length: member.utf16.count)
            tagger.string = member
            tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, stop in
                var word = (member as NSString).substring(with: tokenRange)
                if tag!.rawValue == lexicalTypeToRemove {
                    word = "\(lexicalTypeToRemove)"
                    workingTweet.append(" \(word)")
                } else {
                    workingTweet.append(" \(word)")
                }
            }
        }
    }
    
//game timer setup
    
    var seconds = 30 //starting time options
    var timer = Timer()
    var isTimerRunning = false //only one timer at a time
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        if seconds == 0 {
            timer.invalidate()
        }
    }

    
    
}


