extends Object
class_name DebugGame

static func print_warning_and_break(message) -> void:
	push_warning(message)
	breakpoint

static func print_error_and_break(message) -> void:
	push_error(message)
	breakpoint
