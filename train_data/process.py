import os

files = [
"./SaC1_2.csv",
"./SaC_11_12.csv",
"./SaC_3_4.csv",
"./SaC_5_6.csv",
"./SaC_7_8.csv",
"./SaC_9_10.csv",
"./TriMesh_1_2.csv",
"./TriMesh_2_3.csv",
"./x264-DB_1_2.csv",
"./x264-DB_2_3.csv",
"./x264-DB_3_4.csv",
"./x264-DB_4_5.csv",
"./x264-DB_5_6.csv",]

for f in files:
	print f
	t_content = []
	content = open(f).readlines()[1:]
	for i,c in enumerate(content):
		if i == 0: continue
		t_content.append(c.replace(',', ';'))

	thefile = open(f, "w")
	for t_c in t_content:
		thefile.write(t_c)