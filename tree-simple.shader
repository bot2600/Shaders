//tutorial: https://www.youtube.com/watch?v=LLZPnh_LK8c
float TaperBox(vec2 position, float wb, float wt, float yb, float yt, float blur) {
    float m = smoothstep(-blur, blur, position.y-yb);
    m *= smoothstep(blur, -blur, position.y-yt);
    position.x = abs(position.x);
    float w = mix(wb, wt, (position.y-yb)/(yt-yb));
    m *= smoothstep(blur, -blur, position.x-w);
    return m;
}

vec4 Tree(vec2 uv, vec3 color, float blur) {
    float m = TaperBox(uv, .03, .03, -.02, .25, blur);
    m += TaperBox(uv, .2, .1, .25, .5, blur);
    m += TaperBox(uv, .15, .05, .5, .75, blur);
    m += TaperBox(uv, .1, .0, .75, 1., blur);

    float shadow = TaperBox(uv-vec2(.2,0.), .1, .5, .15, .25, blur);
    shadow += TaperBox(uv+vec2(.25,0.), .1, .5, .45, .5, blur);
    shadow += TaperBox(uv-vec2(.25,0.), .1, .5, .7, .75, blur);
    color -= shadow*.8;
    return vec4(color, m);
}

float GetHeight(float x) {
    return sin(x*.423)+sin(x)*.3;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    uv.x += iTime*.1;
    uv *= 5.;

    vec4 color = vec4(0);
    float blur = .005;

    float id = floor(uv.x);
    float random = fract(sin(id*234.12)*5463.3)*2.-1.;
    float x = random*.3;
    float y = GetHeight(uv.x);
    
    color += smoothstep(blur, -blur, uv.y+y); //ground

    y = GetHeight(id+.5+x);

    uv.x = fract(uv.x)-.5;

    vec2 size = vec2(1., 1.+random*.2);
    vec4 tree = Tree((uv-vec2(x,-y))*size, vec3(1), blur);

    fragColor = mix(color, tree, tree.a);
}