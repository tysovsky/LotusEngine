extends Spatial

class_name Deck

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func to_string():
	var cards = ""
	for card in get_children():
		cards += card.get_script().get_path() + '|'
		
	return cards

func from_string(cards : String):
	var scripts = cards.rsplit('|', false)
	for script_name in scripts:
		var card = load("res://Assets/Scenes/Card.tscn").instance()
		card.set_script(load(script_name))
		card.Zone = MTG.Zone.Deck
		add_child(card)
		card.hide()