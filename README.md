# AUV Control Panel

A SwiftUI-based iOS application for controlling and monitoring an Autonomous Underwater Vehicle (AUV).

## Features

- Real-time control interface for AUV operations
- Device status monitoring and management
- Network communication with AUV systems
- Web view integration for additional interfaces
- Settings management for configuration

## Requirements

- macOS 12.0 or later
- Xcode 14.0 or later
- iOS 15.0 or later

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/auv-control-panel.git
   cd auv-control-panel
   ```

2. Open the project in Xcode:
   ```bash
   open "AUV Control Panel.xcodeproj"
   ```

3. Build and run the application on a simulator or device.

## Usage

1. Launch the app on your iOS device.
2. Connect to your AUV network.
3. Use the control interface to operate the vehicle.
4. Monitor device status in real-time.

## Screenshots

<!-- Place screenshots in the `screenshots/` directory -->
![Main Control Interface](screenshots/control-interface.png)
<!-- Example: ![Device Status](screenshots/device-status.png) -->

## Project Structure

- `AUV_Control_PanelApp.swift`: Main application entry point
- `ContentView.swift`: Primary view controller
- `SubView/`: Subviews for control and web interfaces
- `EnvironmentObject/`: Data models and handlers
- `SharedClass/`: Utility classes for networking and constants
- `msgs/`: Message definitions (e.g., geometry_msgs)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.