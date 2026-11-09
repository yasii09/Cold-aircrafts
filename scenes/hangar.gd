
extends Node3D

var aircraft_names = [
    "F-5",
    "F-14",
    "F-4",
    "F-16",
    "SU-57",
    "SU-30"
]

var selected_index := 0
var aircraft_label: Label


func _ready():
    create_hangar()
    create_selection_ui()
    show_selected_aircraft()


func create_hangar():
    var floor = MeshInstance3D.new()
    var mesh = PlaneMesh.new()
    mesh.size = Vector2(45, 45)
    floor.mesh = mesh
    floor.position.y = -2

    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.16, 0.18, 0.22)
    floor.material_override = material
    add_child(floor)


func create_selection_ui():
    var layer = CanvasLayer.new()
    add_child(layer)

    aircraft_label = Label.new()
    aircraft_label.position = Vector2(30, 30)
    aircraft_label.add_theme_font_size_override("font_size", 28)
    layer.add_child(aircraft_label)

    var previous = Button.new()
    previous.text = "PREVIOUS"
    previous.position = Vector2(30, 100)
    previous.size = Vector2(150, 55)
    layer.add_child(previous)
    previous.pressed.connect(previous_aircraft)

    var next = Button.new()
    next.text = "NEXT"
    next.position = Vector2(200, 100)
    next.size = Vector2(150, 55)
    layer.add_child(next)
    next.pressed.connect(next_aircraft)


func show_selected_aircraft():
    aircraft_label.text = "SELECT AIRCRAFT: " + aircraft_names[selected_index]


func previous_aircraft():
    selected_index = (selected_index - 1 + aircraft_names.size()) % aircraft_names.size()
    show_selected_aircraft()


func next_aircraft():
    selected_index = (selected_index + 1) % aircraft_names.size()
    show_selected_aircraft()
