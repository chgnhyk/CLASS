#version 330
out vec4 outputColor;
in vec2 UV;

uniform vec2 resolution; // image resolution
uniform float timer; // 0 --> 1
uniform float loop_timer; // 0 --> 1 --> 0

#define PI 3.14159265

vec2 rotate(vec2 p, float a){
    return vec2(
        cos(a)*p.x-sin(a)*p.y,
        sin(a)*p.x+cos(a)*p.y
    );
}

float sd_circle(vec2 p, float r){
    return length(p) - r;
}

float sd_ring(vec2 p, float r, float w){
    float ring = length(p) - r;
    ring = abs(ring) - w;
    return ring;
}

float sd_box(vec2 p, vec2 w){
    float box = max(
        abs(p.x)-w.x, 
        abs(p.y)-w.y
    );

    return box;
}

float sd_line(vec2 p, vec2 a, vec2 b, float w){
    vec2 ba = b - a;
    vec2 pa = p - a;
    vec2 dr = normalize(ba);
    float dt = dot(dr, pa);
    vec2 h = a + dt * dr;
    float dst = length(h - p) - w;
    if(dt <= .0){
        dst = length(p - a) - w;
    }

    if(dt >= length(ba)){
        dst = length(p - b) - w;
    }

    return dst;
}

void main(){
    vec2 uv = UV;
    vec2 rs = resolution;
    vec2 rs_c = rs/min(rs.y, rs.x);
    uv = (uv-.5) * rs_c;

    float circle = sd_circle(uv, .3 + loop_timer * -.1);
    float circle_sm = 1.-smoothstep(.0,.003,circle);
    // float circle_sh = 1.;
    // if(circle > .0){
    //     circle_sh = .0;
    // }

    float ring = sd_ring(uv, .4 + loop_timer * .1, .01);
    float ring_sm = 1.-smoothstep(.0,.003,ring);

    uv = rotate(uv, timer * 2. * PI);
    float box = sd_box(uv, vec2(.1));
    float box_sm = 1.-smoothstep(.0,.003,box);

    uv = rotate(uv, loop_timer * 2. * PI);
    float line = sd_line(uv, vec2(.0,.45), vec2(.0,-.45), .005);
    float line_sm = 1.-smoothstep(.0,.003,line);

    vec3 col = vec3(1.);
    col = mix(col, vec3(.0), circle_sm);
    col = mix(col, vec3(1.,.0,.0), ring_sm);
    col = mix(col, vec3(.0,.0,1.), box_sm);
    col = mix(col, vec3(.0,.5,.0), line_sm);

    outputColor = vec4(col, 1.);
}