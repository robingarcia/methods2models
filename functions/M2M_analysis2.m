function [best] = M2M_analysis2(input,storage)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Extract your data
disp('Extract data')
N=input.N;
snaps=input.snaps;
ic=storage.rndmic;
% data=storage.mydata;
errordata=storage.errordata;
y_0=storage.y_0;
t_period=storage.t_period;
% time=storage.time;
statenames=storage.statenames;
%% Wanderlust and pre_computation in one function +++++++++++++++++++++++++++++++++
% Use c-matrix here!!!
C=WChooseK(1:size(ic,1),1);%1=all states ### --- C-MATRIX --- ###
y=zeros(size(ic,1),N*snaps);
load_options        % Load options for Wanderlust
options.Ynames		= statenames(C);
options.gamma		= log(2)/mean(t_period(1,:));%Is this ok?
options.PathIndex   = 1:size(ic,1);

C=WChooseK(1:size(ic,1),size(ic,1));%### --- C-MATRIX --- ###
[G,y_data,~,~] = PathfromWanderlust(errordata(C,:)',options,y_0(C));
path=G.y;

% C=WChooseK(1:size(ic,1),1);%### --- C-MATRIX --- ###
for i=1:size(y_data,2)
    Y=M2M_analysis_temp(y_data(:,i)',path(i,:),options);
    y(i,:)=Y;
end

best=([]);
[best]=M2M_area_temp(y,best,[],[]);
% C=WChooseK(1:size(ic,1),2);%### --- C-MATRIX --- ###
for i=1 %:size(best,2)
    combi = (best{1,i}(1,2));
    combi = [combi{:}];
    number_species = minus(size(ic,1),size(combi,2));
    k=1;
    while k <= number_species
    % Update options
    options.Ynames		= statenames(combi);
    options.gamma		= log(2)/mean(t_period(1,:));%???
    options.PathIndex   = 1:size(combi,2);%???
%     number_species = minus(size(ic,1),size(combi,2));
%     k=1;
%     while k <= 3 %number_species
    %Wanderlust
    [G,y_data,~,~] = PathfromWanderlust(errordata(combi,:)',options,y_0(combi));
    path=G.y;
    %Function
    Y=M2M_analysis_temp(y_data',path,options);
    % Area under the curve
    [best_update]=M2M_area_temp(y,best{i},Y,k);
    best{1,i}=best_update;
    k=k+1;
    combi=best_update(k,2);
    combi=[combi{:}];
    disp(k)
    end
end

end

