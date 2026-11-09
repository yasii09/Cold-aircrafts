extends Node3D

@export var move_speed := 8.0
var direction := Vector3.FORWARD

func _ready():
    var body = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = Vector3(0.5, 0.4, 3.0)
    body.mesh = mesh

    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.8, 0.8, 0.85)
    body.material_override = material
    add_child(body)

func _process(delta):
    position += direction * move_speed * delta

func set_direction(new_direction: Vector3):
    direction = new_direction.normalized()