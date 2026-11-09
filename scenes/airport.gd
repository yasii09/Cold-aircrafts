
extends Node3D

func _ready():
    create_runway()
    create_tower()
    create_hangar()


func make_box(size: Vector3, pos: Vector3, color: Color):
    var part = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = size
    part.mesh = mesh
    part.position = pos

    var material = StandardMaterial3D.new()
    material.albedo_color = color
    part.material_override = material
    add_child(part)


func create_runway():
    make_box(
        Vector3(24, 0.3, 220),
        Vector3(0, -29.7, 0),
        Color(0.12, 0.13, 0.15)
    )

    for i in range(18):
        make_box(
            Vector3(1.2, 0.08, 5),
            Vector3(0, -29.5, -100 + i * 11),
            Color.WHITE
        )

    make_box(
        Vector3(2, 0.08, 220),
        Vector3(-11, -29.5, 0),
        Color(0.9, 0.9, 0.8)
    )
    make_box(
        Vector3(2, 0.08, 220),
        Vector3(11, -29.5, 0),
        Color(0.9, 0.9, 0.8)
    )


func create_tower():
    make_box(
        Vector3(7, 18, 7),
        Vector3(38, -21, -15),
        Color(0.65, 0.68, 0.72)
    )
    make_box(
        Vector3(12, 3, 12),
        Vector3(38, -12, -15),
        Color(0.25, 0.55, 0.7)
    )
    make_box(
        Vector3(9, 1, 9),
        Vector3(38, -10, -15),
        Color(0.35, 0.38, 0.42)
    )


func create_hangar():
    make_box(
        Vector3(32, 12, 24),
        Vector3(-45, -23, -25),
        Color(0.48, 0.52, 0.58)
    )
    make_box(
        Vector3(34, 1, 26),
        Vector3(-45, -16.5, -25),
        Color(0.25, 0.3, 0.36)
    )
