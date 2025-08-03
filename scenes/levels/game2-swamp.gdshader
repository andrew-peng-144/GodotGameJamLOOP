shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 0.5, 1.0); // pale yellow

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    COLOR = tex_color * tint_color;
}