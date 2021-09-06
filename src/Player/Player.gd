class_name Player

extends KinematicBody2D

const GRAVITY: float = 1500.0
const ACCELERATION: float = 2000.0
const DECELERATION: float = 2000.0
const FRICTION: float = 2000.0
const MAX_HORIZONTAL_SPEED: float = 350.0
const MAX_FALL_SPEED: float = 1000.0
const JUMP_HEIGHT: float = -450.0
const DOUBLE_JUMP_HEIGHT: float = -450.0
const COYOTE_TIME_DURATION: float = 0.2
const SQUASH_SPEED: float = 0.1
const MAX_FALL_SPEED_WALL_SLIDE: float = 200.0
const WALL_SLIDE_GRAVITY: float = 200.0
const WALL_JUMP_HEIGHT: float = -500.0
const WALL_JUMP_PUSH: float = 400.0

var v_speed: float = 0
var h_speed: float = 0

var touching_ground: bool = false
var touching_wall: bool = false
var is_jumping: bool = false
var is_double_jumping: bool = false
var is_wall_sliding: bool = false
var can_double_jump: bool = false
var air_jump_pressed: bool = false # if we've pressed jump just before we land
var coyote_time: bool = true # if we can jump just after we leave platform

var motion: Vector2 = Vector2.ZERO;

onready var anim: AnimatedSprite = $AnimatedSprite
onready var ray_ground: RayCast2D = $RayGround
onready var ray_left: RayCast2D = $RayLeft
onready var ray_right: RayCast2D = $RayRight
onready var shape: CollisionShape2D = $CollisionShape2D

onready var base_scale: Vector2 = anim.scale

func _physics_process(delta):
    # check if we're grounded/touching wall
    check_ground_wall_logic(delta)

    # check if we're moving/jumping/sliding/etc
    handle_input(delta)

    do_physics(delta)


func check_ground_wall_logic(_delta: float):
    # check for coyote time (have we just left platform)
    if touching_ground and !ray_ground.is_colliding():
        touching_ground = false
        coyote_time = true
        yield(get_tree().create_timer(COYOTE_TIME_DURATION), "timeout")
        coyote_time = false
        # FIXME: the logic will continue from this point, but delayed which
        # could be an issue

    # check the moment we touch ground for the first time
    if !touching_ground and ray_ground.is_colliding():
        anim.scale = base_scale * Vector2(1.2, 0.8)

    # set if we're touching a wall
    if ray_right.is_colliding() or ray_left.is_colliding():
        touching_wall = true
    else:
        touching_wall = false

    # set if we're touching the ground or not
    touching_ground = ray_ground.is_colliding()
    if touching_ground:
        is_jumping = false
        can_double_jump = true
        motion.y = 0
        v_speed = 0

    if is_on_wall() and !touching_ground and v_speed > 0:
        if (Input.is_action_pressed("move_left")
                or Input.is_action_pressed("move_right")
                or abs(Input.get_joy_axis(0, 0)) > 0.3):
            is_wall_sliding = true
        else:
            is_wall_sliding = false
    else:
        is_wall_sliding = false


func handle_input(delta: float):
    handle_movement(delta)
    handle_jumping(delta)


