extends KinematicBody2D

# Set the movement speed and paddle size
export var speed = 500
var paddle_size = 50

# Assign the network to a variable, so we can make RPC calls using it
onready var network = get_parent().get_node('Network')

# By default we will be player 1, the network will tell
# us if we should be 2 instead.
var player = 1

# The puppet variable will allow the master node to control it's puppets on
# other clients
puppet var puppet_position = Vector2()

func _ready():
	#IMPORTANT: if you are getting an error like,
	#_process_rset: RSET 'puppet_position' is not allowed on node
	# /root/Game/1127929689 from: 1127929689. Mode is 3, master is 1.
	# It's because you skipped the following, and by default the master is set
	# to the server (id 1) using mode 3 (RPC_MODE_PUPPET)
	# if you want something other than puppet use
	# rset_config('var_name', enum or MultiplayerAPI.Desired_Mode)
	
	# Set the network master for this node to the network id of the node
	self.set_network_master(int(self.name))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	movement(delta)
	
	# Have the network request the server reset the ball
	if Input.is_action_just_pressed("ui_accept"):
		network.reset_ball()


func movement(delta):
	# Move up and down
	var move = Vector2()
	if Input.is_action_pressed("ui_up") and self.position.y >= 0 + paddle_size:
		move.y -= 1
	if Input.is_action_pressed("ui_down") and self.position.y <= 600 - paddle_size:
		move.y += 1
	move.normalized()
	
	# I don't need the return vector, so I dumped it in null
	var _null = self.move_and_slide(move*speed)
	
	# If they are the node's master, use their movement on the puppet modes
	if self.is_network_master():
		rset('puppet_position', self.position)
	
	# Else get the movement from the master
	else:
		self.position = self.puppet_position


