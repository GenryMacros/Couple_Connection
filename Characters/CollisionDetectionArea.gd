extends Area3D

signal body_entered_signal()
signal body_exited_signal()

func _on_body_entered(body: Node3D):
	body_entered_signal.emit()



func _on_body_exited(body):
	if !has_overlapping_bodies():
		body_exited_signal.emit()
