//import SwiftUI
//
//struct ContentView: View {
//    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
//    let requiredStrokes: [Character: Int] = [
//        "A": 3, "B": 2, "C": 1, "D": 2, "E": 4, "F": 3, "G": 2, "H": 3, "I": 3,
//        "J": 1, "K": 3, "L": 2, "M": 4, "N": 3, "O": 1, "P": 2, "Q": 2, "R": 2,
//        "S": 1, "T": 2, "U": 1, "V": 2, "W": 4, "X": 2, "Y": 3, "Z": 3
//    ]
//    
//    let selectedLetter: Character?
//    
//    // Tracking progress stats
//    @State private var totalAttempts = 0
//    @State private var correctAttempts = 0
//    @State private var incorrectAttempts = 0
//    
//    // Canvas state
//    @State private var currentLetterIndex = 0
//    @State private var practiceStrokeCount = 0
//    @State private var finalStrokeCount = 0
//    @State private var resetPracticeCanvas = false
//    @State private var resetFinalCanvas = false
//    @State private var isFinalCanvasUnlocked = false
//
//    // Progress Tracking
//    @State private var lastAttemptedLetter: Character = "A"
//
//    // **New: ActiveSheet Enum**
//    enum ActiveSheet: Identifiable {
//        case progress, letterMenu
//        var id: Self { self }
//    }
//    @State private var activeSheet: ActiveSheet? = nil
//
//    // **Alerts**
//    @State private var showAlert = false
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    
//    var currentLetter: Character {
//        letters[currentLetterIndex]
//    }
//    var maxStrokes: Int {
//        requiredStrokes[currentLetter] ?? 1
//    }
//    var practiceImageName: String {
//        "\(currentLetter)"
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                Image("grass")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: geometry.size.width * 0.7,
//                           height: geometry.size.height * 0.35)
//                    .offset(x: 60, y: 500)
//                
//                VStack {
//                    HStack {
//                        Text("Strokes: \(practiceStrokeCount)/\(maxStrokes)")
//                        Spacer()
//                        Button("Reset") {
//                            resetPracticeCanvas = true
//                            isFinalCanvasUnlocked = false
//                            
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                resetPracticeCanvas = false
//                            }
//                        }
//                        .padding()
//                    }
//                    .frame(width: geometry.size.width * 0.4)
//                    
//                    ZStack {
//                        Image(practiceImageName)
//                            .resizable()
//                            .scaledToFill()
//                            .opacity(0.6)
//                            .frame(width: geometry.size.width * 0.4,
//                                   height: geometry.size.height * 0.6)
//                        
//                        PracticeCanvas(
//                            strokeCount: $practiceStrokeCount,
//                            maxStrokes: maxStrokes,
//                            resetCanvasTrigger: $resetPracticeCanvas
//                        ) {
//                            isFinalCanvasUnlocked = true
//                        }
//                        .frame(width: geometry.size.width * 0.4,
//                               height: geometry.size.height * 0.6)
//                    }
//                }
//                .offset(x: -150, y: 80)
//                
//                VStack {
//                    ZStack {
//                        Image("canvas")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: geometry.size.width * 0.55,
//                                   height: geometry.size.height * 0.6)
//                        
//                        FinalCanvas(
//                            strokeCount: $finalStrokeCount,
//                            maxStrokes: maxStrokes,
//                            resetCanvasTrigger: $resetFinalCanvas,
//                            isCanvasUnlocked: isFinalCanvasUnlocked,
//                            onClassify: { drawnImage in
//                                classifyDrawing(drawnImage, useVision: false) { detectedLetter in
//                                    DispatchQueue.main.async {
//                                        validateLetter(detectedLetter)
//                                    }
//                                }
//                            }
//                        )
//                        .frame(width: geometry.size.width * 0.37,
//                               height: geometry.size.height * 0.32)
//                        .offset(x: -12, y: 140)
//                    }
//                    
//                    HStack {
//                        Text("Strokes: \(finalStrokeCount)/\(maxStrokes)")
//                        Spacer()
//                        Button("Retry") {
//                            clearCanvases()
//                        }
//                        Spacer()
//                        Button("Skip") {
//                            lastAttemptedLetter = currentLetter
//                            activeSheet = .progress
//                        }
//                    }
//                    .frame(width: geometry.size.width * 0.37)
//                    .offset(x: -20, y: 60)
//                }
//                .offset(x: 430, y: 80)
//            }
//            .padding()
//            .alert(alertTitle, isPresented: $showAlert) {
//                Button("OK") {
//                    if alertTitle == "Correct!" {
//                        lastAttemptedLetter = currentLetter
//                        activeSheet = .progress
//                    }
//                }
//            } message: {
//                Text(alertMessage)
//            }
//            .fullScreenCover(item: $activeSheet) { sheet in
//                switch sheet {
//                case .progress:
//                    ProgressView(
//                        letter: lastAttemptedLetter,
//                        totalAttempts: totalAttempts,
//                        correctAttempts: correctAttempts,
//                        incorrectAttempts: incorrectAttempts,
//                        onDismiss: {
//                            activeSheet = nil
//                            goToNextLetter()
//                        },
//                        onGoToLetterMenu: {
//                            activeSheet = .letterMenu
//                        }
//                    )
//
//                case .letterMenu:
//                    LetterMenuView()
//                }
//            }
//            .navigationBarBackButtonHidden(true)
//        }
//    }
//    
//    func validateLetter(_ detectedLetter: String?) {
//        totalAttempts += 1
//        
//        guard let detected = detectedLetter else {
//            incorrectAttempts += 1
//            showCustomAlert(title: "No Letter Recognized", message: "Detected: None\nExpected: \(currentLetter)")
//            return
//        }
//        
//        if detected == String(currentLetter), finalStrokeCount == maxStrokes {
//            correctAttempts += 1
//            showCustomAlert(title: "Correct!", message: "Detected: \(detected)\nExpected: \(currentLetter)")
//        } else {
//            incorrectAttempts += 1
//            showCustomAlert(title: "Incorrect!", message: "Detected: \(detected)\nExpected: \(currentLetter)")
//        }
//    }
//
//    func showCustomAlert(title: String, message: String) {
//        alertTitle = title
//        alertMessage = message
//        showAlert = true
//    }
//
//    func goToNextLetter() {
//        if currentLetterIndex < letters.count - 1 {
//            currentLetterIndex += 1
//        }
//        clearCanvases()
//    }
//
//    func clearCanvases() {
//        practiceStrokeCount = 0
//        finalStrokeCount = 0
//        isFinalCanvasUnlocked = false
//
//        resetPracticeCanvas = true
//        resetFinalCanvas = true
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            resetPracticeCanvas = false
//            resetFinalCanvas = false
//        }
//    }
//}
//
//struct LetterMenuView: View {
//    let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
//    @State private var selectedLetter: Character? // Track selected letter
//    @State private var navigateToContent = false // Controls navigation
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 20) {
//                    ForEach(letters, id: \.self) { letter in
//                        Button(action: {
//                            selectedLetter = letter // Set selected letter
//                            navigateToContent = true // Trigger navigation
//                        }) {
//                            ZStack {
//                                Image("\(letter)")
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 60, height: 60)
//                                    .padding(.vertical, 25)
//                                    .border(Color.black, width: 2)
//
//                                // Highlight selected letter
//                                if selectedLetter == letter {
//                                    Color.black.opacity(0.3) // Dim overlay
//                                        .frame(width: 75, height: 70)
//                                        .cornerRadius(8)
//                                }
//                            }
//                        }
//                        .buttonStyle(PlainButtonStyle()) // Remove default button styles
//                    }
//                }
//                .padding()
//
//                Spacer()
//
//                Rectangle()
//                    .fill(Color(hex: "#38bdff"))
//                    .frame(height: 80) // Adjust height as needed
//            }
//            .ignoresSafeArea()
//            .navigationDestination(isPresented: $navigateToContent) {
//                if let selectedLetter = selectedLetter {
//                    ContentView(selectedLetter: selectedLetter) // Pass correct letter
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
