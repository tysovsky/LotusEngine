extends Node

class_name NetworkManager

signal opponent_connected

const DEFAULT_PORT = 31416
const MAX_PEERS    = 2
var   players      = {}
var   player_name = "Opponent"

var _host : NetworkedMultiplayerENet
var _me
var _opponent

func _ready():
	_me = get_tree().root.get_node("Game/Players/Player")
	_me.Username = "Test"
	_opponent = get_tree().root.get_node("Game/Players/Opponent")
	get_tree().connect("network_peer_connected", self, "on_opponent_connected")
	get_tree().connect("network_peer_disconnected", self, "on_opponent_disconnected")
	
	get_tree().connect("connected_to_server", self, "on_connection_success")
	get_tree().connect("connection_failed", self, "on_connection_failure")
	get_tree().connect("server_disconnected", self, "on_server_disconnected")

	_host = NetworkedMultiplayerENet.new()

func start_server(port = DEFAULT_PORT, max_peers = MAX_PEERS):
	var err = _host.create_server(port, max_peers)
	
	if err != OK:
		join_server("127.0.0.1", port)
		return
		
	_me.Id = 1
	get_tree().network_peer = _host
	
	
func join_server(address : String = "127.0.0.1", port = DEFAULT_PORT):
	_host.create_client(address, port)
	get_tree().network_peer = _host


func on_opponent_connected(id):
	if(id == 1):
		return
	print("Player connected " + str(id))
	rpc_id(id, "initialize_opponent", _me.Id, _me.Username, _me.Deck.to_string())
	
func on_opponent_disconnected(id):
	unregister_player(id)
	rpc("unregister_player", id)
	
#Opponent  connected - notify the Player
func on_connection_success():
	_me.Id = get_tree().get_network_unique_id()
	rpc_id(1, "initialize_opponent", _me.Id, _me.Username, _me.Deck.to_string())
	
func on_connection_failure():
	pass
	
func on_server_disconnected():
	pass

remote func initialize_opponent(id, username, deck_str):
	_opponent.Id = id
	_opponent.Username = username
	_opponent.Deck.from_string(deck_str)
	emit_signal("opponent_connected")
	
	
remote func register_in_game():
	pass
	
remote func register_new_player(id, username):
	pass

remote func register_player(id, username):
	if get_tree().is_network_server():
		rpc_id(id, "register_player", 1, player_name)

remote func unregister_player(id):
	players.erase(id)

func spawn_player(id):
	pass