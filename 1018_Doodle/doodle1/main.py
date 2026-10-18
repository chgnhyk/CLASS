from chgnhyk import RealtimeEngine
from chgnhyk import FBO, load_shader
from pathlib import Path

work_path = Path(__file__).parent
shaders_folder = work_path.joinpath("shaders/")

scale = 2

real = RealtimeEngine(size = (270, 480), frame_path=work_path.joinpath('frames/'), fps=24, scale=scale)

scn_pass = FBO(ctx=real.ctx, size=(int(real.size[0]*scale), int(real.size[1]*scale)), shader=load_shader(shaders_folder.joinpath('scene.glsl')), enable_backbuffer = True, scale=1)

render_pass = FBO(ctx=real.ctx, size=(int(real.size[0]*scale), int(real.size[1]*scale)), shader=load_shader(shaders_folder.joinpath('post.glsl')), enable_backbuffer = False)
render_pass.set_texture_uniform(scn_pass.texture, "scene_buffer", 8) 

def resize_func(_obj):
    render_pass.set_texture_uniform(scn_pass.texture, "scene_buffer", 8) 

real.setResizeFunc(resize_func)

real.addFBOPass(name="scene", render_pass=scn_pass)
real.addFBOPass(name="post", render_pass=render_pass, is_last=True)

try:
    real.run()
finally:
    pass