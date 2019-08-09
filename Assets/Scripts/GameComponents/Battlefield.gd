extends Spatial

class_name Battlefield

export var DISTANCE_BETWEEN_CARDS = 0.5

var RowOne : Spatial
var RowTwo : Spatial

func _ready():
	RowOne = get_node("RowOne")
	RowTwo = get_node("RowTwo")
	
	subscribe_to_signals()

func subscribe_to_signals():
	for player in get_tree().root.get_node("Game/Players").get_children():
		player.connect("card_resolved", self, "_card_resolved")
		
func _card_resolved(card : Card):
	var row : Spatial
	
	if(MTG.Type.Creature in card.Type
		|| MTG.Type.Artifact in card.Type):
		
		row = RowOne
	else:
		row = RowTwo
		
	var c = row.get_child_count() - 1
		
	var newOrigin : Vector3
	
	if c == 0:
		newOrigin = row.global_transform.origin
	elif c % 2 == 1:
		if(c == 1):
			newOrigin = row.get_child(c - 1).global_transform.origin + Vector3(card._meshSize.x + DISTANCE_BETWEEN_CARDS,0,0)
		else:
			newOrigin = row.get_child(c - 2).global_transform.origin + Vector3(card._meshSize.x + DISTANCE_BETWEEN_CARDS,0,0)
	else:
		newOrigin = row.get_child(c - 2).global_transform.origin - Vector3(card._meshSize.x + DISTANCE_BETWEEN_CARDS,0,0)

	card._targetPosition = newOrigin