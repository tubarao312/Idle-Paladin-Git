///@desc Draw self and light

var size = (sin(current_time * lightFlickerFrequency + lightFlickerOffset) + 1) / 2;

draw_light_circle(lightCircleSmall, size, x, y + 10);
draw_light_circle(lightCircleBig, size, x, y + 10);

draw_self();