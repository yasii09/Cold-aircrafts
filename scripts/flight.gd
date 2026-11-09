
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

func _unhandled_input(event):
    if event is InputEventKey:
        pitch_input = 0.0
        roll_input = 0.0

        if Input.is_key_pressed(KEY_UP):
            pitch_input = -1.0
        if Input.is_key_pressed(KEY_DOWN):
            pitch_input = 1.0
        if Input.is_key_pressed(KEY_LEFT):
            roll_input = 1.0
        if Input.is_key_pressed(KEY_RIGHT):
            roll_input = -1.0

func add_part(size: Vector3, pos: Vector3, color: Color):
    var part = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = size
    part.mesh = mesh
    part.position = pos

    var mat = StandardMaterial3D.new()
    mat.albedo_color = color
    part.material_override = mat
    add_child(part)

func create_aircraft():
    var grey = Color(0.38, 0.43, 0.48)

    add_part(Vector3(0.55, 0.45, 4.5), Vector3.ZERO, grey)
    add_part(Vector3(4.2, 0.12, 1.5), Vector3(0, 0, 0.2), grey)
    add_part(Vector3(0.18, 0.9, 0.8), Vector3(0, 0.55, 1.7), grey)
    add_part(Vector3(1.7, 0.12, 0.6), Vector3(0, 0.25, 1.7), grey)
    add_part(Vector3(0.3, 0.3, 1.2), Vector3(0, 0, -2.5), Color(0.2, 0.3, 0.4))
