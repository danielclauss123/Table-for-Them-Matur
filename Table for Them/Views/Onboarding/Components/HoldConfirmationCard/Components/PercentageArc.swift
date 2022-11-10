import SwiftUI

/// A circle that is completed to the given percentage.
///
/// For Example 50 would make a half circle.
struct PercentageArc: InsettableShape {
    var percentageFilled: Double
    
    var startAngle: Angle = .degrees(0)
    var clockwise: Bool = true
    
    var insetAmount = 0.0
    
    var animatableData: Double {
        get { percentageFilled }
        set { percentageFilled = newValue }
    }
    
    var endAngle: Angle {
        .degrees(percentageFilled * (360 / 100))
    }
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}


// MARK: - Previews
struct PercentageArc_Previews: PreviewProvider {
    static var previews: some View {
        PercentageArc(percentageFilled: 100)
            .strokeBorder(lineWidth: 10)
    }
}
