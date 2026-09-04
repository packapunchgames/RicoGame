shader_type canvas_item;

uniform float corner_radius : hint_range(0.0, 0.5) = 0.15;
uniform float edge_smoothness : hint_range(0.001, 0.05) = 0.005;

float sd_rounded_box(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + vec2(r);
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

void fragment() {
    // 1. Correct UV aspect ratio
    vec2 uv = UV - vec2(0.5);
    vec2 size = vec2(1.0);
    if (TEXTURE_PIXEL_SIZE.x > 0.0 && TEXTURE_PIXEL_SIZE.y > 0.0) {
        float aspect = TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x;
        if (aspect > 1.0) {
            uv.x *= aspect;
            size.x *= aspect;
        } else {
            uv.y /= aspect;
            size.y /= aspect;
        }
    }
    
    // 2. Calculate distance mask alpha
    vec2 half_size = size * 0.5;
    float dist = sd_rounded_box(uv, half_size, corner_radius);
    float mask_alpha = 1.0 - smoothstep(-edge_smoothness, edge_smoothness, dist);
    
    // 3. COLOR already contains texture(TEXTURE, UV) * modulate. 
    // Simply multiply its current alpha by the corner mask.
    COLOR.a *= mask_alpha;
}