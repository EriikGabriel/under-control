extends State

var guardian: Guardian

func Condition(): return guardian.is_on_floor() && guardian.direction != 0

func Enter(): guardian = get_parent().get_parent()
