import SwiftUI
import AVKit


struct ControlView: View {
    // 3 columns for a 3x3 grid
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    @State private var lastCommand: ViewModel.MotionCommand?
    @State private var viewModel = ViewModel()
    @EnvironmentObject var robotStatus : RobotStatusObject
    @EnvironmentObject var settings: SettingsHandler
    @State var contentVideo = AVPlayer(url: Bundle.main.url(forResource: "brainrot", withExtension: "mp4")!)


    var body: some View {
        VStack {
            ZStack{
                Color.clear
                    .padding()
                VideoPlayer(player: contentVideo)
//                    .frame(width: 360, height: 250)
//                    .cornerRadius(16)
                    .padding()
                    .onAppear() {
                        contentVideo.play()
                        contentVideo.actionAtItemEnd = .none  // Loop Video
                        }
            }
            
            LazyVGrid(columns: columns, spacing: 16) {
                VStack{
                    Text("Depth")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(Constants.notBlack)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 17).fill(Constants.offWhite))
                    Text("\(robotStatus.status.depth)")
                        
                }
                .padding()
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentTransition(.numericText(countsDown: true))
                .background(
                    RoundedRectangle(cornerRadius: 33.0)
                        .stroke(.white)
                )
                            
                VStack{
                    Text("Yaw")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(Constants.notBlack)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 17).fill(Constants.offWhite))
                    Text("\(robotStatus.status.yaw)")
                        
                }
                .padding()
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentTransition(.numericText(countsDown: true))
                .background(
                    RoundedRectangle(cornerRadius: 33.0)
                        .stroke(.white)
                )
                VStack{
                    Text("Heading")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(Constants.notBlack)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 17).fill(Constants.offWhite))
                    Text("\(robotStatus.status.heading)")
                        
                }
                .padding()
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentTransition(.numericText(countsDown: true))
                .background(
                    RoundedRectangle(cornerRadius: 33.0)
                        .stroke(.white)
                )
                
                Text(robotStatus.status.connected ? "Connected" : "Disconnected")
                    .foregroundStyle(robotStatus.status.connected ? .green : .red)
                    .padding()
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentTransition(.numericText(countsDown: true))
                    .background(
                        RoundedRectangle(cornerRadius: 33.0)
                            .stroke(Constants.offWhite)
                    )
                
                // Power control cell
                HStack() {
//                    Text("Power")
//                        .frame(maxWidth: .infinity)
//                        .foregroundStyle(Constants.notBlack)
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 16).fill(Constants.offWhite)) // keep layout similar

                    HStack {
                        // Editable numeric field (0–100)
                        let binding = Binding<String>(
                            get: { String(Int((viewModel.output_power * 100).rounded())) },
                            set: { newValue in
                                // Allow only digits; ignore others
                                let filtered = newValue.filter { $0.isNumber }
                                if let intVal = Int(filtered) {
                                    let clamped = max(0, min(100, intVal))
                                    viewModel.output_power = Double(clamped) / 100.0
                                } else if filtered.isEmpty {
                                    // If cleared, treat as 0 until valid number entered
                                    viewModel.output_power = 0.0
                                }
                            }
                        )

                        TextField("Power %", text: binding)
                            .textFieldStyle(.plain) // no background, no border
                            .keyboardType(.numberPad) // macOS ignores, iOS/iPadOS uses it
//                            .frame(minWidth: 80, maxWidth: 120)
                            .multilineTextAlignment(.center)
                            .onSubmit {
                                // Ensure clamped after submit as well
                                let pct = Int((viewModel.output_power * 100).rounded())
                                let clamped = max(0, min(100, pct))
                                viewModel.output_power = Double(clamped) / 100.0
                            }

                        Text("%")
                            .foregroundStyle(Constants.offWhite)
                            .monospacedDigit()
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
                .padding()
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 33.0)
                        .stroke(.white)
                )

                Text("Manual")
                    .padding()
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentTransition(.numericText(countsDown: true))
                    .background(
                        RoundedRectangle(cornerRadius: 33.0)
                            .stroke(.white)
                            
                    )
                
                ForEach(viewModel.motionCommands, id: \.self) { command in
                    Button {
                        // handle button tap here
                        print("Tapped button \(command.name)")
                        
                        RobotStatusObject.setMotion(ip: settings.ip, port: settings.port, twist: command.twist * viewModel.output_power)
                        withAnimation{
                            lastCommand = command
                        }
                    } label: {
                        // Make label square and circular using aspectRatio
                        Text("\(command.symbol)")
                            .padding()
                            .font(.largeTitle)
                            .foregroundStyle(Constants.notBlack)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 33.0)
                                    .fill(Constants.offWhite)
                                    .stroke(.white)
                                    
                            )
                    }
                    .buttonStyle(PlainButtonStyle()) // remove default button chrome
                    .keyboardShortcut(KeyEquivalent(Character(command.shortcut.lowercased())), modifiers: [])
                }
                ForEach(viewModel.specialCommands, id: \.self) { command in
                    Button {
                        // handle button tap here
                        print("Tapped button \(command.name)")
                        
                        
                        withAnimation{
//                            lastCommand = command
                        }
                        
                        switch command.name {
                        case "PID_Toggle":
                            RobotStatusObject.setPIDToggle(ip: settings.ip, port: settings.port, toggle: !robotStatus.status.pid_enabled)
                        default:
                            print("Nothing to do")
                        }
                    } label: {
                        // Make label square and circular using aspectRatio
                        Text("\(command.symbol)")
                            .padding()
                            .font(.largeTitle)
                            .foregroundStyle(Constants.notBlack)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 33.0)
                                    .fill(command.name == "PID_Toggle" ? (robotStatus.status.pid_enabled ? .green : Constants.offWhite) : Constants.offWhite)
                                    .stroke(.white)
                                    
                            )
                    }
                    .buttonStyle(PlainButtonStyle()) // remove default button chrome
                    .keyboardShortcut(KeyEquivalent(Character(command.shortcut.lowercased())), modifiers: [])
                }
            }
            .padding()
        }
        .padding()
    }
}

