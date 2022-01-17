from scripts.dna_tester import get_on_bits


def test_dna_in_out():

    selected_hair_style = 26
    # binary = 1 1010
    selected_face_shape = 2
    # binary = 010

    hair_dna = selected_hair_style << 3
    full_dna = hair_dna + selected_face_shape
    print(f"Full DNA:{full_dna}")
    # full_dna == dna
    assert full_dna == 210
    # binary = 0 1101 0010
    dna = 210

    unwrapped_face_shape = dna & get_on_bits(3)

    unwrapped_hair_style = (dna >> 3) & get_on_bits(6)
    # face shape and hair should equal selected

    assert unwrapped_hair_style == 26
    assert unwrapped_face_shape == 2
    pass
