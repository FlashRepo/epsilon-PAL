import os
import pandas as pd

files = [
"./train_data/MONRP_50_4_5_0_90-p10000-d50-o3-dataset1.csv",
"./train_data/MONRP_50_4_5_0_90-p10000-d50-o3-dataset2.csv",
"./train_data/MONRP_50_4_5_0_110-p10000-d50-o3-dataset1.csv",
"./train_data/MONRP_50_4_5_0_110-p10000-d50-o3-dataset2.csv",
"./train_data/MONRP_50_4_5_4_90-p10000-d50-o3-dataset1.csv",
"./train_data/MONRP_50_4_5_4_90-p10000-d50-o3-dataset2.csv",
"./train_data/MONRP_50_4_5_4_110-p10000-d50-o3-dataset1.csv",
"./train_data/MONRP_50_4_5_4_110-p10000-d50-o3-dataset2.csv",
"./train_data/POM3A-p10000-d9-o3-dataset1.csv",
"./train_data/POM3A-p10000-d9-o3-dataset2.csv",
"./train_data/POM3B-p10000-d9-o3-dataset1.csv",
"./train_data/POM3B-p10000-d9-o3-dataset2.csv",
"./train_data/POM3C-p10000-d9-o3-dataset1.csv",
"./train_data/POM3C-p10000-d9-o3-dataset2.csv",
"./train_data/POM3D-p10000-d9-o3-dataset1.csv",
"./train_data/POM3D-p10000-d9-o3-dataset2.csv",
"./train_data/xomo_all-p10000-d27-o4-dataset1.csv",
"./train_data/xomo_all-p10000-d27-o4-dataset2.csv",
"./train_data/xomo_all-p10000-d27-o4-dataset3.csv",
"./train_data/xomo_flight-p10000-d27-o4-dataset1.csv",
"./train_data/xomo_flight-p10000-d27-o4-dataset2.csv",
"./train_data/xomo_flight-p10000-d27-o4-dataset3.csv",
"./train_data/xomo_ground-p10000-d27-o4-dataset1.csv",
"./train_data/xomo_ground-p10000-d27-o4-dataset2.csv",
"./train_data/xomo_ground-p10000-d27-o4-dataset3.csv",
"./train_data/xomo_osp-p10000-d27-o4-dataset1.csv",
"./train_data/xomo_osp-p10000-d27-o4-dataset2.csv",
"./train_data/xomo_osp-p10000-d27-o4-dataset3.csv",
"./train_data/xomoo2-p10000-d27-o4-dataset1.csv",
"./train_data/xomoo2-p10000-d27-o4-dataset2.csv",
"./train_data/xomoo2-p10000-d27-o4-dataset3.csv",]

for f in files:
	print f
	name = f.split('/')[-1]
	fname = "./conf/" + name[:-4] + ".dat"

	content = open("./conf/rs-6d-c3.dat").readlines()
	os.system("mkdir results_" + name[:-4])
	os.system("touch results_" + name[:-4] + "/.keep")


	line0 = "name = " + name + "\n"
	train_filename = "./train_data/" + name

	contentf = pd.read_csv(train_filename, header=None, sep=';')
	columns = contentf.columns
	features = len(columns) - 2
	line1 = "num_features = " + str(features) + "\n"
	line2 = "readfile = " + train_filename + "\n"
	line3 = "results_folder = results_" + name[:-4] + "/\n"

	
	ranges = []
	for col_no in [-2, -1]:
		col = contentf.iloc[:, col_no].tolist()
		ranges.append(max(col) - min(col))

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


 