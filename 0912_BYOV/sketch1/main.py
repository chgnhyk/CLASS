from chgnhyk import FBO, ClipRenderer, load_shader
from moderngl import create_context
from pathlib import Path

work_path = Path(__file__).parent
sample_folder = work_path.joinpath("sample/")
shader_folder = work_path.joinpath("shader/")

CTX = create_context(
    require = (330), 
    standalone = True)
SIZE = (1080, 1080)

scene = FBO(
    ctx = CTX, 
    size = SIZE, 
    shader = load_shader(shader_folder.joinpath("scene.glsl"))
    )

clip = ClipRenderer(duration = 2, fps = 30)
clip.addFBOPass("scene", scene)

# render!
clip.render_frame_sample(clip.duration * 0)
clip.extractImage(sample_folder.joinpath(f"test_{clip.t}.jpg"))

vid = clip.render()
vid.write_videofile(str(sample_folder.joinpath("test.mp4")), fps = clip.fps)
# render end

clip.release()
CTX.release()