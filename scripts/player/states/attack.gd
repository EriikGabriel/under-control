extends State

var player: Player

func Condition(): return player.is_attacking

func Enter(): player = get_parent().get_parent()
