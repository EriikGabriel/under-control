extends State

var guardian: Guardian

func Condition(): return guardian.is_hurt

func Enter(): guardian = get_parent().get_parent()
