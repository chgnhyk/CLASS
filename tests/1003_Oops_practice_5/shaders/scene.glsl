#version 330
out vec4 outputColor;
in vec2 UV;

uniform vec2 resolution;
uniform float timer;
uniform float loop_timer;

#define PI 3.14159265

vec2 rotate(vec2 p, float a){
    return vec2(
        cos(a)*p.x - sin(a)*p.y,
        sin(a)*p.x + cos(a)*p.y
    );
}

float sd_circle(vec2 p, float r){
    return length(p)-r;
}

float sd_line(vec2 p, vec2 a, vec2 b, float w){
    vec2 ba = b-a;
    vec2 pa = p-a;
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
    inner = min(inner, .0);

    float outer = length(vec2(
        max(.0, abs(p.x)-w.x),
        max(.0, abs(p.y)-w.y)
    ));

    return inner + outer;
}

void main(){
    vec2 uv = UV;
    vec2 rs = resolution;

    uv = (uv-.5);

    vec3 col = vec3(1.);

    float anm1 = smoothstep(.1,.4,loop_timer);
    float anm2 = smoothstep(.1,.9,timer);
    float anm3 = smoothstep(.5,.9,loop_timer);
    float anm4 = 1.-smoothstep(.1,.3,loop_timer);

    const int num = 8;
    float rad = .2;
    float r = rad * sin(PI/float(num));
    r += anm3 * .03;
    vec2 a = vec2(.0, anm4);
    uv = uv - a;
    uv = rotate(uv, 2.*PI*anm2);
    float petals = 1e8;
    for(int i=0; i<num; i++){
        float angle = anm1*i*(2.*PI)/float(num);
        
        vec2 b = vec2(cos(angle), sin(angle)) * rad;
        vec2 puv = uv - b;
        float petal = sd_line(puv, vec2(.0), b*1., r);
        petals = min(petal, petals);
    }

    float op = petals * 10.;
    petals = 1.-smoothstep(.0,.003,petals);
    col = mix(col, vec3(
        sin(op * 1. + timer * 2. * PI) * .5 + .5,
        sin(op * 3.) * .5 + .5,
        sin(op * 5.) * .5 + .5
    ), petals);

    float center = sd_box(uv, vec2(rad - r)*cos(PI/4.));//sd_circle(uv, rad - r);
    float oc = center * 10.;
    center = 1.-smoothstep(.0,.003,center);
    col = mix(col, vec3(
        sin(oc * 2.) * .5 + .5,
        sin(oc * 1.5 + timer * 2. * PI) * .5 + .5,
        sin(oc * 5.) * .5 + .5
    ), center);

    outputColor = vec4(col, 1.);
}