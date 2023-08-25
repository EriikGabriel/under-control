extends State

var guardian: Guardian

func Condition(): return guardian.is_death

func Enter(): guardian = get_parent().get_parent()
