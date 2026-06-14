extends Control

# Colors for the visualization
var circle_color: Color = Color.WHITE
var dot_color: Color = Color.GREEN
var background_color: Color = Color(0.1, 0.1, 0.1, 1.0)

# Circle properties
var circle_radius: float = 120.0
var dot_radius: float = 8.0
var circle_thickness: float = 2.0

# Stick input value (-1.0 to 1.0 for each axis)
var stick_x: float = 0.0
var stick_y: float = 0.0

# Smoothing for analog input (0.0 = no smoothing, 1.0 = full smoothing)
var smoothing: float = 0.15

func _ready() -> void:
	# Enable drawing updates
	queue_redraw()

func _process(delta: float) -> void:
	stick_x = Input.get_joy_axis(0,0)
	stick_y = Input.get_joy_axis(0,1)
	queue_redraw()


func _draw() -> void:
	# Get the center of this control
	var center = Vector2(size.x / 2, size.y / 2)
	
	# Draw background
	draw_rect(Rect2(Vector2.ZERO, size), background_color)
	
	# Draw the outer circle (stick bounds)
	draw_circle(center, circle_radius, Color.TRANSPARENT)
	draw_arc(center, circle_radius, 0, TAU, 64, circle_color, circle_thickness)
	
	# Calculate dot position based on stick input
	var dot_position = center + Vector2(stick_x, stick_y) * circle_radius
	
	# Draw the dot representing stick position
	draw_circle(dot_position, dot_radius, dot_color)
	
	# Draw a subtle crosshair at center
	var crosshair_size = 10.0
	draw_line(center - Vector2(crosshair_size, 0), center + Vector2(crosshair_size, 0), circle_color, 1.0)
	draw_line(center - Vector2(0, crosshair_size), center + Vector2(0, crosshair_size), circle_color, 1.0)

## Update the stick position. Input values should be normalized between -1.0 and 1.0
func update_stick(x: float, y: float) -> void:
	# Clamp input values
	var new_x = clamp(x, -1.0, 1.0)
	var new_y = clamp(y, -1.0, 1.0)
	
	# Apply smoothing (lerp for smoother visual updates)
	stick_x = lerp(stick_x, new_x, smoothing)
	stick_y = lerp(stick_y, new_y, smoothing)

## Set custom colors for the visualization
func set_colors(bg: Color, circle: Color, dot: Color) -> void:
	background_color = bg
	circle_color = circle
	dot_color = dot
	queue_redraw()

## Set the circle radius (in pixels)
func set_circle_radius(radius: float) -> void:
	circle_radius = radius
	queue_redraw()

## Set the smoothing factor (0.0 to 1.0)
func set_smoothing(value: float) -> void:
	smoothing = clamp(value, 0.0, 1.0)

## Reset the stick position to center
func reset() -> void:
	stick_x = 0.0
	stick_y = 0.0
	queue_redraw()
