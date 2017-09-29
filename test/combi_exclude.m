%% Test ausschluss bereits verwendeter Kombinationen bei Dual combinations
dual2=nchoosek(1:27,2);
size(dual2,1);
number_species = minus(size(ic,1),size(dual2,2));
dual_combi_store=cell(1,number_species); %store your combinations here!
cobination_storage=zeros(27);
j=1:27;
j=setdiff(j,dual2(1,:));
counter=0;
% Count your run!
for i=1:size(dual2,1)
if counter==0
    
    disp('Your first turn')
    for j=j
        combi_store=dual2(i,:);
        combi_store(end+1)=j;
    end
counter=counter+1;   
else
    
    disp('Your second turn')
    
end

%% Other exclusion method
dual2=nchoosek(1:27,2);
number_species = minus(size(ic,1),size(dual2,2));
dual_combi_store=cell(1,number_species); %store your combinations here!
dual_combi_store{1}=dual2;
j=1:27;
% j=setdiff(j,dual2(1,:));
if isempty(dual_combi_store{2})
    for i = 2:size(dual_combi_store,2)
        j=1:27;
        j=setdiff(j,dual_combi_store{1,1}(1,:));
        dual_combi_store{1,i}(1,:)=dual_combi_store{i-1}(1,:);
        dual_combi_store{1,i}(1,end)=WChooseK(j,i+1);%Error here!!!
    end
%     for j=j
%     dual_combi_store{2,i} = dual_combi_store{1}(i,:);   
%     end

else
    disp('Do nothing')
end

%% Neuer Versuch
