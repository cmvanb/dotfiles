#-------------------------------------------------------------------------------
# Color utilities
#-------------------------------------------------------------------------------

from dataclasses import dataclass


@dataclass
class Color():
    def __init__(self, input: str):
        if input.startswith('#'):
            input = input[1:]

        if len(input) != 6:
            raise ValueError(f'`{input}` must be 6 chars.')

        try:
            _ = int(input, 16)

        except ValueError:
            raise ValueError(f'`{input}` not a hexadecimal value.')

        self.hex = input
        self.r = int(self.hex[0:2], 16)
        self.g = int(self.hex[2:4], 16)
        self.b = int(self.hex[4:6], 16)

    def __str__(self):
        return self.as_hex()

    def as_hex(self) -> str:
        return self.hex

    def as_css_rgba(self, alpha: float) -> str:
        return f'rgba({self.r}, {self.g}, {self.b}, {alpha})'

    def as_rgb_int(self) -> str:
        return f'{self.r},{self.g},{self.b}'

    def with_hash(self) -> str:
        return f'#{self.hex}'

    def with_zerox(self) -> str:
        return f'0x{self.hex}'
