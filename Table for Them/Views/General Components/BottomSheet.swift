/*
 Abstract:
    A bottom sheet like in Apple Maps.
    
    The sheet is offset to the according place and the frame does not change.
    The offset happens with a DragGesture.
    The header gives its bounds to the parent view with an anchor preference. Because of that, the minimum height can be set to always show the header, even in a tab view.
 
 Source:
    The bottom sheet was made by myself. Important is this article for the anchor preferences: https://swiftui-lab.com/communicating-with-the-view-tree-part-2/
 */

import SwiftUI

/// A Bottom Sheet like the one in Apple Maps with 3 states.
///
/// In the down status, only the header is visible.
/// Any views within the content part get disabled by default as long as the sheet is not in up status.
struct BottomSheet<Background: ShapeStyle, Header: View, Content: View>: View {
    @Binding var sheetStatus: BottomSheetStatus
    
    var background: Background
    
    var heightsAfterStatusUpdate: (BottomSheetStatus, (down: Double, middle: Double, up: Double)) -> Void = { _,_ in }
    
    @ViewBuilder var header: () -> Header
    @ViewBuilder var content: () -> Content
    
    @State private var minHeight = 0.0
    @GestureState private var translation = 0.0
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    indicator
                        .padding(.top, 5)
                    
                    header()
                        .padding(10)
                    
                    Divider()
                }
                .anchorPreference(key: HeaderPreferenceKey.self, value: .bounds) {
                    [HeaderPreferenceData(bounds: $0)]
                }
                
                VStack(spacing: 0) {
                    // The overlay is necessary, so that the Spacer always gets his space. Otherwise, Views like Text  didn't "shrunk", because they had a fixed size. This lead to unwanted, ugly UI.
                    Color.clear
                        .overlay {
                            content()
                        }
                        .frame(maxHeight: .infinity)
                        .clipped()
                    
                    Spacer()
                        .frame(height: min(currentStatusOffset(in: geometry), geometry.size.height - minHeight))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background {
                HalfRoundedRectangle(.top, cornerRadius: 10)
                    .fill(background)
                    .ignoresSafeArea(.all, edges: .bottom)
                    .shadow(radius: sheetStatus == .hidden ? 0 : 2)
            }
            .offset(y: currentStatusOffset(in: geometry))
            .animation(.bottomSheet, value: translation)
            .animation(.bottomSheet, value: sheetStatus)
            .gesture(
                DragGesture()
                    .updating($translation) { value, state, _  in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        let translation = value.translation.height
                        
                        switch sheetStatus {
                        case .up:
                            if translation > statusOffset(.middle, in: geometry) + 10 {
                                sheetStatus = .down
                            } else if translation > 50 {
                                sheetStatus = .middle
                            }
                        case .middle:
                            if translation > 50 {
                                sheetStatus = .down
                            } else if translation < -50 {
                                sheetStatus = .up
                            }
                        case .down:
                            if translation < statusOffset(.middle, in: geometry) - geometry.size.height - 10 {
                                sheetStatus = .up
                            } else if translation < -50 {
                                sheetStatus = .middle
                            }
                        default:
                            sheetStatus = .hidden
                        }
                    }
            )
            .onPreferenceChange(HeaderPreferenceKey.self) {
                guard let bounds = $0.first?.bounds else { return }
                let rect = geometry[bounds]
                minHeight = rect.height
            }
            .task {
                callHeightsAfterStatusUpdate(in: geometry)
            }
            .onChange(of: sheetStatus) { newValue in
                callHeightsAfterStatusUpdate(in: geometry)
            }
        }
    }
    
    // MARK: - Indicator
    var indicator: some View {
        Capsule()
            .fill(.secondary)
            .frame(width: 35, height: 5)
    }
    
    // MARK: - Status Offsets
    func statusOffset(_ status: BottomSheetStatus, in geometry: GeometryProxy) -> Double {
        switch status {
            case .up:
            return min(10, geometry.size.height - minHeight)
            case .middle:
                return min(geometry.size.height * 0.6, geometry.size.height - minHeight)
            case .down:
                return geometry.size.height - minHeight
            case .hidden:
                return geometry.size.height
        }
    }
    
    func currentStatusOffset(in geometry: GeometryProxy) -> Double {
        max(statusOffset(sheetStatus, in: geometry) + translation, 0)
    }
    
    func callHeightsAfterStatusUpdate(in geometry: GeometryProxy) {
        let downHeight = geometry.size.height - statusOffset(.down, in: geometry)
        let middleHeight = geometry.size.height - statusOffset(.middle, in: geometry)
        let upHeight = geometry.size.height - statusOffset(.up, in: geometry)
        
        heightsAfterStatusUpdate(sheetStatus, (downHeight, middleHeight, upHeight))
    }
}

// MARK: - Sheet Status
/// The Status of the Bottom sheet: up, middle, or down
enum BottomSheetStatus {
    case up, middle, down, hidden
}

// MARK: - Preferences
fileprivate struct HeaderPreferenceData: Equatable {
    let bounds: Anchor<CGRect>
}

fileprivate struct HeaderPreferenceKey: PreferenceKey {
    static var defaultValue: [HeaderPreferenceData] = []
    
    static func reduce(value: inout [HeaderPreferenceData], nextValue: () -> [HeaderPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

// MARK: - Animation
extension Animation {
    /// The animation used for the bottom sheet.
    static let bottomSheet = Animation.interactiveSpring(response: 0.3)
}


// MARK: - Previews
struct BottomSheet_Previews: PreviewProvider {
    struct Container: View {
        @State private var state = BottomSheetStatus.hidden
        
        var body: some View {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                
                BottomSheet(sheetStatus: $state, background: .ultraThickMaterial) {
                    HStack {
                        Text("Title")
                            .font(.largeTitle)
                        Spacer()
                        Text("asdf")
                    }
                } content: {
                    ScrollView {
                        VStack {
                            ForEach(1 ..< 10) { _ in
                                Text("ScrollView content")
                            }
                        }
                    }
                }
            }
        }
    }
    
    static var previews: some View {
        TabView {
            Container()
                .tabItem {
                    Label("Trash", systemImage: "trash")
                }
        }
    }
}
