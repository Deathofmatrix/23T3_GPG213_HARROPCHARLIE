extends Node2D

@export var team1_score = 0
@export var team2_score = 0
@export var start_in_audio_clips: Array

@export var level_total_time: float
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

var victory_scene = preload("res://Scenes/levels/victory_screen.tscn")

func _ready():
	level_total_time = level_timer.time_left
	Events.goal_scored.connect(handle_goal_scored)
	get_tree().paused = true
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false

func _process(_delta):
	level_ending_speedup()
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


func _on_level_timer_timeout():
	Events.winner_index = check_winner()
	get_tree().change_scene_to_file("res://Scenes/levels/victory_screen.tscn")

func check_winner():
	if team1_score > team2_score: return 0
	elif team2_score > team1_score: return 1
	else: return 2

func level_ending_speedup():
	if level_timer.time_left < 5:
		%LevelMusic.pitch_scale = 2
	elif level_timer.time_left < 10:
		%LevelMusic.pitch_scale = 1.5
	elif level_timer.time_left < 30:
		%LevelMusic.pitch_scale = 1.3

func play_start_in_audio(audio_index: int):
	%StartInAudio.stream = start_in_audio_clips[audio_index]
	%StartInAudio.play()

