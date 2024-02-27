extends Node2D

#The default setup config file is pointed at example.gd
#Functions are picked up from the script as follows for the first three functions here
func test():
	print("Test worked")

func test_two(one_arg):
	prints("Test two worked:", one_arg)

func test_three(one_and = "test", two_args = "test"):
	prints("Test three worked:", one_and, two_args)

#This function won't be added to the whitelist as it is virtual or private "_" in front of func name
func _test_four():
	print("This should not be called as it has _ in the function name")

#Try call alt_test as well to see the second script work

var text

func _on_user_input_text_received(new_text):
	if new_text != text:
		if WhiteList.is_valid(new_text, self): #Stores the checked callable / object if is valid
			WhiteList.call_last_checked() #Calls and clears stored callable / object
			#If we didn't want to call last checked we can clear
			#WhiteList.clear_last_checked()
		elif WhiteList.is_valid(new_text, $SecondScript):
			WhiteList.call_last_checked()
	#Alternatively
	#if new_text != text:
		#WhiteList.try_call(new_text, self)
	#
	#text = new_text
	
#Supports up to 8 optional params at present, see whitelist_manager.gd _check_params_and_call() to adjust
