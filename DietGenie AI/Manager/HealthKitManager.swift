import HealthKit
import FirebaseFirestore

class HealthKitManager: ObservableObject {
    private var healthStore = HKHealthStore()
    private let db = Firestore.firestore()  // Add Firestore instance
    @Published var isAuthorized = false
    
    func requestAuthorization() {
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!,
            HKObjectType.quantityType(forIdentifier: .leanBodyMass)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
        ]
        
        healthStore.requestAuthorization(toShare: [], read: readTypes) { (success, error) in
            DispatchQueue.main.async {
                self.isAuthorized = success
                if let error = error {
                    print("Error requesting HealthKit authorization: \(error.localizedDescription)")
                }
            }
        }
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
    
    func fetchYearlyData(userId: String, completion: @escaping (Double?, Double?, Double?, Double?, Double?, HKBiologicalSex?, Double?, Int?) -> Void) {
        guard isAuthorized else {
            completion(nil, nil, nil, nil, nil, nil, nil, nil)
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        var activeEnergy: Double?
        var restingEnergy: Double?
        var bodyFatPercentage: Double?
        var leanBodyMass: Double?
        var weight: Double?
        var height: Double?
        var gender: HKBiologicalSex?
        var age: Int?
        
        let now = Date()
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .year, value: -1, to: now)!
        
        func fetchData(for type: HKQuantityTypeIdentifier, unit: HKUnit, isDiscrete: Bool, completion: @escaping (Double?) -> Void) {
            let quantityType = HKQuantityType.quantityType(forIdentifier: type)!
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: [])
            
            let query: HKStatisticsQuery
            if isDiscrete {
                query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, error in
                    if let error = error {
                        print("Error fetching \(type.rawValue) from HealthKit: \(error.localizedDescription)")
                        completion(nil)
                        return
                    }
                    
                    let quantity = result?.averageQuantity()
                    let value = quantity?.doubleValue(for: unit)
                    completion(value)
                }
            } else {
                query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                    if let error = error {
                        print("Error fetching \(type.rawValue) from HealthKit: \(error.localizedDescription)")
                        completion(nil)
                        return
                    }
                    
                    let quantity = result?.sumQuantity()
                    let value = quantity?.doubleValue(for: unit)
                    completion(value)
                }
            }
            
            healthStore.execute(query)
        }
        
        dispatchGroup.enter()
        fetchData(for: .activeEnergyBurned, unit: .kilocalorie(), isDiscrete: false) { value in
            activeEnergy = value
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchData(for: .basalEnergyBurned, unit: .kilocalorie(), isDiscrete: false) { value in
            restingEnergy = value
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchData(for: .bodyFatPercentage, unit: .percent(), isDiscrete: true) { value in
            bodyFatPercentage = value
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchData(for: .leanBodyMass, unit: .gramUnit(with: .kilo), isDiscrete: true) { value in
            leanBodyMass = value
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchData(for: .bodyMass, unit: .gramUnit(with: .kilo), isDiscrete: true) { value in
            weight = value
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchData(for: .height, unit: .meter(), isDiscrete: true) { value in
            height = value
            if height == nil { // Fallback to the latest value if nil
                self.fetchMostRecentHeight { mostRecentHeight in
                    height = mostRecentHeight
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        fetchGender { value in
            gender = value
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchDateOfBirth { dob in
            if let dob = dob {
                let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
                age = ageComponents.year
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchMostRecentWeight { value in
            weight = value
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.saveHealthDataToFirestore(
                userId: userId,
                activeEnergy: activeEnergy,
                restingEnergy: restingEnergy,
                bodyFatPercentage: bodyFatPercentage,
                leanBodyMass: leanBodyMass,
                weight: weight,
                gender: gender,
                height: height,
                age: age
            ) {
                completion(activeEnergy, restingEnergy, bodyFatPercentage, leanBodyMass, weight, gender, height, age)
            }
        }
    }
    
    func fetchMostRecentWeight(completion: @escaping (Double?) -> Void) {
        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: weightType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let error = error {
                print("Error fetching most recent weight from HealthKit: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let sample = samples?.first as? HKQuantitySample else {
                completion(nil)
                return
            }
            
            let weight = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            completion(weight)
        }
        healthStore.execute(query)
    }
    
    func fetchMostRecentHeight(completion: @escaping (Double?) -> Void) {
        let heightType = HKObjectType.quantityType(forIdentifier: .height)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let error = error {
                print("Error fetching most recent height from HealthKit: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let sample = samples?.first as? HKQuantitySample else {
                completion(nil)
                return
            }
            
            let height = sample.quantity.doubleValue(for: HKUnit.meter())
            completion(height)
        }
        healthStore.execute(query)
    }
    
    func fetchGender(completion: @escaping (HKBiologicalSex?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil)
            return
        }
        
        do {
            let biologicalSex = try healthStore.biologicalSex().biologicalSex
            completion(biologicalSex)
        } catch {
            print("Error fetching gender from HealthKit: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    func fetchDateOfBirth(completion: @escaping (Date?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil)
            return
        }
        
        do {
            let dateOfBirth = try healthStore.dateOfBirth()
            completion(dateOfBirth)
        } catch {
            print("Error fetching date of birth from HealthKit: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    func saveHealthDataToFirestore(
        userId: String,
        activeEnergy: Double?,
        restingEnergy: Double?,
        bodyFatPercentage: Double?,
        leanBodyMass: Double?,
        weight: Double?,
        gender: HKBiologicalSex?,
        height: Double?,
        age: Int?,
        completion: @escaping () -> Void
    ) {
        // Prepare health data as a dictionary
        let healthData = [
            "activeEnergyBurned": activeEnergy as Any,
            "restingEnergyBurned": restingEnergy as Any,
            "bodyFatPercentage": bodyFatPercentage as Any,
            "leanBodyMass": leanBodyMass as Any,
            "weight": weight as Any,
            "height": height as Any,
            "gender": hkBiologicalSexToGenderString(gender ?? .notSet),
            "age": age as Any,
            "timestamp": Timestamp(date: Date())  // Include a timestamp for ordering
        ]
        
        // Add new document to the healthData collection
        db.collection("users").document(userId).collection("healthData").addDocument(data: healthData) { error in
            if let error = error {
                print("Error saving health data to Firestore: \(error.localizedDescription)")
            } else {
                print("Health data successfully saved to Firestore")
                completion() // Call the completion handler after successful save
            }
        }
    }
}

