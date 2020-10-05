extends KinematicBody2D

# The server will control the balls position using this puppet var
puppet var puppet_position = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	# The balls network master will always be the server
	# A networks server will always have an id of 1
	self.set_network_master(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Set the local balls position to where the network tells us it is.
	self.position = puppet_position
