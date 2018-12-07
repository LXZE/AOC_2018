import numpy as np
from itertools import combinations as comb

def levenshtein(s, t):
		if s == t: return 0
		elif len(s) == 0: return len(t)
		elif len(t) == 0: return len(s)
		v0 = [None] * (len(t) + 1)
		v1 = [None] * (len(t) + 1)
		for i in range(len(v0)):
			v0[i] = i
		for i in range(len(s)):
			v1[0] = i + 1
			for j in range(len(t)):
				cost = 0 if s[i] == t[j] else 1
				v1[j + 1] = min(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost)
			for j in range(len(v0)):
				v0[j] = v1[j]
		return v1[len(t)]

file = open('input2.txt', 'r')
data = list(map(lambda line: line[:-1], file.readlines()))
data_set = list(comb(data, 2))
distance = list(map(lambda tup: levenshtein(tup[0], tup[1]), data_set))
idx = np.argmin(np.array(distance))
ans = ''
for a,b in zip(data_set[idx][0], data_set[idx][1]):
	if a == b:
		ans += a
print(ans)