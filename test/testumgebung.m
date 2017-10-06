%% Testumgebung
% Extract your variables
data=storage.errordata';
t_period=storage.t_period;
y_0=storage.y_0;
statenames=storage.statenames;
% i=size(errordata,1);

load_options        % Load options for Wanderlust

options.gamma		= log(2)/mean(t_period(1,:));%Is this ok?

C=WChooseK(1:27,1);
% [Y,combi,cmatrix] = M2M_Cmatrix(27,2,size(data,2),data');
for j=2 %j=???
% [Y,combi,cmatrix] = M2M_Cmatrix(27,j,size(data,2),data');
% data=data*cmatrix;
data=Y';
% y_0=cmatrix*y_0;
y_0=y_0(combi,:);
options.PathIndex   = 1:size(data,2);
statenames=statenames(combi);
options.Ynames		= statenames;
options.Yindex=combi;

[s_Exp,a_Exp,s_Var,a_Var]=M2M_analysis_temp(data,t_period,y_0,options);
end

%% Area Testumgebung
C = WChooseK(1:27,2);% Two measurement outputs
combi2=cell(1,size(C,1));
for i=1:size(C,1)
[combi_store] = M2M_area_temp(s_Exp,a_Exp,s_Var,a_Var,C(i,:));
combi2(1,i)=combi_store;
end

BEST=cell(1,size(combi_store,2));
for i=1:size(combi2,2)
best=combi2.combi_store.best;
[s_Exp,a_Exp,s_Var,a_Var]=M2M_analysis_temp(data(best),t_period,y_0(best),options);
[~,best_comb] = M2M_area_temp(s_Exp,a_Exp,s_Var,a_Var,best);

empties=find(cellfun(@isempty,best_comb));%Detect empty cells
if ~isempty(empties)
best_comb(empties(1),:)=[];%Remove empty cells
else
end
BEST{i}=best_comb;
toc(np_time)
end