#version 330
out vec4 outputColor;
in vec2 UV;
uniform vec2 resolution;
uniform float time;
uniform float frame_time;
uniform vec2 mouse_pos;
uniform sampler2D bckbuffer;
uniform bool mouse_pressed;
uniform bool resized;

uniform vec2 camera_res;

#define PI 3.14159265

float smin( float a, float b, float k )
{
    float h = max( k-abs(a-b), 0.0 )/k;
    return min( a, b ) - h*h*k*(1.0/4.0);
}

void main() {
    vec2 uv = UV;
    vec2 rs = resolution;
    vec2 crs = camera_res;

    vec3 col = vec3(.0);

    uv=(uv-.5)*rs/rs.y;
    vec2 mp = mouse_pos;
    mp=(mp-.5)*rs/rs.y;

    vec4 bck = texture(bckbuffer, UV);
    float sh = length(uv-mp)-.02;
    float sh2 = abs(sh)-.005;
    sh += .005;

    col = bck.rgb;
    if(time <= 1.0 || mouse_pressed || resized){
        col.r = 1e8;
        col.b = 1e8;
        col.g = .0;
    }
    
    col.b = smin(col.b, sh, .1);
    col.r = smin(sh2, col.r, .1);
    col.r = max(col.r, -col.b);

    float msk = 1.-smoothstep(.0,.003,col.r);
    float msk2 = 1.-smoothstep(.0,.003,col.b);
    
    col.g = msk;

    outputColor = vec4(col.rgb, 1.);
}