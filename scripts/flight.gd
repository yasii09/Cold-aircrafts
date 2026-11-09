
extends Node3D

@export var speed := 18.0
@export var turn_speed := 1.5
@export var climb_speed := 7.0

var pitch_input := 0.0
var roll_input := 0.0

func _process(delta):
    rotation.x += pitch_input * delta * turn_speed
    rotation.z += roll_input * delta * turn_speed
    translate(Vector3(0, 0, -speed * delta))

func set_pitch(value: float):
    pitch_input = clamp(value, -1.0, 1.0)

func set_roll(value: float):
    roll_input = clamp(value, -1.0, 1.0)

func climb_up(delta: float):
    position.y += climb_speed * delta

func climb_down(delta: float):
    position.y -= climb_speed * delta
