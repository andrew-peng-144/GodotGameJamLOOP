extends Control
@onready var debug_text_label: Label = $CanvasLayer/GlobalsDebugText/Label
@onready var color_rect: ColorRect = $CanvasLayer/ScreenTransitionAnimation/ColorRect
@onready var animation_player: AnimationPlayer = $CanvasLayer/ScreenTransitionAnimation/AnimationPlayer


var debug_text_dict = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug_text_label.text = ""
	color_rect.visible = true # so it's invisible only in editor.
	
	DisplayServer.window_set_title("Clover, Again") # title for windiw

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.debug_text:
		debug_text_label.text = ""
		for key in debug_text_dict.keys():
			debug_text_label.text += "\n"+str(key)+": "+str(debug_text_dict[key])
	
func set_debug_text(key: String, value: String):
	debug_text_dict[key] = value

func play_fade_in():
	animation_player.play("fade_in")

func play_fade_out():
	animation_player.play("fade_out")
