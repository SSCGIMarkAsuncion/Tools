#!/bin/python3

import sys

m = {}
l = sys.stdin.readline()
while l:
  m[l.strip()] = 1
  l = sys.stdin.readline()

for k in sorted(m.keys()):
  print(k)
