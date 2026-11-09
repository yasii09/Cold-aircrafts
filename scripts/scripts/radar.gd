
extends Control

var blips: Array[Vector2] = []
var sweep_angle := 0.0

func _ready():
    custom_minimum_size = Vector2(170, 170)

func _process(delta):
    sweep_angle += delta * 1.5
    queue_redraw()

func set_blips(points: Array[Vector2]):
    blips = points
    queue_redraw()

func _draw():
    var center = size / 2
    var radius = min(size.x, size.y) / 2 - 5

    draw_circle(center, radius, Color(0.0, 0.12, 0.08, 0.85))

    for i in range(1, 4):
        draw_arc(center, radius * i / 3.0, 0, TAU, 64, Color.GREEN, 1.0)

    draw_line(
        center - Vector2(radius, 0),
        center + Vector2(radius, 0),
        Color.GREEN, 1.0
    )

    draw_line(
        center - Vector2(0, radius),
        center + Vector2(0, radius),
        Color.GREEN, 1.0
    )

    var sweep_end = center + Vector2(
        cos(sweep_angle), sin(sweep_angle)
    ) * radius

    draw_line(center, sweep_end, Color.LIME, 2.0)

    for point in blips:
        var radar_pos = center + point * radius
        draw_circle(radar_pos, 3.5, Color.YELLOW)

    draw_circle(center, 4, Color.WHITE)
