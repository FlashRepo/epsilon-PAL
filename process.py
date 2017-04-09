import os
import pandas as pd

files = [
"./train_data/SaC1_2.csv",
"./train_data/SaC_11_12.csv",
"./train_data/SaC_3_4.csv",
"./train_data/SaC_5_6.csv",
"./train_data/SaC_7_8.csv",
"./train_data/SaC_9_10.csv",
"./train_data/TriMesh_1_2.csv",
"./train_data/TriMesh_2_3.csv",
"./train_data/x264-DB_1_2.csv",
"./train_data/x264-DB_2_3.csv",
"./train_data/x264-DB_3_4.csv",
"./train_data/x264-DB_4_5.csv",
"./train_data/x264-DB_5_6.csv",]

for f in files:
	print f
	name = f.split('/')[-1]
	fname = "./conf/" + name[:-4] + ".dat"

	content = open("./conf/rs-6d-c3.dat").readlines()

	line0 = "name = " + name + "\n"
	train_filename = "./train_data/" + name

	contentf = pd.read_csv(train_filename)
	columns = contentf.columns
	features = len([c for c in columns if "<$" not in c])
	line1 = "num_features = " + str(features) + "\n"
	line2 = "readfile = " + train_filename + "\n"
	line3 = "results_folder = results_" + name[:-4] + "/\n"

	dep_columns = [c for c in columns if "<$" in c]
	ranges = []
	for d_c in dep_columns:
		ranges.append(max(contentf[d_c]) - min(contentf[d_c]))

	line6 = "train_data_range_obj1 = " + str(ranges[0]) + "\n"
	line7 = "train_data_range_obj2 = " + str(ranges[1]) + "\n"

	line15 = "maximize_obj1 = 0" + "\n"
	line16 = "maximize_obj2 = 0" + "\n"

	content[0] = line0
	content[1] = line1
	content[2] = line2
	content[3] = line3
	content[6] = line6
	content[7] = line7
	content[15] = line15
	content[16] = line16

	open(fname, "w").write("".join(content))


 