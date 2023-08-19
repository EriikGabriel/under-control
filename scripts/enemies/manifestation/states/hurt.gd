extends State

var manifestation: Manifestation

func Condition(): return manifestation.is_hurt

func Enter(): manifestation = get_parent().get_parent()
