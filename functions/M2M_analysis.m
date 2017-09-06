function [ output_args ] = M2M_analysis( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Wanderlust analysis ----------------------------------------------------
[w_data,w_path] = pre_wanderlust(errordata,y_0,statenames,t_period);


%% Pre computation --------------------------------------------------------
for j = 1% 1 measurement output
summary = M2M_combinatorics(w_data,w_path,t_period,ic,errordata,statenames,j);
end

%% Functions and new datapoints -------------------------------------------
[y,f] = M2M_functions(summary,ic,N,snaps);

%% 2 combinations ---------------------------------------------------------
[results_save] = M2M_twocombo(y,ic,N,snaps);

%% New approach -----------------------------------------------------------
[best_comb] = M2Marea(results_save,errordata,y,ic,y_0,t_period,statenames);
B = zeros(24,1);
for i = 1:24
    B(i,1)=best_comb{i,5};
end

end

