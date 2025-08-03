extends Control
@onready var debug_text_label: Label = $CanvasLayer/GlobalsDebugText/Label


var debug_text_dict = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug_text_label.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.debug_text:
		debug_text_label.text = ""
		for key in debug_text_dict.keys():
			debug_text_label.text += "\n"+str(key)+": "+str(debug_text_dict[key])
	
func set_debug_text(key: String, value: String):
	debug_text_dict[key] = value
