extends KinematicBody2D

var gravity: float = 1500
var acceleration: float = 2000
var deceleration: float = 2000
var stand_friction: float = 2500
var current_friction: float = 2000
var max_horizontal_speed: float = 350
var max_fall_speed: float = 1000
var jump_height: float = -450
var double_jump_height: float = -450
var coyote_time_duration: float = 0.2
var slide_friction: float = 600
var squash_speed: float = 0.1
var max_fall_speed_wall_slide: float = 200
var wall_slide_gravity: float = 200
var wall_jump_height = -500
var wall_jump_push = 400

var v_speed: float = 0
var h_speed: float = 0

var touching_ground: bool = false
var touching_wall: bool = false
var is_jumping: bool = false
var is_double_jumping: bool = false
var is_sliding: bool = false
var is_wall_sliding: bool = false
var can_double_jump: bool = false
var can_slide: bool = false
var air_jump_pressed: bool = false # if we've pressed jump just before we land
var coyote_time: bool = true # if we can jump just after we leave platform

var motion: Vector2 = Vector2.ZERO;

onready var anim: AnimatedSprite = $AnimatedSprite
onready var ray_ground: RayCast2D = $ray_ground
onready var ray_left: RayCast2D = $ray_left
onready var ray_right: RayCast2D = $ray_right
onready var stand_shape: CollisionShape2D = $stand_shape
onready var slide_shape: CollisionShape2D = $slide_shape
onready var base_scale: Vector2 = anim.scale


func _ready():
    pass


func _physics_process(delta):
    # check if we're grounded/touching wall
    check_ground_wall_logic(delta)

    handle_player_collision_shapes()

    # check if we're moving/jumping/sliding/etc
    handle_input(delta)

    do_physics(delta)


func check_ground_wall_logic(delta: float):
    # check for coyote time (have we just left platform)
    if (touching_ground and !ray_ground.is_colliding()):
        touching_ground = false
        coyote_time = true
        yield(get_tree().create_timer(coyote_time_duration), "timeout")
        coyote_time = false
        # FIXME: the logic will continue from this point, but delayed which
        # could be an issue

    # check the moment we touch ground for the first time
    if (!touching_ground and ray_ground.is_colliding()):
        anim.scale = base_scale * Vector2(1.2, 0.8)

    # set if we're touching a wall
    if (ray_right.is_colliding() or ray_left.is_colliding()):
        touching_wall = true
    else:
        touching_wall = false

    # set if we're touching the ground or not
    touching_ground = ray_ground.is_colliding()
    if (touching_ground):
        is_jumping = false
        can_double_jump = true
        motion.y = 0
        v_speed = 0

    if (is_on_wall() and !touching_ground and v_speed > 0):
        if ((Input.is_action_pressed("move_left") or
            Input.is_action_pressed("move_right")) or
            abs(Input.get_joy_axis(0, 0)) > 0.3):
            is_wall_sliding = true
        else:
            is_wall_sliding = false
    else:
        is_wall_sliding = false


func handle_input(delta: float):
    check_sliding_logic()
    handle_movement(delta)
    handle_jumping(delta)


func handle_movement(delta: float):
    # fix issue with sticking to walls when reversing direction immediately
    # after collision
    if (is_on_wall()):
        h_speed = 0
        motion.x = 0

    # input right
    if (!is_sliding and (Input.get_joy_axis(0, 0) > 0.3 or
        Input.is_action_pressed("move_right"))):
        if (h_speed < -100):
            # reversed direction
            h_speed += deceleration * delta
            if (touching_ground):
                # anim.play("turn")
                anim.play("idle")
        elif (h_speed < max_horizontal_speed):
            # not reached max speed
            h_speed += acceleration * delta
            anim.flip_h = false
            if (touching_ground):
                # anim.play("run")
                anim.play("idle")
        else:
            # reached max speed
            if (touching_ground):
                # anim.play("run")
                anim.play("idle")
    # input left
    elif (!is_sliding and (Input.get_joy_axis(0, 0) < -0.3 or
        Input.is_action_pressed("move_left"))):
        if (h_speed > 100):
            # reversed direction
            h_speed -= deceleration * delta
            if (touching_ground):
                # anim.play("turn")
                anim.play("idle")
        elif (h_speed > -max_horizontal_speed):
            # not reached max speed
            h_speed -= acceleration * delta
            anim.flip_h = true
            if (touching_ground):
                # anim.play("run")
                anim.play("idle")
        else:
            # reached max speed
            if (touching_ground):
                # anim.play("run")
                anim.play("idle")
    # not input right or left
    else:
        if (touching_ground):
            if (!is_sliding):
                # anim.play("idle")
                anim.play("idle")
            elif (abs(h_speed) < 0.2):
                anim.stop()
                anim.frame = 1
        # apply horizontal friction until we've stopped
        h_speed -= (min(abs(h_speed), current_friction * delta) * sign(h_speed))


