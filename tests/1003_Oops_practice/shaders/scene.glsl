#version 330
out vec4 outputColor;
in vec2 UV;

uniform vec2 resolution;
uniform float timer;
uniform float loop_timer;

float sd_circle(vec2 p, float r){
    return length(p)-r;
}

float sd_line(vec2 p, vec2 a, vec2 b, float w){
    vec2 ba = b - a;
    vec2 pa = p - a;
    vec2 dr = normalize(ba);
    float l = length(ba);
    float dt = dot(pa, dr);
    vec2 h = a + dt * dr;
    float dst = length(h-p)-w;

    if(dt < .0){
        dst = length(p-a)-w;
    }else if(dt > l){
        dst = length(p-b)-w;
    }

    return dst;
}

float sd_box(vec2 p, vec2 w){
    float inner = max(
        abs(p.x)-w.x,
        abs(p.y)-w.y
    );
    inner = min(.0, inner);
    float outer = length(vec2(
        max(.0, abs(p.x)-w.x),
        max(.0, abs(p.y)-w.y)
    ));
    return inner+outer;
}

void main(){
    vec2 uv = UV;
    vec2 rs = resolution;

    uv = (uv-.5)*rs/rs.y;

    vec3 col;
    col.rg = uv;

    float circle = sd_circle(uv - vec2(.1,.0), .3);
    circle = 1.-smoothstep(.0,.003,circle);
    col = mix(col, vec3(.0,.6,1.), circle);
    
    float line = sd_line(uv, vec2(.3), vec2(-.3), .01);
    line = 1.-smoothstep(.0,.003,line);
    col = mix(col, vec3(1.,.1,.0), line);

    float box = sd_box(uv, vec2(.1,.2));
    box = 1.-smoothstep(.0,.003,box);
    col = mix(col, vec3(.0,.5,.0), box);

    outputColor = vec4(col, 1.);
}