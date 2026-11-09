
extends Node3D

const FlightPlane = preload("res://scripts/flight.gd")
const TrafficPlane = preload("res://scripts/traffic_plane.gd")
const Radar = preload("res://scripts/radar.gd")
const FlightControls = preload("res://scripts/flight_controls.gd")
const EnvironmentScene = preload("res://scenes/environment.gd")
const AirportScene = preload("res://scenes/airport.gd")
const MainMenu = preload("res://scripts/menu.gd")
const HangarScene = preload("res://scenes/hangar.gd")
const StagesScene = preload("res://scripts/stages.gd")

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

var mission_marker: Node3D
var mission_number := 1
var mission_active := false


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

    mission_active = false

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
            open_stages()

        "settings":
            show_message("SETTINGS - COMING SOON")


func open_stages():
    flight_ui.visible = false

    var stages = StagesScene.new()
    stages.name = "Stages"
    stages.set_anchors_and_offsets_preset(
        Control.PRESET_FULL_RECT
    )

    var layer = CanvasLayer.new()
    layer.name = "StagesLayer"
    add_child(layer)
    layer.add_child(stages)

    current_page = layer

    stages.mission_selected.connect(on_mission_selected)
    stages.back_requested.connect(create_main_menu)


func on_mission_selected(mission: int, difficulty: String):
    if is_instance_valid(current_page):
        current_page.queue_free()

    current_page = null
    mission_number = mission

    flight_ui.visible = true
    start_mission(difficulty)


func start_mission(difficulty: String):
    if is_instance_valid(mission_marker):
        mission_marker.queue_free()

    var distance := 220.0

    match difficulty:
        "NORMAL":
            distance = 320.0
        "HARD":
            distance = 450.0

    mission_marker = Node3D.new()
    mission_marker.position = player.global_position + Vector3(0, 0, -distance)
    add_child(mission_marker)

    var ring = MeshInstance3D.new()
    var ring_mesh = TorusMesh.new()
    ring_mesh.inner_radius = 5.0
    ring_mesh.outer_radius = 6.0
    ring.mesh = ring_mesh

    var material = StandardMaterial3D.new()
    material.albedo_color = Color.CYAN
    material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
    ring.material_override = material

    ring.rotation_degrees.x = 90
    mission_marker.add_child(ring)

    var label = Label3D.new()
    label.text = "WAYPOINT"
    label.position = Vector3(0, 9, 0)
    label.font_size = 48
    mission_marker.add_child(label)

    mission_active = true
    print("MISSION ", mission_number, " STARTED - ", difficulty)


func mission_completed():
    if not mission_active:
        return

    mission_active = false

    if is_instance_valid(mission_marker):
        mission_marker.queue_free()

    mission_marker = null
    flight_ui.visible = false

    show_message(
        "MISSION " + str(mission_number) + " COMPLETED!"
    )


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
    if is_instance_valid(current_page):
        current_page.queue_free()

    var layer = CanvasLayer.new()
    layer.name = "MessageLayer"
    add_child(layer)
    current_page = layer

    var page = Control.new()
    page.set_anchors_and_offsets_preset(
        Control.PRESET_FULL_RECT
    )
    layer.add_child(page)

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
    back.text = "BACK TO MENU"
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

    if mission_active and is_instance_valid(mission_marker):
        if player.global_position.distance_to(
            mission_marker.global_position
        ) < 10.0:
            mission_completed()

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
