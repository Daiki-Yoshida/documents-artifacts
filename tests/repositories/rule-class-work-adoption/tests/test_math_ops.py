import unittest

from src.math_ops import double


class DoubleTests(unittest.TestCase):
    def test_double(self):
        self.assertEqual(double(4), 8)


if __name__ == "__main__":
    unittest.main()
