extends Node

func _ready():
	var args = Array(OS.get_cmdline_args())
	if args.has("-s"):
		get_tree().change_scene("res://server.tscn")
	else:
		get_tree().change_scene("res://pong.tscn")
