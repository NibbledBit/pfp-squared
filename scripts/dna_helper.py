from dataclasses import dataclass


@dataclass
class Gene:
    name: str
    start: int
    length: int


def init_genes():
    genes = []
    genes.append(Gene(""))


def selection_to_dna(selection, start):
    return selection << (start - 1)


def dna_to_selection(dna, start, len):
    return (dna >> (start - 1)) & get_on_bits(len)


def get_on_bits(how_many):
    bit = 1
    on_bits = (bit << how_many) - 1
    return on_bits
