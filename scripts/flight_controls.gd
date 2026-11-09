
extends Control

signal controls_changed(pitch: float, roll: float, throttle: float)

var pitch_value := 0.0
var roll_value := 0.0
var throttle_value := 0.0

func _ready():
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    create_button("▲", Vector2(115, -190), Vector2(80, 65), "pitch_up")
    create_button("▼", Vector2(115, -115), Vector2(80, 65), "pitch_down")
    create_button("◀", Vector2(25, -115), Vector2(80, 65), "roll_left")
    create_button("▶", Vector2(205, -115), Vector2(80, 65), "roll_right")
    create_button("+", Vector2(-105, -190), Vector2(75, 65), "throttle_up")
    create_button("-", Vector2(-105, -115), Vector2(75, 65), "throttle_down")


func create_button(label_text: String, offset: Vector2, button_size: Vector2, action: String):
    var button = Button.new()
    button.text = label_text
    button.size = button_size
    button.position = Vector2(20, 0) + offset

    button.anchor_left = 0.0
    button.anchor_right = 0.0
    button.anchor_top = 1.0
    button.anchor_bottom = 1.0

    if action.begins_with("throttle"):
        button.anchor_left = 1.0
        button.anchor_right = 1.0
        button.position.x = offset.x
    else:
        button.position.x = offset.x

    add_child(button)

    button.button_down.connect(func():
        change_action(action, true)
    )

    button.button_up.connect(func():
        change_action(action, false)
    )


func change_action(action: String, pressed: bool):
    match action:
        "pitch_up":
            pitch_value = -1.0 if pressed else 0.0
        "pitch_down":
            pitch_value = 1.0 if pressed else 0.0
        "roll_left":
            roll_value = 1.0 if pressed else 0.0
        "roll_right":
            roll_value = -1.0 if pressed else 0.0
        "throttle_up":
            throttle_value = 1.0 if pressed else 0.0
        "throttle_down":
            throttle_value = -1.0 if pressed else 0.0

    controls_changed.emit(pitch_value, roll_value, throttle_value)
