from chgnhyk import FBO, ClipRenderer, load_shader
from moderngl import create_context
from pathlib import Path

work_path = Path(__file__).parent
sample_folder = work_path.joinpath("sample/")
shader_folder = work_path.joinpath("shaders/")

CTX = create_context(require = (330), standalone = True)
SIZE = (1080, 1080)

scene = FBO(
    ctx = CTX, size = SIZE,
    shader = load_shader(shader_folder.joinpath("scene.glsl"))
)

clip = ClipRenderer(duration = 4, fps = 30)
clip.addFBOPass("scene", scene)

clip.render_frame_sample(clip.duration * 0.5)
clip.extractImage(sample_folder.joinpath(f"test_{clip.t}.jpg"))

clip.render_pyav(sample_folder.joinpath("test.mp4"))

clip.release()
CTX.release()