extension ControlView{
    @Observable
    class ViewModel{
        struct MotionCommand: Identifiable, Hashable,Equatable {
            static func == (lhs: ControlView.ViewModel.MotionCommand, rhs: ControlView.ViewModel.MotionCommand) -> Bool {
                return lhs.id == rhs.id
                && lhs.name == rhs.name
                && lhs.symbol == rhs.symbol
                && lhs.shortcut == rhs.shortcut
                && lhs.twist == rhs.twist
            }
            
            let id = UUID()
            let name: String
            let symbol: String
            let shortcut: Character
            let twist: Twist
            
            
        }
        
        struct SpecialCommand: Identifiable, Hashable,Equatable {
            static func == (lhs: ControlView.ViewModel.SpecialCommand, rhs: ControlView.ViewModel.SpecialCommand) -> Bool {
                return lhs.id == rhs.id
                && lhs.name == rhs.name
                && lhs.symbol == rhs.symbol
                && lhs.shortcut == rhs.shortcut
            }
            
            let id = UUID()
            let name: String
            let symbol: String
            let shortcut: Character
        }

        let motionCommands: [MotionCommand] = [
            MotionCommand(name: "Turn Left", symbol: "↺", shortcut: "q", twist: Twist(angular: Vector3(z:1))),
            MotionCommand(name: "Forward", symbol: "▲", shortcut: "W", twist: Twist(linear: Vector3(x:1))),
            MotionCommand(name: "Turn Right", symbol: "↻", shortcut: "e", twist: Twist(angular: Vector3(z:-1))),
            MotionCommand(name: "Left", symbol: "◀", shortcut: "a", twist: Twist(linear: Vector3(y:1))),
            MotionCommand(name: "Stop", symbol: "●", shortcut: "s", twist: Twist()),
            MotionCommand(name: "Right", symbol: "▶", shortcut: "d", twist: Twist(linear: Vector3(y:-1))),
            MotionCommand(name: "Up", symbol: "△", shortcut: "z", twist: Twist(linear: Vector3(z:1))),
            MotionCommand(name: "Backward", symbol: "▼", shortcut: "x", twist: Twist(linear: Vector3(x:-1))),
            MotionCommand(name: "Down", symbol: "▽", shortcut: "c", twist: Twist(linear: Vector3(z:-1))),
        ]
        
        let specialCommands:[SpecialCommand] = [
            SpecialCommand(name: "PID_Toggle", symbol: "PID", shortcut: "p"),
            SpecialCommand(name: "Yaw", symbol: "Set Yaw", shortcut: "["),
            SpecialCommand(name: "Depth", symbol: "Set Depth", shortcut: "]")
        ]
        var output_power : Double = 0.2
        init() {

        }
        
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewLayout(.sizeThatFits)
            ContentView()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
