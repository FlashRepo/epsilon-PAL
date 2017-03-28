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

function [conf,data_all,real_pareto_set_transformed] = load_data_all(conf)

    string_tmp='';
    real_pareto_set_transformed = 0
    cols_to_read = conf.num_objectives+conf.num_features;
    if isfield(conf,'max_samples')==0
        conf.max_samples = 5000;
    end
    for i=1:cols_to_read
        string_tmp = strcat(string_tmp,'%f ');
    end

    data_in_f = fopen(conf.readfile);
    data_all = textscan(data_in_f,string_tmp ,'HeaderLines',0,'Delimiter',';','CollectOutput',0);
    fclose(data_in_f);

    if (conf.test_mode == 1) 
        f1 = data_all{conf.num_features+1};
        f2_inv = data_all{conf.num_features+2};

        max_obj1 = max(f1);
        max_obj2 = max(f2_inv);

        % min_obj1 = min(f1);
        % min_obj2 = min(f2_inv);
        % range_obj1 = max_obj1-min_obj1;
        % range_obj2 = max_obj2-min_obj2;
        % mu_obj1 = min_obj1+range_obj1/2;
        % s_obj1 = range_obj1/4;
        % mu_obj2 = min_obj2+range_obj2/2;
        % s_obj2 = range_obj2/4;
        % f1 = (((f1-mu_obj1)/(s_obj1))*10);%+40*s_obj1;
        % f2_inv = (((f2_inv-mu_obj2)/(s_obj2))*10);%+40*s_obj2;
        % f1=f1+50;
        % f2_inv = f2_inv+50;    

        f1_tmp = (f1./max_obj1)*100;
        f2_tmp = (f2_inv./max_obj2)*100;

        data_all{conf.num_features+1} = f1_tmp;
        data_all{conf.num_features+2} = f2_tmp;

        %data_all{conf.num_features+1} = f1;
        %data_all{conf.num_features+2} = f2_inv;

        % for i=1:conf.num_features
        % 
        %     f_list = data_all{i};
        %     if max(f_list)-min(f_list)>50
        %         data_all{i} = (f_list - mean(f_list))/std(f_list);
        %     end
        % end
   
        real_pareto_set_transformed = get_pareto_sets(data_all{conf.num_features+1}, data_all{conf.num_features+2})

        conf.train_data_range_obj1 = max(data_all{conf.num_features+1})-min(data_all{conf.num_features+1});
        conf.train_data_range_obj2 = max(data_all{conf.num_features+2})-min(data_all{conf.num_features+2});
    end
        
    
end
