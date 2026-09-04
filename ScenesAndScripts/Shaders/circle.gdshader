shader_type canvas_item;



void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    // Measure distance from the center (0.5, 0.5)
    float dist = distance(UV, vec2(0.5));
    
    // Discard pixels outside the radius of 0.5
    float alpha = smoothstep(0.5, 0.49, dist);
    COLOR = vec4(tex_color.rgb, tex_color.a * alpha);
    
}