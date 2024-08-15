//
//  ValidatorHelper.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import Foundation
import Combine

typealias DefaultTextValidator = ValidatorHelper.DefaultTextValidator

struct ValidatorHelper {
    ///UTF-8/32 regex contains unicode range between U+0080 and U+10FFFF        =>      (?! [\x{80}-\x{10FFFF}] )[$\w]
    ///All characters except special alphabets such as Russian/Japanese/Chinese..   =>      ([\\x{00}-\\x{FF}][$\\w]*)
    private static let turkishCharacterSet = "a-zA-ZçÇğĞıİöÖşŞüÜ"

    static var firstNamePredicate = NSPredicate(format: "SELF MATCHES %@", "^[\(turkishCharacterSet)\\s]{2,30}$")
    static var middleNamePredicate = NSPredicate(format: "SELF MATCHES %@", "^[\(turkishCharacterSet)\\s]{2,30}$")
    static var lastNamePredicate = NSPredicate(format: "SELF MATCHES %@", "^[\(turkishCharacterSet)\\s]{2,30}$")
    static var agePredicate = NSPredicate(format: "SELF MATCHES %@", "^(?:[0-9]|[1-9][0-9]|1[01][0-9]|120)$")
    static var heightPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?:[0-9]|[1-9][0-9]|[1-2][0-9][0-9]|300)$")
    static var weightPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?:[0-9]|[1-9][0-9]|[1-2][0-9][0-9]|300)$")
    static var emailPredicate = NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$")
    static var passwordPredicate = NSPredicate(format: "SELF MATCHES %@","[0-9]{6,6}$")
    static var emptyPasswordPredicate = NSPredicate(format: "SELF MATCHES %@","^.{6,6}$")
    static var cityPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[\\x{00}-\\x{FF}\(turkishCharacterSet)][$\\w])\\s*[\\x{00}-\\x{FF}\(turkishCharacterSet)][$\\w\\s]{1,50}$")
    static var stateAndRegionPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[\\x{00}-\\x{FF}\(turkishCharacterSet)][$\\w])\\s*[\\x{00}-\\x{FF}\(turkishCharacterSet)][$\\w\\s]{1,50}$")
    static var addressIDPredicate = NSPredicate(format: "SELF MATCHES %@","[0-9]{1,10}$")
    static var fullNamePredicate = NSPredicate(format: "SELF MATCHES %@","^(?!.*[0-9])\\S+(\\s\\S+){1,}$")
    static var descriptionPredicate = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z0-9 .,/:-\(turkishCharacterSet)]{2,200}$")
    static var virtualCardAliasPredicate = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z0-9 .,/:-\(turkishCharacterSet)]{2,30}$")


   //MARK: - Default Text Validator
    class DefaultTextValidator: ObservableObject {
        
        var predicate: NSPredicate
        var minLenght: Int?
        @Published var text = ""
        @Published var isCriteriaValid = false
        @Published var isNotValid = false
        @Published var showPrompt = false
        @Published var showMinErrorPrompt = false

        private var cancellableSet: Set<AnyCancellable> = []
        
        init(predicate: NSPredicate, minLenght: Int? = nil) {
            self.predicate = predicate
            self.minLenght = minLenght
            
            $text
                .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .sink(receiveValue: { [weak self] t in
                    guard let self = self else{
                        return
                    }
                    if let minLenght = minLenght, ((!self.text.isEmpty) && self.text.count < minLenght) {
                        self.isCriteriaValid = false
                        self.isNotValid = true
                        self.showMinErrorPrompt = true
                        self.showPrompt = false
                    } else {
                        self.showMinErrorPrompt = false
                        self.isCriteriaValid = self.predicate.evaluate(with: t)
                        if !self.text.isEmpty && self.text.trimmingAllSpaces().isEmpty {
                            self.isNotValid = true
                            self.showPrompt = true
                        } else {
                            self.isNotValid = !self.isCriteriaValid && !self.text.isEmpty
                            self.showPrompt = !self.isCriteriaValid && !self.text.isEmpty
                        }
                    }
                    
                })
                .store(in: &cancellableSet)
        }

    }
    
    final class MatchValidator: ObservableObject {
        var predicate: NSPredicate
        
        @Published var firstText = ""
        @Published var firstIsCriteriaValid = false
        @Published var firstShowPrompt = false
        
        @Published var secondText = ""
        @Published var secondIsCriteriaValid = false
        @Published var secondShowPrompt = false
        
        @Published var matchCriteriaValid = false
        
        private var cancellableSet: Set<AnyCancellable> = []
        
        init(predicate: NSPredicate) {
            self.predicate = predicate
            Publishers
                .CombineLatest($firstText, $secondText)
                .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .receive(on: RunLoop.main)
                .sink { [weak self] (firstText, secondText) in
                    guard let self = self else { return }
                    let isMatched = firstText == secondText
                    
                    let isValidFirstText = self.predicate.evaluate(with: firstText)
                    self.firstIsCriteriaValid = isValidFirstText
                    self.firstShowPrompt = !isValidFirstText && !firstText.isEmpty

                    let isValidSecondText = self.predicate.evaluate(with: secondText)
                    self.secondIsCriteriaValid = isValidSecondText
                    self.secondShowPrompt = (!isValidSecondText && !secondText.isEmpty) || !isMatched
                    
                    self.matchCriteriaValid = isValidFirstText && isValidSecondText && isMatched
                }
                .store(in: &cancellableSet)
        }
    }
    
    final class AmountValidator: ObservableObject {
        var predicate: NSPredicate
        @Published var text = ""
        @Published var isCriteriaValid = false
        @Published var showPrompt = false
        private let formatter = NumberFormatter()
        private var cancellableSet: Set<AnyCancellable> = []
        
        init(predicate: NSPredicate) {
            self.predicate = predicate
            self.formatter.numberStyle = .decimal
            self.formatter.currencySymbol = "₺"
            self.formatter.decimalSeparator = ","
            self.formatter.groupingSeparator = "."
            self.formatter.maximumFractionDigits = 2
            
            $text
                .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
                .sink { [weak self] t in
                    guard let self = self else {
                        return
                    }
                    var newText = t.replacingOccurrences(of: "₺", with: "")
                    newText = newText.replacingOccurrences(of: ".", with: "")
                    if let value = self.formatter.number(from: newText),
                       let doubleValue = value as? Double,
                       doubleValue > 0 {
                        self.isCriteriaValid = self.predicate.evaluate(with: t)
                    }
                    if !self.text.isEmpty && self.text.trimmingAllSpaces().isEmpty {
                        self.showPrompt = true
                    } else {
                        self.showPrompt = !self.isCriteriaValid && !self.text.isEmpty
                    }
                }
                .store(in: &cancellableSet)
        }
    }
}
