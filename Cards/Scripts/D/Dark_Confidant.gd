extends Card

func _init():
	Name = "Dark Confidant"
	CMC = "B1"
	Type = [MTG.Type.Creature]
	SubType = [MTG.SubType.Human, MTG.SubType.Wizard]
	ImageName = "mma-75-dark-confidant.jpg"
	CardText = 	"At the beginning of your upkeep, reveal the top card of your library and put that card into your hand. You lose life equal to its converted mana cost."
	
func dark_confidant_effect():
	var top_card = Controller.Deck.get_top_card()
	top_card.reveal()
	Controller.LifeTotal -= top_card.NumericCMC
	Controller.Hand.put(top_card)

func on_controller_upkeep():

	StackEffect.new(self,
		"At the beginning of your upkeep, reveal the top card of your library and put that card into your hand. You lose life equal to its converted mana cost.",
		"dark_confidant_effect").activate()
		
	.on_controller_upkeep()