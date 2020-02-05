extends CutsceneTrigger

enum Trigger {FIRST, SECOND, THIRD}
export (Trigger) var Trigger_version = Trigger.THIRD

#Create pattern list
func set_pattern()->void:
	add_call_method(triggering_object, "set", ["can_move", false])
	add_wait(0.2)
	add_call_method(triggering_object, "set", ["position", Vector2(1280/2, 720/2)])
	add_wait(0.2)
	add_call_method(triggering_object, "set", ["modulate", Color(randf(), randf(), randf(), 1.0)])
	add_wait(0.2)
	add_call_method(triggering_object, "set", ["scale", Vector2(2,3)])
	add_wait(0.2)
	add_multi_call_method([				#Array
		single_method(triggering_object, "set", ["position", Vector2(1280 * 0.75, 720 * 0.25)]),
		single_method(triggering_object, "set", ["modulate", Color(randf(), randf(), randf(), 1.0)]),
		single_method(triggering_object, "set", ["scale", Vector2(2,3)])
	])
	add_wait(0.2)
	add_interpolate_value(triggering_object, "modulate", Color.white, Color.blue, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	add_wait(0.2)
	add_multi_interpolate_value([		#Array
		single_interpolate_value(triggering_object, "modulate", Color.white, Color.blue, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0),
		single_interpolate_value(triggering_object, "position", triggering_object.position, Vector2(800,600), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
	])
	add_wait(0.2)
	add_move(true, true, triggering_object, Vector2(-200, -100), 1, 0)
	add_call_method(triggering_object, "set", ["scale", Vector2(1,1)])
	add_call_method(triggering_object, "set", ["modulate", Color(1, 1, 1, 1)])
	add_wait(0.2)
	add_call_method(triggering_object, "set", ["can_move", true])
	



