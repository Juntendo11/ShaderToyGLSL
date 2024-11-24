// Distance to the scene

//Rotation
mat2 rot2D(float angle){
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

mat3 rot3D(vec3 axis, float angle){
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 -c;
    
    return mat3(
    oc*axis.x*axis.x+c,
    oc*axis.x*axis.y-axis.z*s,
    oc*axis.z*axis.x+axis.y*s,
    oc*axis.x*axis.y+axis.z*s,
    oc*axis.y*axis.y+c,
    
    oc*axis.y*axis.z-axis.x*s,
    oc*axis.z*axis.x-axis.y*s,
    oc*axis.y*axis.z+axis.x*s,
    oc*axis.z*axis.z+c);
    
    //Or 
    return mix(dot(axis, p) * axis, p, cos(angle))
           + cross(axis, p) * sin(angle);
    
}

//Intersection
float opUnion(float d1, float d2){
    return min(d1, d2);
}

float opSubtraction(float d1, float d2){
    return max(-d1, d2);
}

float opIntersection(float d1, float d2){
    return max(d1, d2);
}

float smin(float a, float b, float k){
    float h = max(k-abs(a-b), 0.0)/k;
    return min(a,b) - h*h*h*k*(1.0/6.0);
}


//Primitives
float sdSphere(vec3 p, float s) {
    return length(p) - s;
}

float sdBox(vec3 p, vec3 b) {
    vec3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)),0.0);
}

float map(vec3 p) {
    vec3 spherePos = vec3(sin(iTime)*3.0, 0.0, 0.0);
    float sphere = sdSphere(p-spherePos,1.);
    
    //float box = sdBox(p*4., vec3(0.75)) / 4.;
    float box = sdBox(p, vec3(0.75));
    
    float ground = p.y + 0.75;
    
    return min(ground, smin(sphere, box, 2.0));
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
