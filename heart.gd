extends Area2D

func _on_body_entered(body): # So when the Player (KinematicBody2D) collides with the heart it should disappear
	queue_free() # Queues action, hasn't actually free the node due to signal emission
	var hearts: Array[Node] = get_tree().get_nodes_in_group("Hearts") # Gets a list of nodes 
	#print(hearts.size()) # size is 1 when hearts are all collected becuase of queue_free
	if hearts.size() == 1:
		# print("Level Completed")
		Events.level_completed.emit() # Events is the Autoload script we created earlier, make it emit the leve_completed signal when all hearts collected
	
# Check how many hearts are remaining after a heart is destroyed
