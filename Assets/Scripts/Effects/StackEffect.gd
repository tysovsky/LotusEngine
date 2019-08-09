extends Effect

class_name StackEffect

var _effect_text : String

func _init(card : Card, effect_text : String, effect_func : String).(card, effect_func):
	_effect_text = effect_text
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
func activate():
	_card.call(_effect_func)
	pass