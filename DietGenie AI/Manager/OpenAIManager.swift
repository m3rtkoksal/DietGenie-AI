//
//  OpenAIManager.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 14.08.2024.
//

import Foundation
import HealthKit

class OpenAIManager: ObservableObject {
    private let openAIURL = URL(string: "https://api.openai.com/v1/chat/completions")
    
    private func executeRequest(request: URLRequest) -> Data? {
        
        let semaphore = DispatchSemaphore(value: 0)
        var requestData: Data?
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                requestData = data
            }
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: .now() + 20)
        return requestData
    }
    
    func generatePrompt(userInputModel: UserInputModel, completion: @escaping ([String]?) -> Void) {
        let prompt = createPrompt(from: userInputModel)
        print(prompt)
        RemoteConfigManager.shared.fetchAPIKey { apiKey in
            if let key = apiKey {
                KeychainManager.shared.saveToKeychain(data: key, forKey: .secureToken)
            } else {
                print("Failed to fetch API key")
            }
        }
        let secureToken =  KeychainManager.shared.getStringFromKeychain(forKey: .secureToken)
        guard let url = openAIURL else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(secureToken)", forHTTPHeaderField: "Authorization")
        
        let httpBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 4096,
            "temperature": 0.7
        ]
        
        do {
            let httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
            request.httpBody = httpBodyJson
        } catch {
            print("Unable to convert to JSON: \(error)")
            completion(nil)
            return
        }
        
        // Perform the request asynchronously
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Print the JSON string to see its structure
            if let jsonStr = String(data: data, encoding: .utf8) {
                print("Received JSON Response: \(jsonStr)")
                
                // Attempt to decode the JSON
                let responseHandler = OpenAIResponseHandler()
                if let responseText = responseHandler.decodeJson(jsonString: jsonStr)?.choices.first?.message.content {
                    let meals = self.splitMeals(from: responseText)
                    DispatchQueue.main.async {
                        completion(meals)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }

    func splitMeals(from response: String) -> [String] {
        // Define the meal separator
        let mealSeparator = "***"
        // Define meal keywords for better segmentation
        let mealKeywords = ["Breakfast", "Morning Snack", "Lunch", "Afternoon Snack", "Dinner", "Evening Snack","Meal 1", "Meal 2", "Meal 3", "Meal 4", "Meal 5"]

        // Split the response by the meal separator
        let mealComponents = response.components(separatedBy: mealSeparator)

        // Filter out empty strings and trim whitespace from each component
        let trimmedComponents = mealComponents
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        // Initialize an array to hold meals
        var meals = [String]()
        var currentMeal = ""
        
        // Iterate through the components and format the meal sections
        for component in trimmedComponents {
            // Check if the component starts with any of the defined meal keywords
            let hasKeyword = mealKeywords.contains(where: { component.starts(with: $0) })
            
            if hasKeyword {
                // If there is an existing meal, add it to the meals array
                if !currentMeal.isEmpty {
                    // Remove leading whitespace from the new meal content
                    let trimmedMeal = currentMeal
                        .split(separator: "\n")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .joined(separator: "\n")
                    meals.append(trimmedMeal)
                }
                // Start a new meal
                currentMeal = component
            } else {
                // Continue adding to the current meal
                currentMeal += "\n" + component
            }
        }
        
        // Add the last meal if not empty
        if !currentMeal.isEmpty {
            let trimmedMeal = currentMeal
                .split(separator: "\n")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .joined(separator: "\n")
            meals.append(trimmedMeal)
        }
        
        return meals
    }


    private func createPrompt(from userInputModel: UserInputModel) -> String {
        return """
        Create a personalized diet plan based on the following information:
        - Age: \(userInputModel.age != nil ? "\(userInputModel.age!) years old" : "unknown age")
        - Height: \(userInputModel.height != nil ? "\(userInputModel.height!) meters" : "unknown height")
        - Weight: \(userInputModel.weight != nil ? "\(userInputModel.weight!) kilograms" : "unknown weight")
        - Body Fat Percentage: \(userInputModel.bodyFatPercentage != nil ? "\(userInputModel.bodyFatPercentage!)%" : "unknown body percantage")
        - Lean Body Mass: \(userInputModel.leanBodyMass != nil ? "\(userInputModel.leanBodyMass!) kilograms" : "unknown lean body mass")
        - Active Energy: \(userInputModel.activeEnergy != nil ? "\(userInputModel.activeEnergy!) kcal" : "unknown active energy")
        - Resting Energy: \(userInputModel.restingEnergy != nil ? "\(userInputModel.restingEnergy!) kcal" : "unknown resting energy aka basal metobolsm")
        - Gender: \(userInputModel.gender != nil ? hkBiologicalSexToGenderString(userInputModel.gender!) : "unknown gender")
        - My purpose is to: \(userInputModel.purpose != nil ? "\(userInputModel.purpose!)" : "unknown purpose")
        - Please write grams or litres unit to my meal plan and before each meal add "***" so that I can split each meal in my code from your response
        """
    }
    
    func hkBiologicalSexToGenderString(_ biologicalSex: HKBiologicalSex) -> String {
        switch biologicalSex {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .other:
            return "Other"
        case .notSet:
            return "Not Set"
        @unknown default:
            return "Unknown"
        }
    }
}

struct OpenAIResponseHandler {
    func decodeJson(jsonString: String) -> OpenAIResponse? {
        let json = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(OpenAIResponse.self, from: json)
            return response
        } catch {
            print("Error decoding OpenAI API response: \(error)")
            return nil
        }
    }
}

struct OpenAIResponse: Codable {
    var choices: [Choice]
}

struct Choice: Codable {
    var message: Message
}

struct Message: Codable {
    var content: String
}

