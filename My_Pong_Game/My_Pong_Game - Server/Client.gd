extends KinematicBody2D

# Set server will only track these, so we will use a puppet variable to get
# the position from the master nodes on the clients
puppet var puppet_position = Vector2()

func _ready():
	# Set the network master for this node to the network id of the node
	self.set_network_master(int(self.name))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	
	# Since this is a server, all movements will be made by the clients master
	self.position = self.puppet_position


