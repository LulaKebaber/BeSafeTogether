import SwiftUI
import Moya
import AVFoundation

enum MicButtonView {
    case noRequirements
    case requirementsMet
}

struct HomeView: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    @ObservedObject var wordsAndContactsStorage = WordsAndContactsStorage()
    
    let notify = NotificationHandler()
    
    var body: some View {
        VStack {
            Text("Welcome Home!")
                .font(.title)
                .padding(.top, 30)
            Button("request") {
                notify.askPermission()
            }
            Button("send") {
                notify.sendNotification()
            }
            MicButton(homeViewModel: homeViewModel)
                .padding(.top, 60)
            Spacer()
            RequirementsList(homeViewModel: homeViewModel)
                .padding(.bottom, 25)
        }
    }
}


struct MicButton: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        Button(action: {
            if self.homeViewModel.isRequirementsMet {
                self.homeViewModel.isRecording.toggle()
                
                if self.homeViewModel.isRecording {
                    self.homeViewModel.startRecording()
                    self.homeViewModel.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                        self.homeViewModel.stopRecording()
                        self.homeViewModel.recordCount += 1
                        self.homeViewModel.startRecording()
                    }
                } else {
                    self.homeViewModel.timer?.invalidate()
                    self.homeViewModel.timer = nil
                    self.homeViewModel.stopRecording()
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
                            .foregroundColor(homeViewModel.isRecording ? .red : .green)
                        Text(homeViewModel.isRecording ? "Stop Recording" : "Start Recording")
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.top, 14)
                            .foregroundColor(homeViewModel.isRecording ? .red : .green)
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
        }
    }
    
    //    func startRecording() {
    //        let filename = getDocumentsDirectory().appendingPathComponent("recording\(self.recordCount).m4a")
    //        
    //        let settings: [String: Any] = [
    //            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
    //            AVSampleRateKey: 12000.0,
    //            AVNumberOfChannelsKey: 1,
    //            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    //        ]
    //        
    //        do {
    //            audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
    //            audioRecorder.record()
    //            print("Started recording: \(filename)")
    //        } catch {
    //            print("Could not start recording")
    //        }
    //    }
    
    //    func stopRecording() {
    //        if audioRecorder != nil {
    //            audioRecorder.stop()
    //            audioRecorder = nil
    //            print("Stopped recording")
    //            let audioFileURL = getDocumentsDirectory().appendingPathComponent("recording\(self.recordCount).m4a")
    //            APIManager.shared.sendTranscriptionRequest(audioFileURL: audioFileURL)
    //        } else {
    //            print("Tried to stop recording, but audioRecorder was nil.")
    //        }
    //    }
    
    //    func getDocumentsDirectory() -> URL {
    //        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    //        return paths[0]
    //    }
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
