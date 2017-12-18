%% Output analysis 2
if exist('best')
dual_combi=best{1}(1,2);
dual_combi = [dual_combi{:}];

dual_area = best{1}(1,3);
dual_area = [dual_area{:}];


add_combi = best{1}(end,2);
add_combi = [add_combi{:}];
add_combi = setdiff(add_combi,dual_combi,'stable');
add_combi = add_combi';

add_area = best{1}(:,3);
add_area = [add_area{:}];
add_area = add_area';

fileID = fopen(['r' filename '.txt'],'w');
fprintf(fileID,'%12s\n', '+++++++++++++++++++++++++++++');
fprintf(fileID,'%12s\n', [datetime('now')]);
fprintf(fileID,'%12s\n', '+++++++++++++++++++++++++++++');
fprintf(fileID,'%12s%12s\n', 'Combination', 'Area');
fprintf(fileID,'%12s%12s\n', '-----------', '----------');
fprintf(fileID, '%5.0f %4.0f %9.2f\n',dual_combi,dual_area);
fprintf(fileID,'%12s%12s\n', '-----------', '----------');
fprintf(fileID, '%7.0f %12.2f\n',add_combi,add_area);
fprintf(fileID,'%12s%12s\n', 'Combination', 'Area');
fprintf(fileID,'%12s\n', '#############################');
fprintf(fileID,'%12s\n', '++++++++No warranty++++++++');
fprintf(fileID,'%12s\n', '#############################');
fclose(fileID);

else
%% Output analyis 1
best_analysis1=pre_results.np_problem.BEST{1,1};
two_combi = pre_results.two_combi.combi_store{1,1}.best;
two_area = pre_results.two_combi.combi_store{1,1}.area;
add_combi = [best_analysis1{:,2}]';
add_area = [best_analysis1{:,5}]';

fileID = fopen(['r' filename '.txt'],'w');
fprintf(fileID,'%12s\n', '+++++++++++++++++++++++++++++');
fprintf(fileID,'%12s\n', [datetime('now')]);
fprintf(fileID,'%12s\n', '+++++++++++++++++++++++++++++');
fprintf(fileID,'%12s%12s\n', 'Combination', 'Area');
fprintf(fileID,'%12s%12s\n', '-----------', '----------');
fprintf(fileID,'%5.0f %4.0f %9.2f\n',two_combi,two_area);
fprintf(fileID,'%12s%12s\n', '-----------', '----------');
fprintf(fileID,'%5.0f %14.4f\n',add_combi,add_area);
fprintf(fileID,'%12s%12s\n', '-----------', '----------');
fprintf(fileID,'%12s%12s\n', 'Combination', 'Area');
fprintf(fileID,'%12s\n', '#############################');
fprintf(fileID,'%12s\n', '++++++++No warranty++++++++');
fprintf(fileID,'%12s\n', '#############################');
fclose(fileID);
end