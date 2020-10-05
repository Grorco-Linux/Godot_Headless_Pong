# Godot_Headless_Pong

I created this "Game" just to demonstrate how some of Godot's NetworkedMultiplayerENet can be used to create a headless server that allows multiple clients to interact through it.

Before anyone asks, I know I don't need to use self.foo, I just personally prefer it. I am not a professional programmer, I am a hobbiest at best, who's also completely new to gdscript. So if something should be named or done differently, I appologize.  I also didn't even add scoring to this, because it wasn't needed to show the few things I wanted to show about the network part.

When trying to follow through the documentation, I found myself quite confused about a few parts, and hopefully this will help clear some of that up for others who might be stuck.

The first caveat to understand is that any RPC calls have to be to/from a node with an identical name/placement in the sceene structure. For example for your client to send a RPC call from a node at Game/Network, then the server has to recieve that call from a node at Game/Network.

The second caveat is if running two godot sessions at the same time, for instance to try running a server and client at the same time without compiling, you need to change the listening port found under Editor>Editor Settings>Network>Debug>Remote Port to a different port, or you will get an error "Error listening on port XXXX" and no debugging output. I've just been changing the port by 1 number 6006 to 6007.

To run the server code headlessly, download the godot headless version. The run the complied code using that. For example $./Godot_v3.2.3-stable_linux_headless.64 My_Pong_Game-Server.x86_64 


The last issue I had trouble with has to do with using rset, and an error I was getting. I explained more in depth in My_Pong_Game - Client> Client.gd lines 19-28.
