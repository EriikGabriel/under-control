extends State

var butcher: Butcher

func Enter(): butcher = get_parent().get_parent()

func Condition(): return butcher.is_hurt
