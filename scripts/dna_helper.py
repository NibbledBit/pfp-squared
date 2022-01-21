from dataclasses import dataclass

face_shape_bit_length = 3
skin_colour_bit_length = 3
eye_shape_bit_length = 2
nose_shape_bit_length = 3
eye_colour_bit_length = 3
mouth_shape_bit_length = 2


@dataclass
class Gene:
    name: str
    start: int
    length: int


def init_genes():
    genes = []
    bit_counter = 0

    genes.append(Gene("face-shape", bit_counter, face_shape_bit_length))
    bit_counter += face_shape_bit_length
    genes.append(Gene("skin-colour", bit_counter, skin_colour_bit_length))
    bit_counter += skin_colour_bit_length
    genes.append(Gene("face-shape", bit_counter, eye_shape_bit_length))
    bit_counter += eye_shape_bit_length
    genes.append(Gene("face-shape", bit_counter, nose_shape_bit_length))
    bit_counter += nose_shape_bit_length
    genes.append(Gene("skin-colour", bit_counter, eye_colour_bit_length))
    bit_counter += eye_colour_bit_length
    genes.append(Gene("face-shape", bit_counter, mouth_shape_bit_length))
    bit_counter += mouth_shape_bit_length
    return genes


def selection_to_dna(selection, start):
    return selection << (start - 1)


def dna_to_selection(dna, start, len):
    return (dna >> (start)) & get_on_bits(len)


def get_on_bits(how_many):
    bit = 1
    on_bits = (bit << how_many) - 1
    return on_bits
