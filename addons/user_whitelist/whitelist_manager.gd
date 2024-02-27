extends Node

var _whitelist = {}
var _scripts = []
var _callable 
var _callable_parameters

#region WhiteList global functions for usage
func is_valid(input: String, object: Variant):
	var callable_str = ""
	var split_message = input.rsplit(" ", false)
	var new_callable
	var collect_params = false
	var params = []
	var count = 0
	for part in split_message:
		if count == 0 and part.begins_with("_"):
			return
		count += 1
		if collect_params:
			params.append(part)
			continue 
		if callable_str != "":
			callable_str += "_"
		callable_str += part.to_lower()
		new_callable = Callable(object, callable_str)
		if new_callable.is_valid():
			collect_params = true
			continue
		elif count == split_message.size():
			callable_str = "NA"
	for script in _whitelist.keys():
		for function in _whitelist[script].keys():
			if function == callable_str:
				if params.size() >= _whitelist[script][function][0] and params.size() <= _whitelist[script][function][1]:
					_callable = new_callable
					_callable_parameters = params
					return true
	return false

func call_last_checked():
	if _callable == null: return
	_check_params_and_call(_callable_parameters, _callable)
	_callable = null
	_callable_parameters = null

func clear_last_checked():
	_callable = null
	_callable_parameters = null

func try_call(input: String, object: Variant):
	var callable_str = ""
	var split_message = input.rsplit(" ", false)
	var new_callable
	var collect_params = false
	var params = []
	var count = 0
	for part in split_message:
		if count == 0 and part.begins_with("_"):
			return
		count += 1
		if collect_params:
			params.append(part)
			continue 
		if callable_str != "":
			callable_str += "_"
		callable_str += part.to_lower()
		new_callable = Callable(object, callable_str)
		if new_callable.is_valid():
			collect_params = true
			continue
		elif count == split_message.size():
			callable_str = "NA"
	for script in _whitelist.keys():
		for function in _whitelist[script].keys():
			if function == callable_str:
				if params.size() >= _whitelist[script][function][0] and params.size() <= _whitelist[script][function][1]:
					_check_params_and_call(params, new_callable)
					return
#endregion

#region Prepare Whitelist
func _ready():
	var config = ConfigFile.new()
	var path = get_scene_file_path().rsplit("/", true, 1)[0]
	var err = config.load(path + "/setup.cfg")
	if err == OK:
		_scripts = config.get_value("setup", "scripts")
		_gather_functions()
#endregion

#region Function Collection
func _gather_functions():
	for script_path in _scripts:
		var script_access = FileAccess.open(script_path, FileAccess.READ)
		while script_access.get_position() < script_access.get_length():
			var code_line: String = script_access.get_line()
			if code_line.contains("func"):
				var function_name = code_line.split(" ")[1].split("(")[0]
				if  function_name.begins_with("_"): continue
				var min_params
				var max_params
				if code_line.contains("()"):
					max_params = 0
					min_params = 0
				else:
					max_params = code_line.split(" ", true, 1)[1].split(",").size()
					min_params = max_params - (code_line.split(" ", true, 1)[1].split("=").size() - 1)
				if _whitelist.has(script_path):
					_whitelist[script_path][function_name] = [min_params, max_params]
				else:
					_whitelist[script_path] = {function_name: [min_params, max_params]}
#endregion

#region Calling Function
func _check_params_and_call(params, new_callable):
	match params.size():
		0:
			new_callable.call()
		1:
			new_callable.call(params[0])
		2:
			new_callable.call(params[0], params[1])
		3:
			new_callable.call(params[0], params[1], params[2])
		4:
			new_callable.call(params[0], params[1], params[2], params[3])
		5:
			new_callable.call(params[0], params[1], params[2], params[3], params[4])
		6:
			new_callable.call(params[0], params[1], params[2], params[3], params[4], params[5])
		7:
			new_callable.call(params[0], params[1], params[2], params[3], params[4], params[5], params[6])
		8:
			new_callable.call(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7])
#endregion
