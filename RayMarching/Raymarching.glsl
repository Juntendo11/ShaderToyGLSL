// Distance to the scene

float map(vec3 p) {
    return length(p)- 1.0;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    
    //Init
    vec3 ro = vec3(0,0,-3); //Ray origin
    vec3 rd = normalize(vec3(uv,1)); //Ray direction
    vec3 col = vec3(0);
    
    float t = 0.0; //Total distance travelled for each ray
    
    //Ray marching
    for(int i=0; i < 80;i++){
        vec3 p = ro + rd * t; //Ray position

        float d = map(p); //current distance in the scene

        t += d; //March the ray

        if (d < 0.001 || t > 100.) break; //distance negligible or too big => stop
    }
    
    //coloring
    col = vec3(t * 0.2); //Color based on distance
    
    
    
    // Output to screen
    fragColor = vec4(col, 1.0);
}
