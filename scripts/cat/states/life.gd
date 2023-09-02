extends State


var cat: Cat

func Condition(): return cat.is_healing

func Enter(): cat = get_parent().get_parent()
