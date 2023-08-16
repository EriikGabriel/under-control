extends State

var player: Player

func Condition(): return !player.is_on_floor()

func Enter(): player = get_parent().get_parent()


