
extends Node3D

const FlightPlane = preload("res://scripts/flight.gd")
const TrafficPlane = preload("res://scripts/traffic_plane.gd")
const Radar = preload("res://scripts/radar.gd")
const FlightControls = preload("res://scripts/flight_controls.gd")
const EnvironmentScene = preload("res://scenes/environment.gd")
const AirportScene = preload("res://scenes/airport.gd")
const MainMenu = preload("res://scripts/menu.gd")
const HangarScene = preload("res://scenes/hangar.gd")

var camera_yaw := 0.0
var camera_pitch := -0.18
var touch_sensitivity := 0.004
var dragging := false
var last_touch := Vector2.ZERO

var camera_pivot: Node3D
var player: Node3D
var traffic_planes: Array[Node3D] = []

var radar: Control
var warning_label: Label
var flight_ui: CanvasLayer
var current_page: Node


func _ready():
    create_environment()
    create_ground()
    create_airport()
    create_player()
    create_traffic()
    create_ui()
    create_main_menu()


func _input(event):
    if current_page != null:
        return

    if event is InputEventScreenTouch:
        dragging = event.pressed
        last_touch = event.position

    elif event is InputEventScreenDrag and dragging:
        var movement = event.position - last_touch
        camera_yaw -= movement.x * touch_sensitivity
        camera_pitch -= movement.y * touch_sensitivity
        camera_pitch = clamp(camera_pitch, -0.8, 0.25)
        last_touch = event.position


func create_environment():
    var world = WorldEnvironment.new()
    var env = Environment.new()
    env.background_mode = Environment.BG_SKY

    var sky = Sky.new()
    sky.sky_material = ProceduralSkyMaterial.new()
    env.sky = sky
    world.environment = env
    add_child(world)

    var sun = DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-45, -30, 0)
    add_child(sun)

    var environment_scene = EnvironmentScene.new()
    add_child(environment_scene)


func create_ground():
    var ground = MeshInstance3D.new()
    var mesh = PlaneMesh.new()
    mesh.size = Vector2(500, 500)
    ground.mesh = mesh
    ground.position.y = -30

    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color(0.2, 0.4, 0.2)
    ground.material_override = mat
    add_child(ground)


func create_airport():
    var airport = AirportScene.new()
    add_child(airport)


func create_player():
    player = Node3D.new()
    player.set_script(FlightPlane)
    add_child(player)

    camera_pivot = Node3D.new()
    player.add_child(camera_pivot)

    var camera = Camera3D.new()
    camera.position = Vector3(0, 3, 9)
    camera.fov = 75
    camera.current = true
    camera_pivot.add_child(camera)


func create_traffic():
    randomize()

    for i in range(18):
        var plane = Node3D.new()
        plane.set_script(TrafficPlane)
        plane.position = Vector3(
            randf_range(-80, 80),
            randf_range(-15, 25),
            randf_range(-100, 100)
        )
        add_child(plane)
        traffic_planes.append(plane)


func create_ui():
    flight_ui = CanvasLayer.new()
    flight_ui.name = "FlightUI"
    add_child(flight_ui)

    radar = Radar.new()
    radar.anchor_left = 1.0
    radar.anchor_right = 1.0
    radar.offset_left = -190
    radar.offset_right = -10
    radar.offset_top = 10
    radar.offset_bottom = 190
    flight_ui.add_child(radar)

    warning_label = Label.new()
    warning_label.text = "NEARBY TRAFFIC"
    warning_label.position = Vector2(20, 20)
    warning_label.add_theme_color_override(
        "font_color", Color.YELLOW
    )
    warning_label.visible = false
    flight_ui.add_child(warning_label)

    var controls = FlightControls.new()
    flight_ui.add_child(controls)
    controls.controls_changed.connect(player.set_controls)

    flight_ui.visible = false


func create_main_menu():
    if is_instance_valid(current_page):
        current_page.queue_free()

    var menu = MainMenu.new()
    menu.name = "MainMenu"
    add_child(menu)
    menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

    menu.menu_selected.connect(on_menu_selected)
    current_page = menu
    flight_ui.visible = false


func on_menu_selected(option: String):
    if is_instance_valid(current_page):
        current_page.queue_free()

    current_page = null

    match option:
        "free_flight":
            flight_ui.visible = true

        "hangar":
            open_hangar()

        "stages":
            show_message("MISSIONS - COMING SOON")

        "settings":
            show_message("SETTINGS - COMING SOON")


func open_hangar():
    flight_ui.visible = false

    var hangar = HangarScene.new()
    hangar.name = "Hangar"
    add_child(hangar)
    current_page = hangar

    var back = Button.new()
    back.text = "BACK TO MENU"
    back.position = Vector2(20, 180)
    back.size = Vector2(220, 60)

    var layer = CanvasLayer.new()
    hangar.add_child(layer)
    layer.add_child(back)

    back.pressed.connect(create_main_menu)


func show_message(message: String):
    var page = Control.new()
    page.name = "MessagePage"
    page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(page)
    current_page = page

    var background = ColorRect.new()
    background.color = Color(0.025, 0.045, 0.08)
    background.set_anchors_and_offsets_preset(
        Control.PRESET_FULL_RECT
    )
    page.add_child(background)

    var title = Label.new()
    title.text = message
    title.position = Vector2(0, 180)
    title.size = Vector2(1280, 80)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 32)
    page.add_child(title)

    var back = Button.new()
    back.text = "BACK"
    back.position = Vector2(500, 320)
    back.size = Vector2(280, 65)
    page.add_child(back)

    back.pressed.connect(create_main_menu)


func _process(delta):
    if current_page != null:
        return

    if camera_pivot:
        var target = Vector3(camera_pitch, camera_yaw, 0)
        camera_pivot.rotation = camera_pivot.rotation.lerp(
            target, delta * 5.0
        )

    update_radar()


func update_radar():
    if not player or not radar:
        return

    var points: Array[Vector2] = []
    var nearby := false

    for plane in traffic_planes:
        if not is_instance_valid(plane):
            continue

        var local_position = player.to_local(
            plane.global_position
        )

        var radar_point = Vector2(
            local_position.x / 100.0,
            local_position.z / 100.0
        )

        points.append(Vector2(
            clamp(radar_point.x, -1.0, 1.0),
            clamp(radar_point.y, -1.0, 1.0)
        ))

        if plane.global_position.distance_to(
            player.global_position
        ) < 35.0:
            nearby = true

    radar.set_blips(points)
    warning_label.visible = nearby
