shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_toon, specular_toon;

uniform vec4 color : source_color = vec4(1.0);
uniform sampler2D texture_color : source_color, filter_linear_mipmap, repeat_enable;

uniform vec3 uv1_scale = vec3(1.0);
uniform vec3 uv1_offset = vec3(0.0);

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
}

void fragment() {
	vec4 color_tex = texture(texture_color, UV);
	ALBEDO = color.rgb * color_tex.rgb;
}

uniform sampler2D color_gradient; 
uniform sampler2D reflection_dot_gradient;

void light() {
	float dot_product = clamp(dot(NORMAL, LIGHT), -0.95, 1);
	float sample = clamp((dot_product + 1.0) * ATTENUATION / 2.1, 0.01, 1);
	
	vec4 shaded = texture(color_gradient, vec2(sample, 0.0)) + texture(reflection_dot_gradient, vec2(sample, 0.0));
	DIFFUSE_LIGHT += clamp((shaded.rgb * LIGHT_COLOR), 0.0, 1.0);
}

