//tutorial: https://www.youtube.com/watch?v=XaiYKkxvrFM
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

float Hash21(vec2 point) {
    point = fract(point*vec2(234.45, 765.34));
    point += dot(point, point+547.123);
    return fract(point.x*point.y);
}

vec4 Layer(vec2 uv, float blur) {
    vec4 color = vec4(0);
    float id = floor(uv.x);
    float random = fract(sin(id*234.12)*5463.3)*2.-1.;
    float x = random*.3;
    float y = GetHeight(uv.x);
    float ground = smoothstep(blur, -blur, uv.y+y);
    color += ground;
    y = GetHeight(id+.5+x);
    uv.x = fract(uv.x)-.5;
    vec2 size = vec2(1., 1.+random*.2);
    vec4 tree = Tree((uv-vec2(x,-y))*size, vec3(1), blur);
    color = mix(color, tree, tree.a);
    color.a = max(ground, tree.a);
    return color;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    //click and drag with mouse
    vec2 mouse = (iMouse.xy/iResolution.xy)*2.-1.;
    float t = iTime*.3;
    
    float blur = .005;

    float twinkle = dot(length(sin(uv+t)), length(cos(uv*vec2(22.,6.7)-t*3.)));
    twinkle = sin(twinkle*10.)*.5+.5;
    float stars = pow(Hash21(uv), 100.)*twinkle;

    vec4 color = vec4(stars);
    vec2 moonOffset = vec2(.4,.2);
    vec2 crescentOffset = vec2(.5,.25);
    float moon = smoothstep(.01, -.01, length(uv-moonOffset)-.15);
    //dont render stars in dark part of moon
    color *= 1.-moon;
    moon *= smoothstep(-.01, .05, length(uv-crescentOffset)-.15);
    color += moon;

    vec4 layer;
    for(float i=0.; i<1.;i+=1./10.) {
        float scale = mix(30., 1., i);
        blur = mix(.05, .005, i);
        layer = Layer(uv*scale+vec2(t+i*100.,i)-mouse, blur);
        layer.rgb *= (1.-i)*vec3(.9,.9,1.);
        color = mix(color, layer, layer.a);
    }

    layer = Layer(uv+vec2(t,1)-mouse, .07);
    color = mix(color, layer*.1, layer.a);
    
    fragColor = color;
}