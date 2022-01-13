from pathlib import Path
from PIL import Image


def get_image(filename):
    """
    Get and return an image from file system.

    Paramters:
    filename (string): File location

    Returns:
    Image: The image found at filename location
    """
    if not Path(filename).exists():
        print(f"Image {filename} could not be found!")
    im = Image.open(filename)
    return im


def save_image(filename, image):
    pass
