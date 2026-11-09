extends Node3D

func _ready():
    create_environment()
    create_ground()
    create_aircraft()
    create_camera()

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
    sun.light_energy = 1.2
    add_child(sun)

func create_ground():
    var ground = MeshInstance3D.new()
    var mesh = PlaneMesh.new()
    mesh.size = Vector2(500, 500)
    ground.mesh = mesh
    ground.position.y = -8

    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color(0.2, 0.4, 0.2)
    ground.material_override = mat
    add_child(ground)

func create_aircraft():
    var aircraft = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = Vector3(1.2, 0.35, 4.0)
    aircraft.mesh = mesh

    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color(0.25, 0.35, 0.55)
    aircraft.material_override = mat
    add_child(aircraft)

func create_camera():
    var camera = Camera3D.new()
    camera.position = Vector3(0, 3, 8)
    camera.rotation_degrees = Vector3(-12, 0, 0)
    add_child(camera)
    camera.current = true