func handle_jumping(delta: float):
    if (coyote_time and Input.is_action_just_pressed("jump")):
        v_speed = jump_height
        is_jumping = true
        can_double_jump = true

    if (touching_ground):
        if ((Input.is_action_just_pressed("jump") or air_jump_pressed) and
                !is_jumping):
            v_speed = jump_height
            is_jumping = true
            touching_ground = false
            anim.scale = base_scale * Vector2(0.5, 1.2)
    else:
        # variable jumping
        if (v_speed < 0 and !Input.is_action_pressed("jump") and
                !is_double_jumping):
            v_speed = max(v_speed, jump_height / 2)

        if (can_double_jump and Input.is_action_just_pressed("jump") and
                !coyote_time and !touching_wall):
            v_speed = double_jump_height
            # anim.play("double-jump")
            anim.play("idle")
            is_double_jumping = true
            can_double_jump = false

        # jump animation
        if (!is_double_jumping and v_speed < 0):
            # anim.play('jump-up')
            anim.play("idle")
        elif (!is_double_jumping and v_speed > 0):
            # anim.play('jump-down')
            anim.play("idle")
        elif (is_double_jumping and anim.frame == 3):
            # ie. if double jump animation has finished
            is_double_jumping = false

        # wall jumping
        if (ray_right.is_colliding() and Input.is_action_just_pressed("jump")):
            v_speed = wall_jump_height
            h_speed = -wall_jump_push
            anim.flip_h = true
            can_double_jump = true
        elif (ray_left.is_colliding() and Input.is_action_just_pressed("jump")):
            v_speed = wall_jump_height
            h_speed = wall_jump_push
            anim.flip_h = false
            can_double_jump = true

        if(is_wall_sliding):
            # anim.play("wall-slide")
            anim.play("idle")
            # required because we might not finish double jumping
            is_double_jumping = false

        # check if we're pressing jump just before we land on a platform
        if (Input.is_action_just_pressed("jump")):
            air_jump_pressed = true
            yield(get_tree().create_timer(coyote_time_duration), "timeout")
            air_jump_pressed = false


func do_physics(delta: float):
    if (is_on_ceiling()):
        # not zero to ensure collision doesn't feel floaty
        motion.y = 10
        v_speed = 10

    if (!is_wall_sliding):
        v_speed += gravity * delta
        v_speed = min(v_speed, max_fall_speed)
    else:
        v_speed += wall_slide_gravity * delta
        v_speed = min(v_speed, max_fall_speed_wall_slide)

    motion.y = v_speed
    motion.x = h_speed

    motion = move_and_slide(motion, Vector2.UP)

    # lerp out squash/squeeze scale
    apply_squash_squeeze()

func apply_squash_squeeze():
    anim.scale.x = lerp(anim.scale.x, base_scale.x, squash_speed)
    anim.scale.y = lerp(anim.scale.y, base_scale.y, squash_speed)

func handle_player_collision_shapes():
    if (is_sliding and slide_shape.disabled):
        stand_shape.disabled = true
        slide_shape.disabled = false
    elif (!is_sliding and stand_shape.disabled):
        slide_shape.disabled = true
        stand_shape.disabled = false

func check_sliding_logic():
    # check if it's possible to slide
    if (abs(h_speed) > (max_horizontal_speed - 1) and touching_ground):
        if(!is_sliding): can_slide = true
    else:
        can_slide = false

    # check if we're holding down the slide key/button
    if (can_slide and Input.is_action_pressed("slide")):
        is_sliding = true
        can_slide = false

    # check if we're sliding but just released slide key
    if (is_sliding and !Input.is_action_pressed("slide")):
        is_sliding = false

    # animation and friction logic
    if (is_sliding and touching_ground):
        current_friction = slide_friction
        # anim.play("slide")
        anim.play("idle")
    else:
        current_friction = stand_friction
