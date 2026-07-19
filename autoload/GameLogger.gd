extends Node

enum Level {
	DEBUG,
	INFO,
	WARN,
	ERROR
}

var level_names = {
	Level.DEBUG: "DEBUG",
	Level.INFO: "INFO",
	Level.WARN: "WARN",
	Level.ERROR: "ERROR",
}

func _write_log(level: Level, system: String, message):
	print("[%s] [%s] %s" % [
		Level.keys()[level],
		system,
		message
	])
	
func info(system, message):
	_write_log(Level.INFO, system, message)

func debug(system, message):
	_write_log(Level.DEBUG, system, message)

func warn(system, message):
	_write_log(Level.WARN, system, message)

func error(system, message):
	_write_log(Level.ERROR, system, message)
