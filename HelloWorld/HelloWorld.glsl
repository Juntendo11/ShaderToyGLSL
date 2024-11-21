// ShaderToy-compatible GLSL
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalize coordinates
    vec2 uv = fragCoord / iResolution.xy;
    uv = uv * 2.0 - 1.0; // Center the coordinates
    uv.x *= iResolution.x / iResolution.y; // Correct aspect ratio

    // Zoom scale
    float zoom = 1.0 + tan(iTime)*tan(iTime) * 0.75; // Dynamic zoom (oscillates over time)
    uv /= zoom; // Apply zoom scaling

    // Time for rotation
    float angle = iTime * 0.3; // Slow rotation
    mat2 rot = mat2(cos(angle*1.5), -sin(angle*0.9), sin(angle*0.1), cos(angle));
    uv *= rot; // Apply rotation

    // Fractal iteration
    vec3 color = vec3(0.0);
    
    float red = 0.0;
    float green = 0.0;
    float blue = 0.0;
    
    vec2 p = uv;
    for (int i = 0; i < 10; i++) {
        p = abs(p) / dot(p, p + 0.25) - 1.25 + sin(iTime); // Keep values bounded
        red += 0.1 / (dot(p, p) + 0.2);
    }
    for (int i = 0; i < 10; i++) {
        p = abs(p) / dot(p, p + 0.3) - 1.0 + cos(iTime); // Keep values bounded
        green += 0.1 / (dot(p, p) + 0.1);
    }
    for (int i = 0; i < 10; i++) {
        p = abs(p) / dot(p, p + 0.2) - 1.5 + tan(iTime); // Keep values bounded
        blue += 0.1 / (dot(p, p) + 0.1);
    }

    // Final color output
    fragColor = vec4(red, green,blue, 1.0);
}
