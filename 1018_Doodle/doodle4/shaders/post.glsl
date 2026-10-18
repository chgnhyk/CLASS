#version 330
out vec4 outputColor;
in vec2 UV;
uniform vec2 resolution;
uniform float time;
uniform float frame_time;
uniform vec2 mouse_pos;
uniform sampler2D scene_buffer;
uniform sampler2D bckbuffer;
#define PI 3.14159265

float rand(vec3 p){
    float sd1 = dot(p, vec3(13.1313, 23.4141, 17.4545));
    float sd2 = dot(p, vec3(33.3333, 19.1919, 27.2727));
    float sv = (sin(sd1) + sin(sd2)) * 45678.54321;
    return fract(sv);
}

vec3 calc_norm(sampler2D buff, vec2 uv){
    vec2 p = uv;
    vec2 p1 = uv + vec2(.001,.0);
    vec2 p2 = uv + vec2(.0,.001);

    float hsc = 10.;
    float h = texture(buff, p).r * hsc;
    float h1 = texture(buff, p1).r * hsc;
    float h2 = texture(buff, p2).r * hsc;

    vec3 p_3d = vec3(p,h);
    vec3 p_3d1 = vec3(p1,h1);
    vec3 p_3d2 = vec3(p2,h2);

    vec3 nrm = cross(normalize(p_3d1 - p_3d), normalize(p_3d2 - p_3d));
    return normalize(nrm);
}

float get_edge(sampler2D buff, vec2 uv){
    vec3 nrm = calc_norm(buff,uv);

    float edge = dot(nrm.xyz, vec3(.0,.0,1.));

    return smoothstep(.0,.3,edge);
}

float sd_box(vec2 p, vec2 w){
    vec2 bx = abs(p)-w;
    float inner = max(bx.x, bx.y);
    inner = min(.0, inner);
    float outer = length(vec2(
        max(.0,bx.x),
        max(.0,bx.y)
    ));
    return inner + outer;
}

void main() {
    vec2 uv = UV;
    vec2 rs = resolution;
    vec2 sc = vec2(80.);
    vec2 iuv = floor(uv * sc + .5)/sc;
    vec2 fuv = fract(uv*sc)-.5;
    fuv *= rs/rs.y;
    
    vec3 scn = texture(scene_buffer, iuv).rgb;

    vec3 col = vec3(.0,.6,1.);
    float edge = get_edge(scene_buffer, iuv);
    
    float bx = sd_box(fuv, vec2(.5*rs.x/rs.y,.5*edge));
    bx = 1.-smoothstep(.0,.01,bx);
    
    col = mix(col, vec3(.5,1.,.5), step(.1,scn.g));
    col = mix(col, vec3(1.,1.,.0), bx);

    float nv = length(col.rgb)/length(vec3(1.));
    float nv_pck = rand(vec3(UV,.0));
    nv_pck = step(.5,nv_pck);
    col.rgb = mix(col.rgb, vec3(1.,.9,.8), nv*nv_pck);

    outputColor = vec4(col, 1.);
}