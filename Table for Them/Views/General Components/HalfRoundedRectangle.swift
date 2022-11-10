import SwiftUI

/// A rectangle with two rounded corners on one edge.
struct HalfRoundedRectangle: InsettableShape {
    let curvedEdge: Edge
    let cornerRadius: CGFloat
    
    var insetAmount = 0.0
    
    var bottomLeftIsCurved: Bool {
        curvedEdge == .bottom || curvedEdge == .leading
    }
    
    var topLeftIsCurved: Bool {
        curvedEdge == .top || curvedEdge == .leading
    }
    
    var topRightIsCurved: Bool {
        curvedEdge == .top || curvedEdge == .trailing
    }
    
    var bottomRightIsCurved: Bool {
        curvedEdge == .bottom || curvedEdge == .trailing
    }
    
    // MARK: - Path
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // The bounds with the inset.
        let minX = rect.minX + insetAmount
        let maxX = rect.maxX - insetAmount
        let minY = rect.minY + insetAmount
        let maxY = rect.maxY - insetAmount
        
        if bottomLeftIsCurved {
            path.move(to: CGPoint(x: minX, y: maxY - cornerRadius))
        } else {
            path.move(to: CGPoint(x: minX, y: maxY))
        }
        
        if topLeftIsCurved {
            path.addLine(to: CGPoint(x: minX, y: minY + cornerRadius))
            path.addArc(center: CGPoint(x: minX + cornerRadius, y: minY + cornerRadius), radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        } else {
            path.addLine(to: CGPoint(x: minX, y: minY))
        }
        
        if topRightIsCurved {
            path.addLine(to: CGPoint(x: maxX - cornerRadius, y: minY))
            path.addArc(center: CGPoint(x: maxX - cornerRadius, y: minY + cornerRadius), radius: cornerRadius, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        } else {
            path.addLine(to: CGPoint(x: maxX, y: minY))
        }
        
        if bottomRightIsCurved {
            path.addLine(to: CGPoint(x: maxX, y: maxY - cornerRadius))
            path.addArc(center: CGPoint(x: maxX - cornerRadius, y: maxY - cornerRadius), radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        } else {
            path.addLine(to: CGPoint(x: maxX, y: maxY))
        }
        
        if bottomLeftIsCurved {
            path.addLine(to: CGPoint(x: minX + cornerRadius, y: maxY))
            path.addArc(center: CGPoint(x: minX + cornerRadius, y: maxY - cornerRadius), radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        } else {
            path.addLine(to: CGPoint(x: minX, y: maxY))
        }
        
        path.closeSubpath()
        
        return path
    }
    
    // MARK: - Inset
    func inset(by amount: CGFloat) -> some InsettableShape {
        var rect = self
        rect.insetAmount += amount
        return rect
    }
    
    // MARK: - Init
    /// Creates a rectangle with two rounded corners on the same edge.
    /// - Parameters:
    ///   - curvedEdge: The edge on which the two rounded corners lye.
    ///   - cornerRadius: The radius for the rounded corners.
    init(_ curvedEdge: Edge, cornerRadius: CGFloat) {
        self.curvedEdge = curvedEdge
        self.cornerRadius = cornerRadius
    }
}


// MARK: - Previews
struct HalfRoundedRectangle_Previews: PreviewProvider {
    static var previews: some View {
        HalfRoundedRectangle(.top, cornerRadius: 25)
            .strokeBorder(Color.blue, lineWidth: 5)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
