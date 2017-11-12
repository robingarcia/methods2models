% function results=M2M_processing(best)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

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
fprintf(fileID,'%12s%12s\n', 'Combination', 'Area');
fprintf(fileID,'%12s%12s\n', '-----------', '----------');
fprintf(fileID, '%5.0f %4.0f %9.2f\n',dual_combi,dual_area);
fprintf(fileID, '%7.0f %12.2f\n',add_combi,add_area);
fclose(fileID); 
% end

