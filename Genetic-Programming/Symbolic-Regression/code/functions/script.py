import math
from random import randint

def f(x, y): return pow(2, (x*x + y*y))
for i in range(20):
    x = randint(-5, 5)
    y = randint(-5, 5)
    print(f"({x} {y} {f(x, y)})")
