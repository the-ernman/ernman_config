// cyber-glow — subtle bloom on bright text + faint scanlines + vignette.
// Shadertoy-compatible image shader. iChannel0 is the rendered terminal.
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec3 color = texture(iChannel0, uv).rgb;

    // Accumulate a soft glow from nearby bright pixels.
    vec3 bloom = vec3(0.0);
    float total = 0.0;
    vec2 texel = 1.0 / iResolution.xy;
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 off = vec2(float(x), float(y)) * texel * 2.0;
            float w = 1.0 / (1.0 + float(x * x + y * y));
            vec3 s = texture(iChannel0, uv + off).rgb;
            float lum = dot(s, vec3(0.299, 0.587, 0.114));
            bloom += s * smoothstep(0.4, 1.0, lum) * w;
            total += w;
        }
    }
    bloom /= total;
    color += bloom * 0.35;

    // Faint scanlines.
    color -= sin(uv.y * iResolution.y * 3.14159) * 0.03;

    // Gentle vignette toward the edges.
    vec2 vg = uv * (1.0 - uv);
    color *= mix(0.86, 1.0, pow(vg.x * vg.y * 15.0, 0.25));

    fragColor = vec4(color, 1.0);
}
