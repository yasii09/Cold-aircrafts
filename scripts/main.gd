
extends Node3D

const FlightPlane = preload("res://scripts/flight.gd")
const TrafficPlane = preload("res://scripts/traffic_plane.gd")

var camera_yaw := 0.0
var camera_pitch := -0.18
var touch_sensitivity := 0.004
var dragging := false
var last_touch := Vector2.ZERO
var camera_pivot: Node3D

func _ready():
    create_environment()
    create_ground()
    create_player()
    create_traffic()

func _input(event):
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

func create_player():
    var player = Node3D.new()
    player.set_script(FlightPlane)
    add_child(player)

    camera_pivot = Node3D.new()
    player.add_child(camera_pivot)

    var camera = Camera3D.new()
    camera.position = Vector3(0, 3, 9)
    camera.fov = 75
    camera.current = true
    camera_pivot.add_child(camera)

func _process(delta):
    if camera_pivot:
        var target = Vector3(camera_pitch, camera_yaw, 0)
        camera_pivot.rotation = camera_pivot.rotation.lerp(target, delta * 5.0)

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
