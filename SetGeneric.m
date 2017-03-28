% PAL (Pareto Active Learning) Algorithm 
%
% Copyright (c) 2014 ETH Zurich
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

classdef SetGeneric
   properties
      
      num_entries=0;
      all_data = [];
      num_features;
      
      prediction = 0;
      real_data = 1; %there is real obj array
      
      features_index=0;
      real_obj_index=0;
      mu_index=0;
      sigma_index=0;
      rt_mu_index=0;
      rt_sigma_index=0;
      pareto_index=0;

      
   end % properties
   methods
      function self = SetGeneric(num_features_in,prediction_in,real_data_in)
        self.num_features = num_features_in;
        self.prediction = prediction_in;
        self.real_data = real_data_in;
        
        self.features_index = 1;
        if self.real_data==1
            self.real_obj_index = self.features_index + self.num_features;
            next_index = self.real_obj_index + 2;
        else
            next_index = self.features_index + self.num_features;
        end
        if self.prediction==1
            self.mu_index = next_index;
            self.sigma_index = next_index + 2;
            self.rt_mu_index = next_index + 4;
            self.rt_sigma_index = next_index + 6;
            next_index = next_index + 8;
        end
        
        self.pareto_index = next_index;
      
      end
      
      function self = add_entry(self,all_data_in)

        len_in = size(all_data_in);
        len_in = len_in(1);
        
        self.all_data = [self.all_data;all_data_in];

        self.num_entries = self.num_entries + len_in;

      end 

      function cell_out = remove_entry(self,remove_index)
	  %save removed entry
	  
          self.num_entries = self.num_entries - 1;

            if self.real_data==1
                remove_entry_out = self.all_data(remove_index,1:self.num_features+2);
            else
                remove_entry_out = self.all_data(remove_index,1:self.num_features);
            end
          self.all_data = removerows(self.all_data,'ind',remove_index);

          cell_out = {self,remove_entry_out};
      end

      function self = remove_entries(self,remove_index)
	
          self.all_data = removerows(self.all_data,'ind',remove_index);

          len_tmp = size(self.all_data);
          self.num_entries = len_tmp(1);          
      end
      
            
      function entry_out = get_entry(self,index_in)
          entry_out = self.all_data(index_in,:);
      end
      
      function features_out = get_features(self,index_in)
          features_out = self.all_data(index_in,self.features_index:self.features_index+self.num_features-1);
      end

      function self = set_features(self,index_in,features_in)
          self.all_data(index_in,self.features_index:self.features_index+self.num_features-1) = features_in;
      end
      
      function real_obj_out = get_real_obj(self,index_in,sel_in)
          tmp_index = self.real_obj_index+sel_in-1;
          real_obj_out = self.all_data(index_in,tmp_index);
      end
      function self = set_real_obj(self,index_in,real_obj_in,sel_in)
          tmp_index = self.real_obj_index+sel_in+1;
          self.all_data(index_in,tmp_index) = real_obj_in;
      end
      function mu_out = get_mu(self,index_in,sel_in)
          tmp_index = self.mu_index+sel_in-1;
          mu_out = self.all_data(index_in,tmp_index);
      end
      function self = set_mu(self,index_in,mu_in,sel_in)
          tmp_index = self.mu_index+sel_in-1;
          self.all_data(index_in,tmp_index) = mu_in;
      end
      function sigma_out = get_sigma(self,index_in,sel_in)
          tmp_index = self.sigma_index+sel_in-1;
          sigma_out = self.all_data(index_in,tmp_index);
      end
      function self = set_sigma(self,index_in,sigma_in,sel_in)
          tmp_index = self.sigma_index+sel_in-1;
          self.all_data(index_in,tmp_index) = sigma_in;
      end
      function rt_mu_out = get_rt_mu(self,index_in,sel_in)
          tmp_index = self.rt_mu_index+sel_in-1;
          rt_mu_out = self.all_data(index_in,tmp_index);
      end
      function self = set_rt_mu(self,index_in,rt_mu_in,sel_in)
          tmp_index = self.rt_mu_index+sel_in-1;
          self.all_data(index_in,tmp_index) = rt_mu_in;
      end
      function rt_sigma_out = get_rt_sigma(self,index_in,sel_in)
          tmp_index = self.rt_sigma_index+sel_in-1;
          rt_sigma_out = self.all_data(index_in,tmp_index);
      end
      function self = set_rt_sigma(self,index_in,rt_sigma_in,sel_in)
          tmp_index = self.rt_sigma_index+sel_in-1;
          self.all_data(index_in,tmp_index) = rt_sigma_in;
      end
      function pareto_out = get_pareto(self,index_in)
          pareto_out = self.all_data(index_in,self.pareto_index);
      end
      function self = set_pareto(self,index_in,pareto_in)
          self.all_data(index_in,self.pareto_index) = pareto_in;
      end
%       function pp_out = get_pp(self,index_in)
%           pp_out = self.all_data(index_in,self.pp_index);
%       end
%       function self = set_pp(self,index_in,pp_in)
%           self.all_data(index_in,self.pp_index) = pp_in;
%       end
%       function no_class_out = get_no_class(self,index_in)
%           no_class_out = self.all_data(index_in,self.no_class_index);
%       end
%       function self = set_no_class(self,index_in,no_class_in)
%           self.all_data(index_in,self.no_class_index) = no_class_in;
%       end
%       function duplicates_out = get_duplicates(self,index_in)
%           duplicates_out = self.all_data(index_in,self.duplicates_index);
%       end
%       function self = set_duplicates(self,index_in,duplicates_in)
%           self.all_data(index_in,self.duplicates_index) = duplicates_in;
%       end
%       function found_hash_out = get_found_hash(self,index_in,hash_index)
%           tmp_index = self.found_hash_index+hash_index-1;
%           found_hash_out = self.all_data(index_in,tmp_index);
%       end
%       function self = set_found_hash(self,index_in,hash_index,found_hash_in)
%           tmp_index = (self.found_hash_index+hash_index-1);
%           self.all_data(index_in,tmp_index) = found_hash_in;
%       end
      
      function self = clear_data(self)
          if self.real_data==1
            tmp_index = self.real_obj_index + 2;
          else
            tmp_index = self.features_index + self.num_features;
          end
          tmp = size(self.all_data);
          tmp = tmp(2);
          self.all_data(:,tmp_index:end)=zeros(self.num_entries,tmp-tmp_index+1);
          self.all_data(:,self.no_class_index)=ones(self.num_entries,1);
 
      end
      function entries_out = get_entries(self,indexes_in)
         entries_out = self.all_data(indexes_in,:);
      end
   end% methods
end% classdef
