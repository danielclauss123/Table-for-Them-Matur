import SwiftUI

/// Adds a magnification gesture and tracks the scale to provide fluid scaling.
struct MagnificationGestureModifier: ViewModifier {
    @Binding var scale: Double
    
    @State private var lastSetScale: Double
    
    @State private var scaleChangeThroughGesture = false
    
    let maximumScale: Double
    let minimumScale: Double
    
    func body(content: Content) -> some View {
        content
            .gesture(
                MagnificationGesture()
                    .onChanged {
                        scaleChangeThroughGesture = true
                        scale = max(min(lastSetScale * $0, maximumScale), minimumScale)
                    }
                    .onEnded { value in
                        scaleChangeThroughGesture = true
                        lastSetScale = scale
                    }
            )
            .onChange(of: scale) { newValue in
                if !scaleChangeThroughGesture {
                    if newValue > maximumScale {
                        scale = maximumScale
                    } else if newValue < minimumScale {
                        scale = minimumScale
                    }
                    
                    lastSetScale = scale
                }
                
                scaleChangeThroughGesture = false
            }
    }
    
    /// Adds a magnification gesture and tracks the scale to provide fluid scaling.
    /// - Parameters:
    ///   - scale: The scale of the gesture that should be applied to the view that gets scaled.
    ///   - maximumScale: The minimum scale, meaning the most the user can zoom out.
    ///   - minimumScale: The maximum scale, meaning the most the user can zoom in.
    init(scale: Binding<Double>, maximumScale: Double = .infinity, minimumScale: Double = 0) {
        self._scale = scale
        self.lastSetScale = scale.wrappedValue
        
        self.maximumScale = maximumScale
        self.minimumScale = minimumScale
    }
}

extension View {
    /// Adds a magnification gesture and tracks the scale to provide fluid scaling.
    /// - Parameters:
    ///   - scale: The scale of the gesture that should be applied to the view that gets scaled.
    ///   - maximumScale: The minimum scale, meaning the most the user can zoom out.
    ///   - minimumScale: The maximum scale, meaning the most the user can zoom in.
    func magnificationGesture(scale: Binding<Double>, maximumScale: Double = .infinity, minimumScale: Double = 0) -> some View {
        modifier(MagnificationGestureModifier(scale: scale, maximumScale: maximumScale, minimumScale: minimumScale))
    }
}
