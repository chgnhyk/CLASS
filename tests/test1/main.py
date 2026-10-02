from chgnhyk import FBO, load_shader, ClipRenderer
from moderngl import create_context
from pathlib import Path

work_path = Path(__file__).parent
shader_path = work_path.joinpath("shaders/")
sample_path = work_path.joinpath("sample/")


CTX = create_context(require=(330), standalone=True)
ratio = 1
SIZE = (1920, 1080)

scene = FBO(ctx=CTX, size=SIZE, shader=load_shader(shader_path.joinpath("scene.glsl")))

clip = ClipRenderer(duration=5, fps=30, rest_time=0.) #8 #30
scene.set_uniform("duration", clip.duration)
clip.addFBOPass(name = 'scene', render_pass = scene)
clip.addVideo(sample_path.joinpath("printed_room_atomic_noise.mp4"), "VID", 8)

clip.render_frame_sample(clip.duration * 0.0)
clip.extractImage(sample_path.joinpath(f"test_{clip.t}.jpg"))

vid = clip.render()
vid.write_videofile(str(sample_path.joinpath("test.mp4")), fps=clip.fps)

clip.release()
CTX.release()