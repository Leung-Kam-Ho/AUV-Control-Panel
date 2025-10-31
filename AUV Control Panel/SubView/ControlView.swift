import SwiftUI

struct ControlView: View {
    // 3 columns for a 3x3 grid
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    @State private var lastCommand: ViewModel.MotionCommand?
    @State private var viewModel = ViewModel()
    @EnvironmentObject var robotStatus : RobotStatusObject
    @EnvironmentObject var settings: SettingsHandler

    var body: some View {
        VStack {
            ZStack{
                Color.clear
                    .padding()
            }
            
            LazyVGrid(columns: columns, spacing: 16) {
                Text(robotStatus.status.connected ? "\(String(describing: lastCommand? .name ?? "-"))" : "offline")
                    .foregroundStyle(robotStatus.status.connected ? Constants.offWhite : .red)
                    .padding()
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentTransition(.numericText(countsDown: true))
                    .background(
                        RoundedRectangle(cornerRadius: 33.0)
                            .stroke(robotStatus.status.connected ? Constants.offWhite : .red)
                    )
                
                Text("30%")
                    .padding()
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentTransition(.numericText(countsDown: true))
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
                        
                        RobotStatusObject.setMotion(ip: settings.ip, port: settings.port, twist: command.twist * viewModel.power)
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
            }
            .padding()
        }
        .padding()
    }
}

extension ControlView{
    @Observable
    class ViewModel{
        var power = 0.3
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

        let motionCommands: [MotionCommand] = [
            MotionCommand(name: "Turn Left", symbol: "↺", shortcut: "q", twist: Twist(angular: Vector3(x:1))),
            MotionCommand(name: "Forward", symbol: "▲", shortcut: "W", twist: Twist()),
            MotionCommand(name: "Turn Right", symbol: "↻", shortcut: "e", twist: Twist()),
            MotionCommand(name: "Left", symbol: "◀", shortcut: "a", twist: Twist()),
            MotionCommand(name: "Stop", symbol: "●", shortcut: "s", twist: Twist()),
            MotionCommand(name: "Right", symbol: "▶", shortcut: "d", twist: Twist()),
            MotionCommand(name: "Up", symbol: "△", shortcut: "z", twist: Twist()),
            MotionCommand(name: "Backward", symbol: "▼", shortcut: "x", twist: Twist()),
            MotionCommand(name: "Down", symbol: "▽", shortcut: "c", twist: Twist()),
            MotionCommand(name: "PID_Toggle", symbol: "PID", shortcut: "p", twist: Twist()),
            MotionCommand(name: "Yaw", symbol: "Set Yaw", shortcut: "[", twist: Twist()),
            MotionCommand(name: "Depth", symbol: "Set Depth", shortcut: "]", twist: Twist())
        ]
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
