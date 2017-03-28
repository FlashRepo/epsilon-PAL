num_features = 18;
num_objectives = 2;
readfile='train_data/sw_products/berkeleyDB_log.csv';
results_folder='results_bdb/'
random_start = 1; %percent of samples to start 
ea_file = 'train_data/random_sampling/bdb_random_';
log_train  = 1;

num_features = 3;
num_objectives = 2;
readfile='train_data/rs_fft.csv';
results_folder='results_rs_fft/'
random_start = 1; %percent of samples to start 
ea_file = 'train_data/random_sampling/rs_random_';
log_train  = 1;

num_features = 11;
num_objectives = 2;
readfile='train_data/sw_products/llvm_input_log.csv';
results_folder='results_llvm/'
random_start = 1; %percent of samples to start 
ea_file = 'train_data/random_sampling/llvm_random_';
log_train  = 1;

num_features = 4;
num_objectives = 2;
readfile='train_data/noc_IM_log.csv';
results_folder='results_noc_cm/'
random_start = 1; %percent of samples to start 
ea_file = 'train_data/random_sampling/noc_random_';
log_train  = 1;

num_features = 3;
num_objectives = 2;
readfile='train_data/sort_256.csv';
results_folder='results_sort_256/'
random_start = 1; %percent of samples to start 
ea_file = 'train_data/random_sampling/sn_random_';
log_train  = 1;




repetitions = 200

total_cols = num_features+num_objectives;

file_out_err_area = fopen(strcat(results_folder,'obj1_random_prediction_error.csv'), 'w');
file_out_err_thrput = fopen(strcat(results_folder,'obj2_random_prediction_error.csv'), 'w');
    
string_tmp='';
for i=1:num_features+num_objectives
    string_tmp = strcat(string_tmp,'%f ');
end

data_in_f = fopen(readfile);
data_all = textscan(data_in_f,string_tmp ,'HeaderLines',1,'Delimiter',';','CollectOutput',0);
fclose(data_in_f);

%for now, we support 2 objectives
area_index = num_features+1;
thrput_index = num_features+2;
response_area = data_all{area_index};
response_thrput = data_all{thrput_index};


%used for using functions that support several pareto fronts in one data
%set
logn = zeros(length(data_all{1}),1); logn = logn+4;

real_pareto_set = get_pareto_sets(response_area, response_thrput);

for i=1:num_features
    string_tmp = strcat(string_tmp,'%f ');
end

counter = 0;
for r = 1:repetitions
    r
    try
        ea_file_full = strcat(ea_file,num2str(r),'.csv')
        data_in_f = fopen(ea_file_full);
    	ea_data = textscan(data_in_f,string_tmp ,'HeaderLines',0,'Delimiter',';','CollectOutput',0);
    	fclose(data_in_f);
    catch
	ea_file
        disp('file does not exist');
        continue
    end

    %find pareto 0 1 list corresponding to EA prediction
    prediction_ea = zeros(length(response_area),1);

    a_predicted = [];
    t_predicted = [];

    for i = 1:length(ea_data{1})
       for j = 1:length(response_area)
            for f = 1:num_features
                temp_list_all = data_all{f};
                temp_list_ea = ea_data{f};
                equal = 1;
                %temp_list_ea(j)
                %temp_list_all(i)
                if temp_list_ea(i)~=temp_list_all(j)
                    equal = 0;
    %                 disp('not equal')
    %                 pause
                    break

                end

            end
            if (equal==1)

                %disp('equal')
                prediction_ea(j)=1;
                a_predicted = [a_predicted;data_all{num_features+1}(j)];
                t_predicted = [t_predicted;data_all{num_features+2}(j)];
                break
            end


       end
       %evaluate predicition so far
       [avg_pareto_hv_error_obj1,avg_pareto_hv_error_obj2] = get_pareto_hv_error(real_pareto_set,prediction_ea,response_area,response_thrput,log_train);
%	[avg_pareto_hv_error_obj1,avg_pareto_hv_error_obj2] 
      
	num_eval = length(a_predicted);
      fprintf(file_out_err_area, '%f,%f\n',num_eval,avg_pareto_hv_error_obj1);
      fprintf(file_out_err_thrput, '%f,%f\n',num_eval,avg_pareto_hv_error_obj2);

       %pause
    end
	counter = counter + 1;
   
end
disp('files read:')
counter
