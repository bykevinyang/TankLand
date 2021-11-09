extension TankLand{
  func printGrid() {
		var boxWidth = Constants.displayWidth/self.numberCols
		
		let topBar = String(repeating: "_", count: Constants.displayWidth + 16)	
		let seperatingBar = String(repeating: "|_______", count: Constants.displayWidth/7) + "|"

		print(topBar)
    for num in 1...15 {
    for r in 0...self.numberRows*4 {
      for c in 0..<self.numberCols {
				var one = "|" + fit((/*energy*/, 7, right: Bool = true)
				var two = "|" + fit(/*ID*/, 7, right: Bool = true)
        var three = "|" + fit(/*position*/, 7, right: Bool = true)
        var four = seperatingBar
				}
      }
    }
		print(seperatingBar)
    }
	}
}

