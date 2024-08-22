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
    @StateObject private var ageValidator = DefaultTextValidator(predicate: ValidatorHelper.agePredicate)
    @StateObject private var heightValidator = DefaultTextValidator(predicate: ValidatorHelper.heightPredicate)
    @StateObject private var weightValidator = DefaultTextValidator(predicate: ValidatorHelper.weightPredicate)
    @StateObject private var birthdayValidator = DefaultTextValidator(predicate: ValidatorHelper.datePredicate)
    @State private var birthday: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    @StateObject private var viewModel = DetailsAboutMeVM()
    @State private var lengthOptions: [CUIDropdownItemModel] = []
    @State private var selectedLengthItem = CUIDropdownItemModel(id: "", text: "")
    @State private var selectedLengthUnit: LengthUnit = .cm
    @State private var selectedPurposeSegmentIndex = 0
    @State private var selectedGenderSegmentIndex = 0
    @State private var isDatePickerVisible = true
    @State private var isLengthExpanded = false
    @State private var weightOptions: [CUIDropdownItemModel] = []
    @State private var selectedWeightItem = CUIDropdownItemModel(id: "", text: "")
    @State private var selectedWeightUnit: WeightUnit = .kg
    @State private var isWeightExpanded = false
    var body: some View {
        ZStack {
            BaseView(currentViewModel: viewModel,
                     background: .lightTeal,
                     showIndicator: $viewModel.showIndicator) {
                NavigationLink(
                    destination: PurposeInputView()
                        .environmentObject(userInputModel),
                    isActive: $viewModel.goToPurposeInputPage
                ) {}
                
                VStack {
                    CUILeftHeadline(
                        title: "Details About You",
                        subtitle: "Diet Genie needs to know a bit about your physiology to create the most suitable plan for you.",
                        style: .black,
                        bottomPadding: 0)
                    VStack(spacing: 20) {
                        SegmentedControlView(segmentTitle: "Please select your gender", selectedIndex: $selectedGenderSegmentIndex, segmentNames: viewModel.genderSegmentItems)
                            .padding(.top,40)
                        ZStack(alignment: .top) {
                            CUIValidationField(
                                placeholder: "Please select birthday",
                                prompt: "",
                                text: $ageValidator.text,
                                isCriteriaValid: $ageValidator.isCriteriaValid,
                                isNotValid: $ageValidator.isNotValid,
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
                        
                        CUIDropdownField(
                            title: "How much do you weight?",
                            isExpanded: $isWeightExpanded,
                            choosenItem: $selectedWeightItem
                        )
                        Spacer()
                        CUIButton(text: "NEXT") {
                            let selectedGender = viewModel.genderSegmentItems[selectedGenderSegmentIndex].title
                            if let hkBiologicalSex = viewModel.genderStringToHKBiologicalSex(selectedGender) {
                                self.userInputModel.gender = hkBiologicalSex
                            }
                            if let age = Int(ageValidator.text) {
                                self.userInputModel.age = age
                            }
                            if let height = Double(heightValidator.text) {
                                self.userInputModel.height = height
                            }
                            if let weight = Double(weightValidator.text) {
                                self.userInputModel.weight = weight
                            }
                            self.viewModel.goToPurposeInputPage = true
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchMenuItems()
                }
            }
                     .navigationBarBackButtonHidden()
                     .navigationBarItems(
                        leading:
                            CUIBackButton()
                     )
                     .ndHeightPickerModifier(
                        itemList: $lengthOptions,
                        isExpanded: $isLengthExpanded,
                        choosenItem: $selectedLengthItem,
                        isSearchBarEnabled: false,
                        searchText: "",
                        selectedUnit: $selectedLengthUnit
                     )
            
                     .ndWeightPickerModifier(
                        itemList: $weightOptions,
                        isExpanded: $isWeightExpanded,
                        choosenItem: $selectedWeightItem,
                        isSearchBarEnabled: false,
                        searchText: "",
                        selectedWeightUnit: $selectedWeightUnit
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
                .frame(width: 25, height: 25)
                .offset(x: 80, y: 0)
                .labelsHidden()
                .clipped()
                .background(Color.clear)
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.textColorsNeutral)
                    .offset(x: 25, y: 0)
                    .onTapGesture {
                        isDatePickerVisible.toggle()
                    }
                    .onChange(of: birthday) { newValue in
                        birthdayValidator.text = newValue.getFormattedDate(format: "dd.MM.yyyy")
                    }
            }
            .offset(x: -10)
            .frame(width: 50, height: 32)
            .background(Color.clear)
        }
        .frame(width: UIScreen.screenWidth / 1.2)
        .offset(x: -20, y: 15)
        .background(Color.clear)
    }
}

struct DetailsAboutMeView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsAboutMeView()
            .environmentObject(UserInputModel()) // Providing the necessary environment object
            .previewLayout(.sizeThatFits) // Adjust the preview layout to fit the content
    }
}
