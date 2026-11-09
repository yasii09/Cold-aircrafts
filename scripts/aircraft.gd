
extends Node3D

func _ready():
    create_fuselage()
    create_wings()
    create_tail()
    create_nose()

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

func create_fuselage():
    add_part(Vector3(0.65, 0.55, 4.5), Vector3.ZERO, Color(0.35, 0.4, 0.45))

func create_wings():
    add_part(Vector3(4.2, 0.12, 1.5), Vector3(0, 0, 0.2), Color(0.3, 0.35, 0.4))

func create_tail():
    add_part(Vector3(0.18, 1.0, 0.8), Vector3(0, 0.65, 1.7), Color(0.25, 0.3, 0.35))
    add_part(Vector3(1.8, 0.12, 0.65), Vector3(0, 0.25, 1.7), Color(0.3, 0.35, 0.4))

func create_nose():
    add_part(Vector3(0.35, 0.3, 1.2), Vector3(0, 0, -2.5), Color(0.2, 0.25, 0.3))
