vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263, 0.416, 0.557);
    return a + b*cos(6.28318*(c*t+d));
}


mat2 rot2D(float angle){
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec3 finalColor = vec3(0.0);
    float angle = iTime * 0.2;
    
    for (float i = 0.0; i < 32.0; i+= 1.0) {
        //uv = fract(uv * 1.5) - 0.5; //Split views
        uv = (abs(uv)-0.1)*1.1+0.1*sin(iTime);
        uv *= rot2D(angle);
        vec3 col = palette(length(uv)+ i*0.4 + iTime*0.4);
        //finalColor += col*uv;
        finalColor = col;
    }
    
    //fragColor = vec4(vec3(length(uv)),1.0);
    fragColor = vec4(finalColor,1.0);
}
