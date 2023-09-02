extends State

var player: Player

func Condition(): return player.is_on_floor() && player.direction != 0

func Enter(): player = get_parent().get_parent()

