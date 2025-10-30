import SwiftUI

struct ControlView: View {
    // 3 columns for a 3x3 grid
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    @State private var lastCommand: ViewModel.MotionCommand?
    @State private var viewModel = ViewModel()

    var body: some View {
        VStack {
            Text("Motion Control")
                .font(.headline)
                .padding(.bottom, 8)
            

            ZStack{

                Color.clear
                    .padding()
            }
            
            LazyVGrid(columns: columns, spacing: 16) {
                
                Text("\(String(describing: lastCommand? .name ?? "-"))")
                    .padding()
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentTransition(.numericText(countsDown: true))
                    .background(
                        RoundedRectangle(cornerRadius: 33.0)
                        
    //                        .fill(Constants.offWhite)
                            .stroke(.white)
                            
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

        struct MotionCommand: Identifiable, Hashable {
            let id = UUID()
            let name: String
            let symbol: String
            let shortcut: Character
        }

        let motionCommands: [MotionCommand] = [
            MotionCommand(name: "Turn Left", symbol: "↺", shortcut: "q"),
            MotionCommand(name: "Forward", symbol: "▲", shortcut: "W"),
            MotionCommand(name: "Turn Right", symbol: "↻", shortcut: "e"),
            MotionCommand(name: "Left", symbol: "◀", shortcut: "a"),
            MotionCommand(name: "Stop", symbol: "●", shortcut: " "),
            MotionCommand(name: "Right", symbol: "▶", shortcut: "d"),
            MotionCommand(name: "Up", symbol: "△", shortcut: "z"),
            MotionCommand(name: "Backward", symbol: "▼", shortcut: "x"),
            MotionCommand(name: "Down", symbol: "▽", shortcut: "c"),
            MotionCommand(name: "PID_Toggle", symbol: "PID", shortcut: "p"),
            MotionCommand(name: "Yaw", symbol: "Set Yaw", shortcut: "["),
            MotionCommand(name: "Depth", symbol: "Set Depth", shortcut: "]")
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
