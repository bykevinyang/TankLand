struct Position: CustomStringConvertible, Equatable{
	var row: Int
  var col: Int

  init (_ row: Int, _ col: Int) {
    self.row = row
    self.col = col
  }

	var description: String {
		return "(\(self.row), \(self.col))"
	}
}
