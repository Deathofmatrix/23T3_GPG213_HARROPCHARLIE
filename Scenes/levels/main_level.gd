extends Node2D

@export var team1_score = 0
@export var team2_score = 0

var level_time = 0.0
var ball_scene = preload("res://Scenes/objects/ball.tscn")

@onready var goal_ui = $CanvasLayer/GoalUI
@onready var level_time_label = %LevelTimeLabel
@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer
@onready var level_timer = %LevelTimer
@onready var score_1_label = $CanvasLayer/Scoreboard/Player1Score/Score1Label
@onready var score_2_label = $CanvasLayer/Scoreboard/Player2Score/Score2Label


func _ready():
	Events.goal_scored.connect(handle_goal_scored)
	get_tree().paused = true
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false

func _process(_delta):
	level_time = str(snapped(level_timer.time_left, 0.1))
	level_time_label.text = level_time

func handle_goal_scored(goal_index):
	if goal_index == 1:
		team1_score += 1
		score_1_label.text = str(team1_score)
	else:
		team2_score += 1
		score_2_label.text = str(team2_score)

func _on_goal_ui_goal_anim_over():
	var new_ball = ball_scene.instantiate() as CharacterBody2D
	new_ball.position = %BallSpawnPos.global_position
	add_child(new_ball)
