extension TankLand {
  func printGrid() {
		var boxWidth = Constants.displayWidth/self.numberCols
		
		let topBar = String(repeating: "_", count: Constants.displayWidth + 16)	
		let separatingBar = String(repeating: "|_______", count: Constants.displayWidth/7) + "|"

		print(topBar)
    
		for r in 0..<self.numberRows {
			var printLines = ["", "", ""]

				for c in 0..<self.numberCols {
					let gameObj = self[r, c]
					var printLine1 = ""
					
					if let val = gameObj {
						let energy = val.energy
						let id = val.id
						let pos = val.position

						printLines[0].append("|" + fitI(energy, 7, right: true))
						printLines[1].append("|" + fit(id, 7, right: true))
						printLines[2].append("|" + fit((val.position.description), 7, right: true))

					} else {
						printLines[0].append("|" + fit("", 7, right: true))
						printLines[1].append("|" + fit("", 7, right: true))
						printLines[2].append("|" + fit("", 7, right: true))
					}
				}
				print(printLines[0] + "|")
				print(printLines[1] + "|")	
				print(printLines[2] + "|")
				print(separatingBar)
    }
		
  }
}