func handle_movement(delta: float):
    # fix issue with sticking to walls when reversing direction immediately
    # after collision
    if is_on_wall():
        h_speed = 0
        motion.x = 0

    # input right
    if Input.get_joy_axis(0, 0) > 0.3 or Input.is_action_pressed("move_right"):
        if h_speed < -100:
            # reversed direction
            h_speed += DECELERATION * delta
            if touching_ground:
                # anim.play("turn")
                anim.play("idle")
        elif h_speed < MAX_HORIZONTAL_SPEED:
            # not reached max speed
            h_speed += ACCELERATION * delta
            anim.flip_h = false
            if touching_ground:
                # anim.play("run")
                anim.play("idle")
        else:
            # reached max speed
            if touching_ground:
                # anim.play("run")
                anim.play("idle")
    # input left
    elif Input.get_joy_axis(0, 0) < -0.3 or Input.is_action_pressed("move_left"):
        if h_speed > 100:
            # reversed direction
            h_speed -= DECELERATION * delta
            if touching_ground:
                # anim.play("turn")
                anim.play("idle")
        elif h_speed > -MAX_HORIZONTAL_SPEED:
            # not reached max speed
            h_speed -= ACCELERATION * delta
            anim.flip_h = true
            if touching_ground:
                # anim.play("run")
                anim.play("idle")
        else:
            # reached max speed
            if touching_ground:
                # anim.play("run")
                anim.play("idle")
    # not input right or left
    else:
        if touching_ground:
            anim.play("idle")
        # apply horizontal friction until we've stopped
        h_speed -= (min(abs(h_speed), FRICTION * delta) * sign(h_speed))


func handle_jumping(_delta: float):
    if coyote_time and Input.is_action_just_pressed("jump"):
        v_speed = JUMP_HEIGHT
        is_jumping = true
        can_double_jump = true

    if touching_ground:
        if ((Input.is_action_just_pressed("jump") or air_jump_pressed)
                and !is_jumping):
            v_speed = JUMP_HEIGHT
            is_jumping = true
            touching_ground = false
            anim.scale = base_scale * Vector2(0.5, 1.2)
    else:
        # variable jumping
        if (v_speed < 0 and !Input.is_action_pressed("jump")
                and !is_double_jumping):
            v_speed = max(v_speed, JUMP_HEIGHT / 2)

        if (can_double_jump and Input.is_action_just_pressed("jump")
                and !coyote_time and !touching_wall):
            v_speed = DOUBLE_JUMP_HEIGHT
            # anim.play("double-jump")
            anim.play("idle")
            is_double_jumping = true
            can_double_jump = false

        # jump animation
        if !is_double_jumping and v_speed < 0:
            # anim.play('jump-up')
            anim.play("idle")
        elif !is_double_jumping and v_speed > 0:
            # anim.play('jump-down')
            anim.play("idle")
        elif is_double_jumping and anim.frame == 3:
            # ie. if double jump animation has finished
            is_double_jumping = false

        # wall jumping
        if ray_right.is_colliding() and Input.is_action_just_pressed("jump"):
            v_speed = WALL_JUMP_HEIGHT
            h_speed = -WALL_JUMP_PUSH
            anim.flip_h = true
            can_double_jump = true
        elif ray_left.is_colliding() and Input.is_action_just_pressed("jump"):
            v_speed = WALL_JUMP_HEIGHT
            h_speed = WALL_JUMP_PUSH
            anim.flip_h = false
            can_double_jump = true

        if is_wall_sliding:
            # anim.play("wall-slide")
            anim.play("idle")
            # required because we might not finish double jumping
            is_double_jumping = false

        # check if we're pressing jump just before we land on a platform
        if Input.is_action_just_pressed("jump"):
            air_jump_pressed = true
            yield(get_tree().create_timer(COYOTE_TIME_DURATION), "timeout")
            air_jump_pressed = false


func do_physics(delta: float):
    if is_on_ceiling():
        # not zero to ensure collision doesn't feel floaty
        motion.y = 10
        v_speed = 10

    if !is_wall_sliding:
        v_speed += GRAVITY * delta
        v_speed = min(v_speed, MAX_FALL_SPEED)
    else:
        v_speed += WALL_SLIDE_GRAVITY * delta
        v_speed = min(v_speed, MAX_FALL_SPEED_WALL_SLIDE)

    motion.y = v_speed
    motion.x = h_speed

    motion = move_and_slide(motion, Vector2.UP)

    # lerp out squash/squeeze scale
    anim.scale.x = lerp(anim.scale.x, base_scale.x, SQUASH_SPEED)
    anim.scale.y = lerp(anim.scale.y, base_scale.y, SQUASH_SPEED)
