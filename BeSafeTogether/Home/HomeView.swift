import SwiftUI
import Moya
import AVFoundation

enum MicButtonView {
    case noRequirements
    case requirementsMet
}

struct HomeView: View {
    @State private var isRecording = false
    @StateObject private var audioRecorder = AudioRecorder()
    @StateObject private var transcriptionViewModel = TranscriptionViewModel()
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Text("Welcome Home!")
                .font(.title)
                .padding(.top, 30)
            
            MicButton(homeViewModel: homeViewModel, isRecording: $isRecording)
                .padding(.top, 60)
            
            Button(action: {
                audioRecorder.stopRecording()
                print(230)
            }) {
                Text("Stop Recording")
            }
            
            Spacer()
            
            RequirementsList(homeViewModel: homeViewModel)
                .padding(.bottom, 25)
        }
        .onAppear {
            requestMicrophoneAccess()
            audioRecorder.transcriptionViewModel = transcriptionViewModel
        }
    }
    
}

func getFullRecordingPath() -> URL? {
    let fileManager = FileManager.default
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }
    
    let recordingFileName = "recording.mp3" // Update the file name and extension if needed
    
    return documentsDirectory.appendingPathComponent(recordingFileName)
}

func requestMicrophoneAccess() {
    AVAudioSession.sharedInstance().requestRecordPermission { granted in
        if granted {
            // Microphone access is granted, you can start recording
        } else {
            // Microphone access is not granted, handle this case (e.g., show an alert)
        }
    }
}

struct MicButton: View {
    @ObservedObject var homeViewModel: HomeViewModel
    @Binding var isRecording: Bool
    
    var body: some View {
        Button(action: {
            if self.homeViewModel.isRequirementsMet {
                self.isRecording.toggle()
                
                if self.isRecording {
                    AudioRecorder.shared.startRecording()
                } else {
                    AudioRecorder.shared.stopRecording()
                }
            }
        }) {
            ZStack {
                Circle()
                    .foregroundColor(Color("gray 25"))
                    .frame(width: 220)
                VStack {
                    switch homeViewModel.isRequirementsMet {
                    case true:
                        Image(systemName: "mic.fill")
                            .resizable()
                            .frame(width: 55, height: 80)
                            .foregroundColor(isRecording ? .red : .green)
                        Text(isRecording ? "Stop Recording" : "Start Recording")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.top, 14)
                            .foregroundColor(isRecording ? .red : .green)
                    case false:
                        Image(systemName: "mic.fill")
                            .resizable()
                            .frame(width: 55, height: 80)
                            .foregroundColor(Color("gray 50"))
                        Text("No requirements")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.top, 14)
                            .foregroundColor(Color("gray 50"))
                    }
                }
            }
            .onChange(of: isRecording) { newValue in
                if !newValue {
                    // Stop recording when the button is clicked again
                    AudioRecorder.shared.stopRecording()
                }
            }
        }
    }
}

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    static let shared = AudioRecorder()
    
    private var audioRecorder: AVAudioRecorder?
    private let recordingDuration: TimeInterval = 10.0
    private var recordingIndex = 1 // Initialize recording index
    
    @Published var recordedFiles: [URL] = []
    var transcriptionViewModel: TranscriptionViewModel? // Add this property to hold the TranscriptionViewModel instance
    
    override init() {
        super.init()
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording\(recordingIndex).wav")
        let settings = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ] as [String: Any]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record(forDuration: recordingDuration)
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        guard let recordedURL = audioRecorder?.url else { return }
        // Instead of adding to recordedFiles, we'll use the URL directly for transcription
        if let audioData = try? Data(contentsOf: recordedURL) {
            transcriptionViewModel?.transcribeAudio(file: audioData)
        } // Use the transcriptionViewModel here
        audioRecorder = nil
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

struct RequirementsList: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .frame(width: 360.0, height: 220)
                .cornerRadius(25)
                .padding(10)
            VStack {
                Text("Requirements to use")
                    .foregroundColor(Color.white)
                    .font(.system(size: 26))
                    .padding(.bottom, 10)
                
                OptionView(text: "Gps is enabled", checkState: homeViewModel.isGpsEnabled)
                OptionView(text: "Contacts are set", checkState: homeViewModel.isContactsSet)
                OptionView(text: "Stop words are set", checkState: homeViewModel.isStopWordsSet)
            }
        }
    }
}

struct OptionView: View {
    var text: String
    @State var checkState: Bool
    
    var body: some View {
        HStack {
            Button(action: { self.checkState.toggle() }) {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: checkState ? "checkmark.square.fill" : "square")
                        .foregroundColor(Color.white)
                        .font(.system(size: 30))
                }
            }
            Text(text)
                .foregroundColor(Color.white)
                .font(.system(size: 18))
            Spacer()
            Button(action: {}){
                Image(systemName: "arrow.forward")
                    .foregroundColor(Color.white)
                    .font(.system(size: 25))
            }
        }
        .padding([.leading, .trailing], 47)
        .padding(.bottom, 3)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

class TranscriptionViewModel: ObservableObject {
    let provider = MoyaProvider<Service>()
    @Published var transcriptionResult: String?
    
    func transcribeAudio(file: Data) {
        provider.request(.transcribeAudio(file: file)) { result in
            switch result {
            case let .success(response):
                do {
                    let responseModel = try JSONDecoder().decode(TranscriptionResponse.self, from: response.data)
                    DispatchQueue.main.async {
                        self.transcriptionResult = responseModel.transcription
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            case let .failure(error):
                print("API request failed: \(error)")
            }
        }
    }
}




struct TranscriptionResponse: Codable {
    let transcription: String
}
