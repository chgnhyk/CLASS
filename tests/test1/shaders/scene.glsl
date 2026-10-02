#version 330
out vec4 outputColor;
in vec2 UV;

uniform sampler2D bckbuffer;
uniform vec2 resolution;
uniform sampler2D VID;
uniform vec2 VID_res;

uniform float timer;
uniform float loop_timer;
uniform float duration;

#define PI 3.14159265

float rand(vec3 p){
    float sd1 = dot(p, vec3(31.3131,23.2323,17.1717));
    float sd2 = dot(p, vec3(13.1313,15.1515,19.1919));
    float sv = sin(sd1) + sin(sd2);
    return fract(sv * 45678.654321);
}

vec2 rotate(vec2 p, float a){
    return vec2(
        p.x * cos(a) - p.y * sin(a),
        p.x * sin(a) + p.y * cos(a)
    );
}

float sd_segment(vec2 p, vec2 a, vec2 b, float w){
    vec2 ba = b - a;
    vec2 pa = p - a;
    vec2 dr = normalize(ba);
    float l = length(ba);

    float dt = dot(pa, dr);
    vec2 h = a + dt * dr;

    float dst = length(h-p)-w;
    if(dt <= .0){
        dst = length(p-a)-w;
    }

    if(dt >= l){
        dst = length(p-b)-w;
    }

    return dst;
}

void main() {
    vec2 uv = UV;
    vec2 rs = resolution;
    uv = (uv-.5);
    uv *= rs/rs.y;

    vec2 sc = vec2(40.);
    
    vec2 iuv = floor(uv*sc);
    if(mod(iuv.y,2.) == .0){
        uv.x -= .5/sc.x;
    }
    iuv = floor(uv*sc);
    vec2 fuv = fract(uv*sc)-.5;
    vec2 vtc = (iuv/sc)*rs.y/rs + .5;
    vec4 vsamp = texture(VID, vtc);
    vec4 ovsamp = texture(VID, UV);

    float h = length(vsamp.rgb)/length(vec3(1.));
    h = floor(h * 8.)/8.;
    fuv = rotate(fuv, h * PI * 2.);
    float sh = sd_segment(fuv, vec2(-.4,.0), vec2(.4,.0), .02);
    sh = 1.-smoothstep(.0,.001 * sc.x,sh);

    vec3 col;
    col = mix(vsamp.rgb, vec3(.1,1.,.1), sh);
    //col = vsamp.rgb;
    outputColor = vec4(col, 1.);
}