extends State

var player: Player

func Condition(): return player.is_hurt

func Enter(): player = get_parent().get_parent()

