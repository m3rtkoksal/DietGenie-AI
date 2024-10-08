//
//  DetailsAboutMeView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 13.08.2024.
//

import SwiftUI

struct DetailsAboutMeView: View {
    @EnvironmentObject var userInputModel: UserInputModel
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject private var healthKitManager = HealthKitManager()
    @State private var showDatePicker = false
    @State private var formattedDate: String = ""
    @StateObject private var birthdayValidator = DefaultTextValidator(predicate: ValidatorHelper.datePredicate)
    @State private var birthday: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    @StateObject private var viewModel = DetailsAboutMeVM()
    @State private var selectedLengthItem = CUIDropdownItemModel(id: "", text: "")
    @State private var selectedLengthUnit: LengthUnit = .cm
    @State private var selectedPurposeSegmentIndex = 0
    @State private var selectedGenderSegmentIndex = 0
    @State private var isDatePickerVisible = true
    @State private var isLengthExpanded = false
    @State private var selectedWeightItem = CUIDropdownItemModel(id: "", text: "")
    @State private var selectedWeightUnit: WeightUnit = .kg
    @State private var isWeightExpanded = false
    @State private var goToHowActivePage = false
    @State private var tempLength: Double? = nil
    @State private var tempWeight: Double? = nil
    var body: some View {
        ZStack {
            BaseView(currentViewModel: viewModel,
                     background: .lightTeal,
                     showIndicator: $viewModel.showIndicator) {
                NavigationLink(
                    destination: HowActiveYouView()
                        .environmentObject(userInputModel),
                    isActive: self.$goToHowActivePage
                ) {}
                VStack {
                    CUILeftHeadline(
                        title: "Details About You",
                        subtitle: "Diet Genie needs to know a bit about your physiology to create the most suitable plan for you.",
                        style: .black,
                        bottomPadding: 0)
                    VStack(spacing: 20) {
                        SegmentedControlView(
                            segmentTitle: "Please select your gender",
                            selectedIndex: $selectedGenderSegmentIndex,
                            segmentNames: viewModel.genderSegmentItems)
                            .padding(.top,40)
                        ZStack(alignment: .top) {
                            CUIValidationField(
                                placeholder: "Please select birthday",
                                prompt: "",
                                text: .constant("Please select birthday"),
                                isCriteriaValid: $birthdayValidator.isCriteriaValid,
                                isNotValid: $birthdayValidator.isNotValid,
                                showPrompt: .constant(false), style: .default)
                            .disabled(true)
                            .background(Color.clear)
                            DatePickerView()
                        }
                        
                        CUIDropdownField(
                            title: "How tall are you?",
                            isExpanded: $isLengthExpanded,
                            choosenItem: $selectedLengthItem
                        )
                        .onTapGesture {
                            isLengthExpanded = true
                        }
                        .onChange(of: selectedLengthItem) { newLength in
                            if let id = newLength.id, let length = Double(id) {
                                tempLength = length
                            } else {
                                tempLength = 0.0
                            }
                        }
                        CUIDropdownField(
                            title: "How much do you weight?",
                            isExpanded: $isWeightExpanded,
                            choosenItem: $selectedWeightItem
                        )
                        .onTapGesture {
                            isWeightExpanded = true
                        }
                        .onChange(of: selectedWeightItem) { newWeight in
                            if let id = newWeight.id, let weight = Double(id) {
                                tempWeight = weight
                            } else {
                                tempWeight = 0.0
                            }
                        }
                        Spacer()
                        CUIButton(text: "NEXT") {
                            viewModel.showIndicator = true
                            if let hkBiologicalSex = viewModel.genderStringToHKBiologicalSex(viewModel.genderSegmentItems[selectedGenderSegmentIndex].title) {
                                self.userInputModel.gender = hkBiologicalSex
                            }
                            self.userInputModel.birthday = birthdayValidator.text
                            if let height = tempLength {
                                self.userInputModel.height = height
                            }
                            if let weight = tempWeight {
                                self.userInputModel.weight = weight
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.goToHowActivePage = true
                            }
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchMenuItems()
                    viewModel.fetchLengthItems()
                    viewModel.fetchWeightItems()
                    if let gender = userInputModel.gender {
                        let genderString = healthKitManager.hkBiologicalSexToGenderString(gender)
                        // Find the index by comparing the string with a property in SegmentTitle
                        selectedGenderSegmentIndex = viewModel.genderSegmentItems.firstIndex { segment in
                            segment.title == genderString // Adjust this line based on your SegmentTitle implementation
                        } ?? 3
                    }
                    if let birthdayString = userInputModel.birthday {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd.MM.yyyy"
                        if let date = formatter.date(from: birthdayString) {
                            birthday = date
                        }
                    }
                    if let height = userInputModel.height {
                        let heightString = String(format: "%.0f", height * 100) // Convert height to string
                        selectedLengthItem = viewModel.lengthOptions.first { $0.id == heightString } ?? CUIDropdownItemModel(id: "", text: "")
                    }
                    if let weight = userInputModel.weight {
                        // Convert weight to an integer string by removing the decimal part
                        let weightString = String(format: "%.0f", weight) // Use "%.0f" to keep only the integer part
                        selectedWeightItem = viewModel.weightOptions.first { $0.id == weightString } ?? CUIDropdownItemModel(id: "", text: "")
                    }

                }
                .onDisappear {
                    viewModel.showIndicator = false
                }
                .onChange(of: selectedLengthUnit) { _ in
                    viewModel.loadLengthItems(for: selectedLengthUnit)
                }
                .onChange(of: selectedWeightUnit) { _ in
                    viewModel.loadWeightItems(for: selectedWeightUnit)
                }
            }
                     .navigationBarBackButtonHidden()
                     .navigationBarItems(
                        leading:
                            CUIBackButton()
                     )
            
                     .heightPickerModifier(
                        lengthOptions: $viewModel.lengthOptions,
                        isExpanded: $isLengthExpanded,
                        selectedItem: $selectedLengthItem,
                        selectedUnit: $selectedLengthUnit
                     )
                     .weightPickerModifier(
                        weightOptions: $viewModel.weightOptions,
                        isExpanded: $isWeightExpanded,
                        selectedItem: $selectedWeightItem,
                        selectedUnit: $selectedWeightUnit
                     )
                     .toolbar {
                         ToolbarItem(placement: .navigationBarTrailing) {
                             HStack(spacing: 0) {
                                 Spacer(minLength: 0)
                                 CUIProgressView(progressCount: 3, currentProgress: 1)
                                     .padding(.trailing, UIScreen.screenWidth * 0.17)
                             }
                         }
                     }
        }
    }
    
    private func DatePickerView() -> some View {
        HStack{
            Spacer()
            ZStack{
                DatePicker("",
                           selection: $birthday,
                           in: ...Calendar.current.date(byAdding: .year, value: -18, to: Date())!,
                           displayedComponents: .date
                )
                .labelsHidden()
                .clipped()
                .background(Color.clear)
                .onChange(of: birthday) { newValue in
                    birthdayValidator.text = newValue.getFormattedDate(format: "dd.MM.yyyy")
                }
            }
            .offset(x: -80, y: 15)
            .frame(width: 50, height: 32)
            .background(Color.clear)
        }
    }
}

struct DetailsAboutMeView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsAboutMeView()
            .environmentObject(UserInputModel()) // Providing the necessary environment object
            .previewLayout(.sizeThatFits) // Adjust the preview layout to fit the content
    }
}
