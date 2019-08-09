extends Effect

class_name ManaEffect

func _init(card : Card, effect_func : String).(card, effect_func):
	pass
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate():
	_card.call(_effect_func)
	pass