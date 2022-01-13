from pathlib import Path
from PIL import Image
import numpy as np
from scripts.file_helper import get_image
from scripts.image_helper import replace_white_colour, superimpose
from random import randint, randbytes


def main():
    bg = get_image("./assets/base_templates/Background.png")
    border = get_image("./assets/base_templates/Border.png")
    face = get_image("./assets/base_templates/Face/face-circle.png")
    print("random")

    for i in range(10):
        coloured_border = replace_white_colour(border, get_random_rgb())
        coloured_bg = replace_white_colour(bg, get_random_rgb())
        coloured_face = replace_white_colour(face, get_random_rgb())

        img1 = superimpose(coloured_bg, coloured_border)
        img2 = superimpose(img1, coloured_face)

        # img1 = superimpose(coloured_bg, coloured_border)
        img2.save(f"./assets/output_test/test-run-{i}.png")

    print("Script complete!")


def get_random_rgb():
    return (randint(0, 255), randint(0, 255), randint(0, 255))
