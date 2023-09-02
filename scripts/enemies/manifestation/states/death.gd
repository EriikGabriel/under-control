extends State

var manifestation: Manifestation

func Condition(): return manifestation.is_death

func Enter(): manifestation = get_parent().get_parent()
