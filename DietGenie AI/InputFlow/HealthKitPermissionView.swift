//
//  HealthKitPermissionView.swift
//  DietGenie AI
//
//  Created by Mert Köksal on 20.08.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Combine

enum AlertType: Identifiable {
    case authorizationRequired
    case premiumAccountNeeded
    case noDietPlan
    
    var id: UUID {
        switch self {
        case .authorizationRequired:
            return UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        case .premiumAccountNeeded:
            return UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
        case .noDietPlan:
            return UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
        }
    }
}

struct HealthKitPermissionView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userInputModel: UserInputModel
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var viewModel = HealthKitPermissionVM()
    @State private var scrollViewContentOffset: CGFloat = 0
    @State private var showAlert = false
    @State private var isOn: Bool = false
    @State private var hasCheckedAuthorization = false
    @State private var activeAlert: AlertType?
    private let db = Firestore.firestore()
    
    func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .background:
            self.checkHealthKitAuthorization()
            isOn = healthKitManager.isAuthorized
        case .active:
            // Check authorization when the app becomes active
            self.checkHealthKitAuthorization()
            isOn = healthKitManager.isAuthorized
        default:
            break
        }
    }
    
    var body: some View {
        BaseView(currentViewModel: viewModel,
                 background: .lightTeal,
                 showIndicator: $viewModel.showIndicator,
                 scrollViewOffset: scrollViewContentOffset) {
            NavigationLink(
                destination: DetailsAboutMeView()
                    .environmentObject(userInputModel),
                isActive: $viewModel.goToBMIInputPage
            ) {}
            TrackableScrollView(.vertical,
                                showIndicators: false,
                                contentOffset: $scrollViewContentOffset) {
                CUILeftHeadline(
                    title: "Health Data",
                    subtitle: "",
                    style: .black,
                    bottomPadding: 20)
                VStack(spacing: 60) {
                    Text("Diet Genie uses your calorie intake, fitness activities, height and weight, and other health related data to provide you with our customized services. \n\n The core features of Diet Genie can't function without such data. If you don't agree, you won't be able to use the app.")
                        .foregroundColor(.black)
                        .font(.montserrat(.medium, size: 14))
                        .padding(.horizontal,33)
                        .padding(.top,10)
                        .fixedSize(horizontal: false, vertical: true)
                    ZStack {
                        RoundedRectangle(cornerRadius: 38)
                            .fill(Color.white)
                        HStack {
                            Image("health")
                                .foregroundColor(.red)
                            Text("Export Data From Apple Health")
                                .foregroundColor(.black)
                                .font(.montserrat(.bold, size: 14))
                                .multilineTextAlignment(.leading)
                                .frame(width: UIScreen.screenWidth * 0.34)
                            Spacer()
                            Toggle("", isOn: $isOn)
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: .topGreen))
                                .onChange(of: isOn) { newValue in
                                    if newValue {
                                        // Request authorization when toggle is turned on
                                        //                                    showAlert = true
                                        healthKitManager.requestAuthorization()
                                        if healthKitManager.isAuthorized {
                                            isOn = true
                                            viewModel.saveHealthToFireStore()
                                        } else {
                                            isOn = false
                                        }
                                    } else {
                                        if healthKitManager.isAuthorized {
                                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                            }
                                        }
                                    }
                                }
                                .onChange(of: healthKitManager.isAuthorized) { newValue in
                                    isOn = newValue
                                }
                                .onAppear {
                                    //                                healthKitManager.checkAuthorizationStatus()
                                    isOn = healthKitManager.isAuthorized
                                }
                        }
                    }
                    .padding()
                    .frame(maxWidth: UIScreen.screenWidth / 1.2)
                    .background(Color.white)
                    .cornerRadius(38)
                    .overlay(
                        RoundedRectangle(cornerRadius: 38)
                            .strokeBorder(lineWidth: 0.4)
                    )
                    .shadow(color: Color(red: 0.51, green: 0.74, blue: 0.62, opacity: 0.3), radius: 20, x: 0, y: 0)
                    .padding(.top,60)
                    CUIDivider(title: "Or enter Manually")
                    CUIButton(text: "Enter Manually") {
                        viewModel.goToBMIInputPage = true
                    }
                    Button(action: {
                        viewModel.goToPrivacyPolicy = true
                    }) {
                        VStack(alignment: .leading, spacing: 30) {
                            Text("By tapping 'Enter Manually', you agree to the processing of your health data.\n\n For more information have a look at our ")
                                .font(.montserrat(.medium, size: 14)) +
                            Text("Privacy Policy.")
                                .font(.montserrat(.bold, size: 14))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal,33)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }
                                .navigationBarTitle("Health Data")
                                .navigationBarBackButtonHidden(true)
                                .navigationBarItems(
                                    leading:
                                        CUIDismissButton()
                                )
            //                                .alert(isPresented: $showAlert) {
            //                                    Alert(
            //                                        title: Text("Authorization Required"),
            //                                        message: Text("You need to authorize access."),
            //                                        primaryButton: .default(Text("Allow")) {
            //                                            if !healthKitManager.isAuthorized {
            //                                                healthKitManager.requestAuthorization()
            //                                            }
            //                                        },
            //                                        secondaryButton: .cancel(Text("Cancel")) {
            //                                            if !healthKitManager.isAuthorized {
            //                                                isOn = false
            //                                                showAlert = false
            //                                            } else {
            //                                                isOn = true
            //                                            }
            //                                        }
            //                                    )
            //                                }
        }
                 .onChange(of: scenePhase, perform: handleScenePhaseChange)
    }
    
    private func checkHealthKitAuthorization() {
        // Perform the authorization check after a brief delay to allow isAuthorized to update
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !self.healthKitManager.isAuthorized {
                activeAlert = .authorizationRequired
            }
        }
    }
}
