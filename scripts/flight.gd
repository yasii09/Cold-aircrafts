
extends Node3D

@export var speed := 18.0
@export var turn_speed := 1.2
@export var climb_speed := 7.0

var pitch_input := 0.0
var roll_input := 0.0
var throttle_input := 0.0


func _ready():
    create_aircraft()


func _process(delta):
    rotation.x += pitch_input * turn_speed * delta
    rotation.z += roll_input * turn_speed * delta
    position += -global_basis.z * speed * delta
    position.y += throttle_input * climb_speed * delta
    position.y = clamp(position.y, -10.0, 100.0)


func set_controls(pitch: float, roll: float, throttle: float):
    pitch_input = clamp(pitch, -1.0, 1.0)
    roll_input = clamp(roll, -1.0, 1.0)
    throttle_input = clamp(throttle, -1.0, 1.0)


func add_part(mesh: Mesh, pos: Vector3, color: Color):
    var part = MeshInstance3D.new()
    part.mesh = mesh
    part.position = pos

    var mat = StandardMaterial3D.new()
    mat.albedo_color = color
    part.material_override = mat
    add_child(part)


func create_aircraft():
    var grey = Color(0.38, 0.43, 0.48)
    var dark = Color(0.12, 0.16, 0.2)
    var glass = Color(0.08, 0.35, 0.55)

    var body = CylinderMesh.new()
    body.top_radius = 0.25
    body.bottom_radius = 0.5
    body.height = 4.5
    add_part(body, Vector3.ZERO, grey)

    var wings = BoxMesh.new()
    wings.size = Vector3(4.5, 0.12, 1.5)
    add_part(wings, Vector3(0, -0.1, 0.2), grey)

    var tail = BoxMesh.new()
    tail.size = Vector3(1.5, 0.12, 0.7)
    add_part(tail, Vector3(0, 0.1, 1.7), grey)

    var fin = BoxMesh.new()
    fin.size = Vector3(0.15, 0.9, 0.8)
    add_part(fin, Vector3(0, 0.55, 1.7), dark)

    var cockpit = SphereMesh.new()
    cockpit.radius = 0.45
    cockpit.height = 0.8
    add_part(cockpit, Vector3(0, 0.35, -0.8), glass)

    var nose = SphereMesh.new()
    nose.radius = 0.25
    nose.height = 0.5
    add_part(nose, Vector3(0, 0, -2.2), dark)
