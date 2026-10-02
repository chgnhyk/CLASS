#version 330
out vec4 outputColor;
in vec2 UV;

uniform vec2 resolution;
uniform float timer;
uniform float loop_timer;

void main(){
    outputColor = vec4(UV, loop_timer, 1.);
}