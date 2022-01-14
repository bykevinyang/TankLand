var log: [String] = []

func addLog(cmd: String) {
	log.append(cmd)
}

func printLog(log: [String]) {
	for thing in log {
		print(thing)
	}
}

