#version 330
out vec4 outputColor;
in vec2 UV;

uniform vec2 resolution;
uniform float timer;
uniform float loop_timer;

void main(){
    vec2 uv = UV;
    vec2 rs = resolution;

    vec3 col;
    col.rg = uv;
    col.b = loop_timer;

    outputColor = vec4(col,1.);
}