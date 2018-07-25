extends Node2D

const DEFAULT_PORT = 8910 # some random number, pick your port properly
onready var player = load("res://paddle.tscn")
var players = []

func _player_connected(id):
	print("Connection! " + str(id))
	# If we are the server, let everyone know about the new player
	for p_id in players: # Then, for each remote player
		rpc_id(id, "register_player", p_id) # Send player to new dude
		rpc_id(p_id, "register_player", id) # Send new dude to player
	# register_player(id)

func _player_disconnected(id):
	print("Disconnect! " + str(id))
	unregister_player(id)
	for p_id in players:
		rpc_id(p_id, "unregister_player", id)

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

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")

	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = host.create_server(DEFAULT_PORT, 2)
	if err == OK:
		get_tree().set_network_peer(host)
