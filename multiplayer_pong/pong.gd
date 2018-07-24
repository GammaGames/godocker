extends Node2D

const DEFAULT_PORT = 8910 # some random number, pick your port properly
onready var player = load("res://paddle.tscn")
var players = []

func _connected_ok():
	var id = get_tree().get_network_unique_id()
	var new_player = player.instance()
	new_player.set_name(str(id))
	new_player.set_network_master(id)
	$Players.add_child(new_player)

	# Registration of a client beings here, tell everyone that we are here
	rpc("register_player", get_tree().get_network_unique_id())

remote func register_player(id):
	players.append(id)
	var new_player = player.instance()
	new_player.set_name(str(id))
	new_player.set_network_master(id)
	$Players.add_child(new_player)

remote func unregister_player(id):
	var index = players.find(id)
	if index > -1:
		players.remove(index)
	$Players.get_node(str(id)).queue_free()

func join():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	var ip = $Lobby/Window/Ip.text

	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)
	$Lobby.hide()

func _ready():
	# connect all the callbacks related to networking
	$Lobby/Window/Join.connect("pressed", self, "join")
