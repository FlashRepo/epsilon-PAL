% conf.num_objectives = 2;
% conf.num_features = 6;
% cols_to_read = 8
% conf.readfile = 'train_data/rs-6d-c3.csv'
% string_tmp = ''
% 
% % For reading the data from the train_data folder
% for i=1:cols_to_read
%     string_tmp = strcat(string_tmp,'%f ');
% end
% 
% data_in_f = fopen(conf.readfile);
% data_all = textscan(data_in_f,string_tmp ,'HeaderLines',0,'Delimiter',';','CollectOutput',0);
% fclose(data_in_f);
% 
% f1 = data_all{conf.num_features+1};
% f2_inv = data_all{conf.num_features+2};

% disp(zeros(10,1));

% A = [5, 4, 3, 6, 5, 2, 1; 5, 4, 3, 6, 5, 2, 1];
% B = [5, 4, 3, 6, 5, 2, 1; 5, 4, 3, 6, 5, 2, 1];
% C = [A; B];
% disp(C);

filename = strcat('a','predicted_pareto.csv', num2str(9));
disp(filename);