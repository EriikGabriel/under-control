extends State

var guardian: Guardian

func Condition(): return guardian.is_attacking

func Enter(): guardian = get_parent().get_parent()
