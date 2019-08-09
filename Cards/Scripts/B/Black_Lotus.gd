extends Card

func _init():
	Name = "Black Lotus"
	CMC = "0"
	CardText = "{T}, Sacrifice Black Lotus: Add three mana of any one color."
	ImageName = "leb-233-black-lotus.png"
	
	Type = [MTG.Type.Artifact]
	
func on_activated(effect):
	var blEffect = ManaEffect.new(self, "black_lotus_effect")
	tap()
	sacrifice()
	blEffect.activate()
	
func black_lotus_effect():
	pass