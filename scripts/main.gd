
extends Node3D

const FlightPlane = preload("res://scripts/flight.gd")
const TrafficPlane = preload("res://scripts/traffic_plane.gd")

func _ready():
    create_environment()
    create_ground()
    create_player()
    create_traffic()

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
    player.position = Vector3(0, 0, 0)
    add_child(player)

    var camera = Camera3D.new()
    camera.position = Vector3(0, 3, 9)
    camera.rotation_degrees = Vector3(-12, 0, 0)
    player.add_child(camera)
    camera.current = true

func create_traffic():
    for i in range(18):
        var plane = Node3D.new()
        plane.set_script(TrafficPlane)
        plane.position = Vector3(
            randf_range(-80, 80),
            randf_range(-15, 25),
            randf_range(-100, 100)
        )
        add_child(plane)
