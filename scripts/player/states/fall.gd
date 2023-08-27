extends State

var player: Player

func Condition(): return !player.is_on_floor() && !player.is_jump && !player.is_death

func Enter(): player = get_parent().get_parent()

