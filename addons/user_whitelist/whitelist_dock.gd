@tool
extends MarginContainer

class_name WhiteListDock

#region Vars
var _scripts = []
#endregion

#region UI Interaction
func _on_browse_button_pressed():
	$FileDialogSelect.visible = true

func _on_file_dialog_close_requested():
	$FileDialogSelect.visible = false

func _on_clear_button_pressed():
	_scripts.clear()
	%TextEdit2.text = var_to_str(_scripts)
	
	_toggle_generate()

func _on_file_dialog_files_selected(paths):
	if _scripts == []:
		_scripts = Array(paths)
	else:
		_scripts.append_array(Array(paths).filter(_filter_existing))
	
	%TextEdit2.text = var_to_str(_scripts)
	
	if _scripts == []: return
	
	_toggle_generate()

func _on_generate_button_pressed():
	if _scripts == [] or _scripts == null: return
	
	var config = ConfigFile.new()
	var path = get_scene_file_path().rsplit("/", false, 1)[0]
	
	config.set_value("setup", "scripts", _scripts)
	config.save(path + "/setup.cfg")

func _on_file_dialog_open_close_requested():
	$FileDialogOpen.visible = false

func _on_file_dialog_open_file_selected(path):
	var config = ConfigFile.new()
	
	config.load(path)
	
	_scripts = config.get_value("setup", "scripts")
	%TextEdit2.text = var_to_str(_scripts)
	
	_toggle_generate()

func _on_load_button_pressed():
	var config = ConfigFile.new()
	var path = get_scene_file_path().rsplit("/", false, 1)[0]
	
	config.load(path + "/setup.cfg")
	
	_scripts = config.get_value("setup", "scripts")
	%TextEdit2.text = var_to_str(_scripts)
	
	_toggle_generate()

func _on_text_edit_2_text_changed():
	if not %TextEdit2.text.begins_with("[") or not %TextEdit2.text.ends_with("]"): return
	_scripts = str_to_var(%TextEdit2.text)
	
	_toggle_generate()
#endregion

#region Other
func _filter_existing(value):
	return not _scripts.has(value)

func _toggle_generate():
	if _scripts != []:
		%GenerateButton.disabled = false
	else:
		%GenerateButton.disabled = true
#endregion
