# Whitelist-Tool
 Whitelist Tool for validating and calling user input

 Provides an in-editor plugin to allow selection of specific scripts to be read and then creates a whitelist (Autoload WhiteList) from those scripts on project run.

Use "WhiteList.is_valid(input_string, object_ref)" to check if the input string is a valid function / param combo for object_ref

"WhiteList.call_last_checked()" to call that function

"WhiteList.clear_last_checked()" to clear if it was a valid function that should not be called

"WhiteList.try_call(input_string, object_Ref)" to try call a function directly
