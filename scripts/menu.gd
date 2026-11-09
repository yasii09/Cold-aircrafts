
extends Control

signal menu_selected(option: String)

func _ready():
    create_menu()


func create_menu():
    var background = ColorRect.new()
    background.color = Color(0.025, 0.045, 0.08)
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var title = Label.new()
    title.text = "YASI GPT"
    title.position = Vector2(0, 65)
    title.size = Vector2(1280, 65)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 48)
    title.add_theme_color_override("font_color", Color.CYAN)
    add_child(title)

    var subtitle = Label.new()
    subtitle.text = "FLIGHT OPS"
    subtitle.position = Vector2(0, 130)
    subtitle.size = Vector2(1280, 40)
    subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    subtitle.add_theme_font_size_override("font_size", 25)
    subtitle.add_theme_color_override("font_color", Color.WHITE)
    add_child(subtitle)

    create_button("STAGES", 230, "stages")
    create_button("FREE FLIGHT", 310, "free_flight")
    create_button("HANGAR", 390, "hangar")
    create_button("SETTINGS", 470, "settings")


func create_button(button_text: String, y: float, option: String):
    var button = Button.new()
    button.text = button_text
    button.position = Vector2(440, y)
    button.size = Vector2(400, 60)
    button.add_theme_font_size_override("font_size", 23)
    add_child(button)

    button.pressed.connect(func():
        menu_selected.emit(option)
    )
