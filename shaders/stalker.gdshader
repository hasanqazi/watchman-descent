shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform vec3 emission_color : source_color = vec3(1.0, 0.5, 0.0);
uniform float emission_strength = 1.0;
uniform float black_threshold = 0.05; // Threshold to determine what's "black"

void fragment() {
    // Sample the texture
    vec4 tex_color = texture(albedo_texture, UV);

    // Calculate the luminance of the texture color (to determine if it's "black")
    float luminance = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

    // Set the albedo (base color)
    ALBEDO = tex_color.rgb;

    // Set emission based on whether the texture is "black" or not
    if (luminance > black_threshold) {
        // Not black, apply emission
        EMISSION = emission_color.rgb * emission_strength * tex_color.rgb;
    } else {
        // It's black, no emission
        EMISSION = vec3(0.0);
    }
}