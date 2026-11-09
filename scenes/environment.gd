
extends Node3D

func _ready():
    create_mountains()
    create_clouds()


func create_mountains():
    var mountain_material = StandardMaterial3D.new()
    mountain_material.albedo_color = Color(0.32, 0.36, 0.38)

    for i in range(24):
        var mountain = MeshInstance3D.new()
        var mesh = PrismMesh.new()

        mesh.size = Vector3(
            randf_range(25.0, 55.0),
            randf_range(35.0, 75.0),
            randf_range(25.0, 55.0)
        )

        mountain.mesh = mesh
        mountain.material_override = mountain_material

        var angle = TAU * float(i) / 24.0
        mountain.position = Vector3(
            cos(angle) * 180.0,
            -15.0,
            sin(angle) * 180.0
        )

        add_child(mountain)


func create_clouds():
    var cloud_material = StandardMaterial3D.new()
    cloud_material.albedo_color = Color(0.9, 0.94, 1.0)
    cloud_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

    for i in range(35):
        var cloud = MeshInstance3D.new()
        var mesh = SphereMesh.new()

        mesh.radius = randf_range(3.0, 7.0)
        mesh.height = mesh.radius * 1.5

        cloud.mesh = mesh
        cloud.scale = Vector3(
            randf_range(1.5, 3.0),
            0.5,
            randf_range(1.5, 3.0)
        )
        cloud.material_override = cloud_material

        cloud.position = Vector3(
            randf_range(-220.0, 220.0),
            randf_range(25.0, 65.0),
            randf_range(-220.0, 220.0)
        )

        add_child(cloud)
