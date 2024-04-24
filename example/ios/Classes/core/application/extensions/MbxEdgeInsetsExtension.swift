
extension FLTMbxEdgeInsets {
    func toUIEdgeInsets() -> UIEdgeInsets {
        return UIEdgeInsets(
            top: self.top.doubleValue,
            left: self.left.doubleValue,
            bottom: self.bottom.doubleValue,
            right: self.right.doubleValue)
    }
}
