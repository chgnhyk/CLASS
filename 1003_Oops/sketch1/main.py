from chgnhyk import FBO, ClipRenderer
from moderngl import create_context

CTX = create_context(require=(330), standalone=True)
SIZE = (1080, 1080)

shader = '''
#version 330
out vec4 outputColor;
in vec2 UV;

uniform sampler2D bckbuffer;
uniform vec2 resolution;

uniform float timer;
uniform float loop_timer;
uniform float duration;

void main() {
    vec2 uv = UV;
    vec2 rs = resolution;

    outputColor = vec4(uv, loop_timer, 1.);
}
'''

scene = FBO(
    ctx = CTX, size = (1080, 1080), shader = shader
)

clip = ClipRenderer(duration=2, fps=30, rest_time=0.)
clip.addFBOPass("", scene)

clip.render_frame_sample(clip.duration * 0.0)
clip.extractImage((f"test_{clip.t}.jpg"))
clip.render_pyav("test.mp4")

clip.release()
CTX.release()