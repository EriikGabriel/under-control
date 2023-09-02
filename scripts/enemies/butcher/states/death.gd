extends State

var butcher: Butcher

func Condition(): 
	return butcher.is_death

func Enter(): butcher = get_parent().get_parent()
