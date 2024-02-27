@tool
extends EditorPlugin

class_name UserWhiteListPlugin

var control
const AUTOLOAD_NAME = "WhiteList"

func _enter_tree():
	control = preload("res://addons/user_whitelist/whitelist_dock.tscn").instantiate()
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/user_whitelist/white_list.tscn")
	add_control_to_bottom_panel(control, "WhiteList Prep")

func _exit_tree():
	remove_control_from_bottom_panel(control)
	remove_control_from_bottom_panel(control)
	control.free()
	remove_autoload_singleton(AUTOLOAD_NAME)
