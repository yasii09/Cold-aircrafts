
extends Control

signal mission_selected(mission: int, difficulty: String)
signal back_requested

var selected_mission := 1
var selected_difficulty := "EASY"
var mission_buttons: Array[Button] = []


func _ready():
    create_page()


func create_page():
    var background = ColorRect.new()
    background.color = Color(0.025, 0.045, 0.08)
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var title = Label.new()
    title.text = "MISSION SELECT"
    title.position = Vector2(0, 25)
    title.size = Vector2(1280, 60)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 34)
    title.add_theme_color_override("font_color", Color.CYAN)
    add_child(title)

    create_mission_grid()
    create_difficulty_buttons()
    create_back_button()


func create_mission_grid():
    for i in range(25):
        var button = Button.new()
        button.text = "MISSION " + str(i + 1)
        button.size = Vector2(180, 65)

        var column = i % 5
        var row = int(i / 5)

        button.position = Vector2(
            170 + column * 190,
            120 + row * 80
        )

        add_child(button)
        mission_buttons.append(button)

        var mission_number = i + 1
        button.pressed.connect(func():
            selected_mission = mission_number
            update_selection()
        )

    update_selection()


func create_difficulty_buttons():
    var difficulties = ["EASY", "NORMAL", "HARD"]

    for i in range(3):
        var button = Button.new()
        button.text = difficulties[i]
        button.position = Vector2(330 + i * 210, 550)
        button.size = Vector2(180, 60)
        add_child(button)

        var difficulty = difficulties[i]
        button.pressed.connect(func():
            selected_difficulty = difficulty
            update_selection()
        )


func update_selection():
    for i in range(mission_buttons.size()):
        mission_buttons[i].modulate = (
            Color.CYAN if i + 1 == selected_mission
            else Color.WHITE
        )


func create_back_button():
    var button = Button.new()
    button.text = "BACK"
    button.position = Vector2(30, 30)
    button.size = Vector2(130, 55)
    add_child(button)
    button.pressed.connect(func():
        back_requested.emit()
    )
