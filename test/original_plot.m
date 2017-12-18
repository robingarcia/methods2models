%% Plot free cycling cell cycle (total cycline)
dirname     =['plots_' filename];
mkdir([workpath,'/fig'],dirname)
mkdir('~/bwSyncAndShare/Masterarbeit/fig/',dirname)
c = zeros(4, 31);
c(1,[3 4 9 10 30]) = 1;    % CycBT
c(2,[2 15 29]) = 1;        % CycAT
c(3,[5 16 31]) = 1;        % CycET
c(4,12) = 1;               % Cdc20A
f=figure('Name','original_statevalues_');
plot(timeF, c*original_statevalues,'LineWidth',2);
legend('CycET', 'CycAT', 'CycBT', 'Cdc20A');
xlabel('time (h)'), ylabel('concentration (AU)')
fig=gcf;
ax=gca;

file_name       = [f.Name filename];%Directory name of the file
save_path       = [workpath,'/fig/',dirname '/' file_name '/' file_name '.tex'];

matlab2tikz(save_path,'standalone',true);     %Raw tex-file
matlab2tikz(['~/bwSyncAndShare/Masterarbeit/fig/',dirname '/' file_name '/' file_name '.tex'],'standalone',true);

%{
The purpose of this routine is to compute
the value of ... 
%}