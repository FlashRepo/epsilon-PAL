import os

files = [f for f in os.listdir(".") if ".csv" in f]

for f in files:
	print f
	t_content = []
	content = open(f).readlines()[1:]
	for i,c in enumerate(content):
		if i == 0: continue
		t_content.append(c.replace(',', ';'))

	thefile = open("./collect/"+f, "w")
	for t_c in t_content:
		thefile.write(t_c)