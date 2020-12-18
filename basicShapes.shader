//https://www.youtube.com/watch?v=bigjgiavOM0
float Circle(vec2 uv, vec2 position, float radius, float blur) {
    float distance = length(uv-position);
    float c = smoothstep(radius,radius-blur, distance);
    return c;
}

float Smiley(vec2 uv, vec2 position, float size) {
    uv -= position;
    uv /= size;
    float mask = Circle(uv, vec2(.0), .4, .01);
    mask -= Circle(uv, vec2(-.15, .2), .07, .01);
    mask -= Circle(uv, vec2(.15, .2), .07, .01);
    mask -= Circle(uv, vec2(.0, .0), .07, .01);
    
    float mouth = Circle(uv, vec2(.0, .0), .3, .01);
    mouth -= Circle(uv, vec2(0., 0.1), .3, .01);
    
    mask -= mouth;
    return mask;
}

float Band(float t, float start, float end, float blur) {
    float step1 = smoothstep(start-blur, start+blur, t);
    float step2 = smoothstep(end+blur, end-blur, t);
    return step1 * step2;
}

float Rectangle(vec2 uv, float left, float right, float bottom, float top, float blur) {
    float band1 = Band(uv.x, left, right, blur);
    float band2 = Band(uv.y, bottom, top, blur);
    return band1 * band2;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord.xy/iResolution.xy;
    //remap UV to center of screen
    uv -= 0.5;
    //normalize to aspect ratio (keeps things round)
    uv.x *= iResolution.x/iResolution.y;
    vec3 color = vec3(0.);
    float mask = 0.;
    mask = Smiley(uv, vec2(0., .0), 1.);
    //mask = Rectangle(uv, -.2, .2, -.3, .3, .01);
    color = vec3(1.,1.,1.) * mask;
    //color = vec3(mouth);
    fragColor = vec4(color,1.0);
}