extends Node

# Make constant for your servers port number, and address
const PORT = 8000
const SERVER_ADDRESS = '127.0.0.1' # loopback for local machine


# We will need access to the game for adding clients later
onready var game = get_parent()
# We will use the client scene to create instances when players connect
var client = load('res://Client.tscn')
# We will use this dictionary to hold all our clients
var clients = {}

func _ready():
	# Create a new instance of a networked multiplayer Enet
	var network = NetworkedMultiplayerENet.new()
	# Connect it's signals
	network.connect("peer_connected", self,  '_player_connected')
	network.connect("peer_disconnected", self, '_player_disconnected')
	
	# Create the client connection
	network.create_client(SERVER_ADDRESS, PORT)
	
	# Hand off the network to the tree
	get_tree().set_network_peer(network)

func _player_connected(id):
	
	# The server id will always be 1
	# So check if the connection is with the server or another client
	if id != 1:
		print("Player with id {id} connected".format({'id':id}))
	

	else:
		# If we connected to the server, it's actually us who needs to be added.
		id = get_tree().get_network_unique_id()
		print("Connected as {id}".format({'id':id}))

	# When a new player connects we will use a new instance to keep track of
	# them in our clients dictionary
	clients[id] = client.instance()
	# Use the unique network id to name the new node
	clients[id].name = str(id)
	# Now add the client node to the game
	game.add_child(clients[id])

func _player_disconnected(id):
	print("Player with id {id} disconnected".format({'id':id}))
	
	# Remove the client node from the game
	game.remove_child(clients[id])
	# Remove the client node from the clients dictionary
	clients.erase(id)

# Ask server to reset the ball
func reset_ball():
	rpc('reset_ball')

remote func set_position(id, left=true):
	# Get starting position for each client node from the server
	var player = game.get_node(str(id))
	
	# Set the nodes position on the screen
	if left:
		player.position.x = 40
		player.position.y = 300
	else:
		player.position.x = 1024 - 40
		player.position.y = 300
