extends Node

func _ready():
	var args = OS.get_cmdline_args()
	if args.size() > 0 && args[0] == "-s":
		get_tree().change_scene("res://server.tscn")
	else:
		get_tree().change_scene("res://pong.tscn")

	pass
