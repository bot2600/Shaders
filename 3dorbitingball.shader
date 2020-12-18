float DistLine(vec3 origin, vec3 distance, vec3 point) {
    return length(cross(point-origin, distance))/length(distance);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy/iResolution.xy;
    uv -= .5;
    uv.x *= iResolution.x/iResolution.y;
    
    vec3 origin = vec3(0.,0.,-2.);
    vec3 direction = vec3(uv.x, uv.y, 0.)-origin;

    float time = iGlobalTime;
    vec3 point = vec3(sin(time), 0., 2. +cos(time));
    float distance = DistLine(origin, direction, point);
    distance = smoothstep(.1, .09, distance);
    fragColor = vec4(distance);
}