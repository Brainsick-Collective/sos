shader_type canvas_item;
render_mode unshaded;

uniform float tile_factor = 10.0;
uniform float aspect_ratio = 0.5;

uniform vec2 time_factor = vec2(2.0, 3.0);
uniform vec2 offset_factor = vec2(5.0, 2.0);
uniform float amplitude = 0.5;

uniform vec4 mask_color : hint_color;
uniform float mix_amount = 0.5;
uniform float time  : hint_range(0.0, 1.0);

void fragment() {
	
	vec4 sampled_color = texture( TEXTURE, UV);
    vec4 color = sampled_color;
    if(sampled_color.a != 0.0) {
        color = mix(sampled_color, sin(time * time_factor.y + UV.y * amplitude) + mask_color, mix_amount);
        color.a = sampled_color.a;
       }

    COLOR = color;
}