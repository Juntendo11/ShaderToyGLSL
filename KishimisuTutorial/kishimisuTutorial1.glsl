vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);
    return a + b*cos(6.28318*(c*t+d));
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    //#fragCoord = (x,y)
    //#fragColor = (r,g,b,a)
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    
    //Zoom
    float zoom = 1.0 + sin(iTime) * 0.25; // Dynamic zoom (oscillates over time)
    uv /= zoom; // Apply zoom scaling
    
    //Rotation
    float angle = iTime * 0.1; //Speed
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle)); //2D Rotation matrix
    uv *= rot;

    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0);
    
    for (float i = 0.0; i<4.0; i++) {
    
        uv = fract(uv * 1.5) - 0.5;
        float d = length(uv) * exp(-length(uv0));
        vec3 col = palette(length(uv0)+ i*0.4 + iTime*0.4);
        
        d = sin(d*8.0 + iTime)/8.;
        d = abs(d);
        d = pow(0.005/d, 1.5);
        
        finalColor += col * d;
    }
    fragColor = vec4(finalColor,1.0);
    
}
