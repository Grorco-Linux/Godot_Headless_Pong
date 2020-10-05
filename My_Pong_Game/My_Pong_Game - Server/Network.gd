extends Node

# Make constant for your servers port number
const PORT = 8000

# Max number of players on the server
var max_players = 2

# We will need access to the game for adding clients later
onready var game = get_parent()

# We will use the client scene to create instances when players connect
var client = load('res://Client.tscn')
# We will use this dictionary to hold all our clients
var clients = {}

func _ready():
	# Create a new NetworkedMultiplayerENet and connect it's signals
	var network = NetworkedMultiplayerENet.new()
	network.connect("peer_connected", self, '_player_connected')
	network.connect("peer_disconnected", self, '_player_disconnected')
	# Create the server
	network.create_server(PORT, max_players)
	
	# Hand off the network to the tree
	get_tree().set_network_peer(network)

func _player_connected(id):
	print("Player with id {id} connected".format({'id':id}))
	
	# When a new player connects we will use a new instance to keep track of
	# them in our clients dictionary
	clients[id] = client.instance()
	# Use the unique network id to name the new node
	clients[id].name = str(id)
	# Now add the client node to the game
	game.add_child(clients[id])
	# Set their position on the board based on what order they joined
	if len(self.clients) == 1:
		rpc_id(id,'set_position', id, true)
	else:
		rpc_id(id,'set_position', id, false)

func _player_disconnected(id):
	print("Player with id {id} disconnected".format({'id':id}))
	
	# Remove the client node from the game
	game.remove_child(clients[id])
	# Remove the client node from the clients dictionary
	clients.erase(id)

# Reset the ball on client request
remote func reset_ball():
	var ball = game.get_node('Ball')
	ball.reset()
	ball.moving = true
