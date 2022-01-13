import numpy as np
from PIL import Image
import math


def replace_colour(image, from_colour, to_colour):
    """
    Replace a colour in an image.

    Paramters:
    image (Image): The image the colours will be replaced within.
    from_colour (Color): The color being replaced.
    to_colour (Color): The color to replace with.

    Returns:
    Image: The image with replaced colours.
    """
    data = convert_image_to_array(image)  # "data" is a height x width x 4 numpy array
    red, green, blue, alpha = data.T  # Temporarily unpack the bands for readability

    # Replace white with red... (leaves alpha values alone...)
    white_areas = (
        (red == from_colour[0]) & (blue == from_colour[1]) & (green == from_colour[2])
    )
    data[..., :-1][white_areas.T] = to_colour  # Transpose back needed

    return convert_array_to_image(data)


def replace_white_colour(image, to_colour):
    """
    Replace the colour white within an image.

    Paramters:
    image (Image): The image the colour white will be replaced within.
    to_colour (Color): The color to replace with.

    Returns:
    Image: The image with replaced colours.
    """
    return replace_colour(image, (255, 255, 255), to_colour)


def superimpose(background, foreground):
    """
    Superimpose an image onto another image.

    Paramters:
    foreground (Image): The image imposed onto.
    background (Image): The image to be put on top.

    Returns:
    Image: The image with replaced colours.
    """
    new_image = background.copy()
    new_image.paste(foreground, mask=foreground)
    return new_image


def convert_image_to_array(image):
    return np.array(image)


def convert_array_to_image(array):
    return Image.fromarray(array)
