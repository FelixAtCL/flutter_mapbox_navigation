extension FLTScreenCoordinate {
    func toScreenCoordinate() -> ScreenCoordinate {
        return ScreenCoordinate(x: self.x.doubleValue, y: self.y.doubleValue)
    }

    func toCGPoint() -> CGPoint {
        return CGPoint(x: self.x.doubleValue, y: self.y.doubleValue)
    }
}