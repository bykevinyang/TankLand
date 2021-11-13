// CHECK WITH PAL. IF THIS IS CORRECT

struct Logger: CustomStringConvertible{
	let id: String
	let message: String

	var description: String {
		return self.message
	}

	init(_ id: String, _ message: String) {
		self.id = id
		self.message = message
	}
}