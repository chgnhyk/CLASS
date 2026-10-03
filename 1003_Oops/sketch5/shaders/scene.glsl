#version 330
out vec4 outputColor;
in vec2 UV;

uniform vec2 resolution;
uniform float timer;
uniform float loop_timer;

#define PI 3.14159265

vec2 rotate(vec2 p, float a){
    return vec2(
        cos(a) * p.x - sin(a) * p.y,
        sin(a) * p.x + cos(a) * p.y
    );
}

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
    float dst = length(p-h)-w;
    if(dt < .0){
        dst = length(p-a)-w;
    }else if(dt > l){
        dst = length(p-b)-w;
    }
    return dst;
}

float sd_box(vec2 p, vec2 w){
    return max(
        abs(p.x)-w.x,
        abs(p.y)-w.y
    );
}

void main(){
    vec2 uv = UV;
    vec2 rs = resolution;

    uv = (uv-.5)*rs/rs.y;

    float anm1 = smoothstep(.1,.5,loop_timer);
    float anm2 = smoothstep(.1,.9,timer);
    float anm3 = smoothstep(.5,.9,loop_timer);

    vec3 col = vec3(.0, .6, 1.);
    
    uv = rotate(uv, -2.*PI*anm2);

    const int num = 8;
    float ang = PI/float(num);
    float rad = .2;
    float r = rad * sin(ang);
    for(int i=0; i<num; i++){
        float angle = anm1*float(i)*2.*PI/float(num);
        vec2 off = vec2(cos(angle), sin(angle)) * rad;
        float petal = sd_line(uv-off, vec2(.0), off * (1.+.1*anm3), r);
        petal = 1.-smoothstep(.0,.003,petal);
        col = mix(col, vec3(1.), petal);
    }

    float center = sd_circle(uv, rad - r);
    center = 1.-smoothstep(.0,.003,center);
    col = mix(col, vec3(1.,1.,.0), center);
    
    outputColor = vec4(col,1.);
}