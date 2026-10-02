#version 330
out vec4 outputColor;
in vec2 UV;

uniform vec2 resolution; // image resolution
uniform float timer; // 0 --> 1
uniform float loop_timer; // 0 --> 1 --> 0

uniform sampler2D VIDEO;

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

    vec2 sc = vec2(40.);
    vec2 iuv = floor(uv * sc) + .5;
    vec2 fuv = fract(uv * sc) - .5;
    vec2 tc = iuv/sc;
    tc = .5+tc/rs_c;

    vec4 ovsamp = texture(VIDEO, UV);
    vec4 vsamp = texture(VIDEO, tc);

    float rad = .5 - length(vsamp.rgb) * .3 / length(vec3(1.));
    float circle = sd_box(fuv, vec2(.1, rad));
    circle = 1. - smoothstep(.0, .1, circle);

    vec3 col;
    col = vsamp.rgb;
    col = mix(col, vec3(.1,1.,.1), circle);
    outputColor = vec4(col, 1.);
}