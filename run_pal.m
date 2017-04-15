% PAL (Pareto Active Learning) Algorithm 
%
% Copyright (c) 2013 ETH Zurich
% 
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

clear all;
fclose('all');
close all;
import java.io.*;
cd gpml-matlab-v3.2-2013-01-15
startup
cd ..
RandStream.setGlobalStream(RandStream('mt19937ar','seed',cputime));

data_folder = './conf/';
%'sol-6d-c2.dat';
files = {'x264-DB_2_3.dat'; 'x264-DB_1_2.dat'; 'x264-DB_3_4.dat'; 'x264-DB_4_5.dat'; 'x264-DB_5_6.dat'; 'TriMesh_1_2.dat'; 'TriMesh_2_3.dat'; 'SaC1_2.dat'; 'SaC3_4.dat'; 'SaC_5_6.dat'; 'SaC_7_8.dat'; 'SaC_9_10.dat'; 'SaC_11_12.dat'};%; 'sol-6d-c2.dat'};%'wc+rs-3d-c4.dat'; 'noc.dat';'sn.dat'; 'wc+sol-3d-c4.dat';'wc+wc-3d-c4.dat'; 'wc-3d-c4.dat'; 'wc-5d-c5.dat'; 'wc-6d-c1.dat'; 'wc-c1-3d-c1.dat'; 'wc-c3-3d-c1.dat'};
% config_file = -1;
% while(config_file==-1)
%     config_file = input('Input the name of the configuration file: ', 's');
%     if exist(config_file,'file')==0
%         config_file = -1;
%     end
% end
file_iter = 1;
while file_iter <= length(files)
    max_time = 60 * 60;
    config_file = strcat(data_folder, char(files(file_iter)));
    %read configuration file
    [conf,state,gp_conf] = load_defaults(config_file);

    conf.factor_beta = 1; 
    conf.plot_prediction=0;s
    conf.display = 0;
    conf.delta = 0.1;
    conf.gap_hyp_update = 1000; 
    conf.display = 1;

    % shuffling the list epsilon_list
    conf.epsilon_list = conf.epsilon_list(randsample(1:length(conf.epsilon_list),length(conf.epsilon_list)),:);

    %load data_all array
    %real_pareto_set_transformed <- This is a real pareto front in normalized
    %terms (0-100).
    % conf <- The objective ranges are modified in this function
    % data_all <- All the data in the data file
    [conf,data_all,real_pareto_set_transformed]=load_data_all(conf);
    failed=0;
    rep_iter = 1;
    while rep_iter <= 20
        epsilon_iter = 1;
        while epsilon_iter <= length(conf.epsilon_list)
            t_start = tic;
            state.force_end=0;
            state.iter_train = 0;

            %set iteration variables
            epsilon = conf.epsilon_list(epsilon_iter);

            % 
            conf.epsilon_classification = epsilon/2;
            epsilon_tmp_obj1 = conf.epsilon_classification*conf.train_data_range_obj1;
            epsilon_tmp_obj2 = conf.epsilon_classification*conf.train_data_range_obj2;

            if (conf.test_mode == 1) 
                real_data_in = 1;
                untouched_set = SetGeneric(conf.num_features,0,1);
                % dividing into independent and dependent values
                entry_tmp = [cell2mat(data_all(:,1:conf.num_features)),cell2mat(data_all(:,conf.num_features+1:conf.num_features+2))];
            else
                real_data_in = 0;
                untouched_set = SetGeneric(conf.num_features,0,0);
                entry_tmp = cell2mat(data_all(:,1:conf.num_features));
            end

            untouched_set = untouched_set.add_entry(entry_tmp);
            conf.n = size(entry_tmp,1);

            pop_sampled = SetGeneric(conf.num_features,0,1);
            pop_predicted = SetGeneric(conf.num_features,1,real_data_in);

            if conf.display==1
                disp('******************* start new experiment *******************')
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%% start %%%%%%%%%%%%% %%%%%%%%%%%%%%%
            %tic
            %disp('start')
            state.total_time=0;
            while (state.force_end==0)
                t_stop = toc(t_start);
                fprintf('# %d %f %f \n', pop_sampled.num_entries, t_stop, epsilon);
                if (t_stop > max_time)
                    epsilon_iter = epsilon_iter + 1;
                    break;
                end
                state.count_rounds = state.count_rounds +1;
                state.iter_train = state.iter_train+1;

                if (pop_sampled.num_entries>0 && pop_predicted.num_entries>0 && conf.plot_prediction==1)
                   plot_gp_predictions(pop_sampled,pop_predicted,real_pareto_set_transformed);
                   pause
                end

                %calculate the value of beta
                if (pop_sampled.num_entries == 0)
                    tmp_t = conf.length_training_start;
                else
                    tmp_t = pop_sampled.num_entries;	
                end
                tmp_pi_t = double(pi^2 * tmp_t^2)/6;
                tmp_beta = double(conf.n * 2 * tmp_pi_t)/ conf.delta;
                state.beta = double(sqrt(2*log(double(tmp_beta))))/conf.factor_beta;


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%% choose next sample %%%%%%%%%%%%%%%%%%%%
                try
                    if (state.refill_pop == 0 || pop_sampled.num_entries==0)
                        [untouched_set,pop_sampled,pop_predicted,state] = choose_next_sample(untouched_set,pop_sampled,pop_predicted,conf,state,gp_conf);
                    end
                catch
                    break;
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%%% update models and make prediction %%%%%%%%%%%%%%%%%%%


                try
                    [pop_predicted,gp_conf] = update_predictions(pop_sampled,pop_predicted,gp_conf,conf,state);
                catch
                    failed = failed + 1;
                    disp('failed');
                    failed;
                    break
                end


                if (pop_predicted.num_entries>0 )

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%%%%%%%%%%%%%%%%%%%%%% discard points %%%%%%%%%%%%%%%%%%%%%%%%%
                    %tmp1= pop_predicted.num_entries;
                    [state,pop_predicted] = discard(pop_sampled,pop_predicted,conf,state);
                    %discarded_num = tmp1 - pop_predicted.num_entries
                    %sum_pareto = sum((pop_predicted.get_pareto(:)))
                end                 
                if (pop_predicted.get_pareto(:)==ones(pop_predicted.num_entries,1))
                        state.force_end = 1;
                        
                end              
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%%%%%%%%%%%%%%% error calculation and print outs %%%%%%%%%%%%%%%%

                if ((pop_predicted.num_entries==0 && untouched_set.num_entries==0) || state.force_end==1)
                    epsilon_iter = epsilon_iter + 1;
                    state.total_time = state.total_time + toc;

                    if conf.test_mode==1
                        %calculate error
                        predicted_pareto_01list = [ones(pop_sampled.num_entries,1);ones(pop_predicted.num_entries,1)];
                        num_evaluations = pop_sampled.num_entries + pop_predicted.num_entries;

                        real_obj1 = [pop_sampled.get_real_obj(:,1);pop_predicted.get_real_obj(:,1)];
                        real_obj2 = [pop_sampled.get_real_obj(:,2);pop_predicted.get_real_obj(:,2)];
                        [epsilon_perc_obj1,epsilon_perc_obj2,avg_epsilon_perc_obj1,avg_epsilon_perc_obj2] = get_epsilon_indicator(real_pareto_set_transformed,predicted_pareto_01list,real_obj1,real_obj2,conf.train_data_range_obj1,conf.train_data_range_obj2);

                        file_out_stop_obj1 = fopen(strcat(conf.results_folder,'prediction_error.csv'), 'a');
                        fprintf(file_out_stop_obj1, '%d,%f,%d,%f,%f,%d\n',rep_iter, epsilon,num_evaluations,avg_epsilon_perc_obj1,state.total_time,pop_sampled.num_entries);

                        filename = strcat(conf.results_folder,'predicted_pareto', '_', num2str(rep_iter), '_', num2str(epsilon), '.csv');
                        file_out_pop = fopen(filename, 'w');
                        for tmp_index_list = 1:pop_sampled.num_entries
                            line = pop_sampled.get_features(tmp_index_list);
                            for tmp_index_list2=1:(length(line)-1)
                                    fprintf(file_out_pop,'%f;',line(tmp_index_list2));
                            end
                            fprintf(file_out_pop,'%f\n',line(tmp_index_list2+1));
                        end
                        for tmp_index_list = 1:pop_predicted.num_entries
                            line = pop_predicted.get_features(tmp_index_list);
                            for tmp_index_list2=1:(length(line)-1)
                                    fprintf(file_out_pop,'%f;',line(tmp_index_list2));
                            end
                            fprintf(file_out_pop,'%f\n',line(tmp_index_list2+1));
                        end

                    end

                    fclose('all'); 

                    if conf.display == 1
                        fprintf('***********  ended  ***********\n',state.iter_train)
                        fprintf('number of evaluations : %d\n',num_evaluations)
                        if conf.test_mode==1
                            fprintf('epsilon: %f\n',avg_epsilon_perc_obj1)
                        end
                        fprintf('total time: %f\n',state.total_time)

                        %plot_gp_predictions(pop_sampled,pop_predicted);
                        %   pause

                    end

                    break
                end


            end

        end
        rep_iter = rep_iter + 1;
        rep_iter;
    end
    file_iter = file_iter + 1;
end
