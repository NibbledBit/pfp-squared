# slots for trait location and length in the above bit sequence
FACE_SHAPE_SLOT = 1
FACE_SHAPE_LEN = 3
HAIR_STYLE_SLOT = 4
HAIR_STYLE_LEN = 6

from scripts.dna_helper import selection_to_dna, dna_to_selection, get_on_bits, Point


# test 2 values, wrap into complete DNA value, then unwrap
def dna_tester():

    p = Point(1.5, 2.5)

    print(p)  # Point(x=1.5, y=2.5, z=0.0)

    obj = lambda: None
    obj.s = "abb"
    obj.i = 122

    print(obj)
    print(obj.s)

    foo = dict(slot=1, len=2)
    print(foo)
    print(foo["slot"])

    selected_face_shape = 2
    selected_hair_style = 26
    print(f"Selected value face: {selected_face_shape}")
    print(f"Selected value hair: {selected_hair_style}")

    full_dna = create_dna(selected_face_shape, selected_hair_style)
    print(f"Compiled DNA: {full_dna}")
    dna = full_dna

    unwrapped_face_shape = dna_to_selection(dna, FACE_SHAPE_SLOT, FACE_SHAPE_LEN)
    unwrapped_hair_style = dna_to_selection(dna, HAIR_STYLE_SLOT, HAIR_STYLE_LEN)
    print(f"Unwrapped from DNA face: {unwrapped_face_shape}")
    print(f"Unwrapped from DNA hair: {unwrapped_hair_style}")


def create_dna(face, hair):
    return selection_to_dna(face, FACE_SHAPE_SLOT) + selection_to_dna(
        hair, HAIR_STYLE_SLOT
    )


def main():
    dna_tester()
