%% Config file for external users
% Here you should type in some specific information for your needs like paths
disp('#####################################')
disp('Welcome to m2m toolbox configuration.')
disp('#####################################')
username = input('Your username [johndoe]:');
if isempty(username)
   username = 'johndoe';
else
end
workpath = input('Toolbox location? (e.g: ~/path/to/your/toolbox)');
storepath = input('Storage location? (e.g: ~/path/to/your/store)');
cd(storepath);
% username = input('Your username [johndoe]:');

mkdir(['m2mresults_' username]);
cd(['m2mresults_' username]);
mkdir input;
mkdir output;
cd(workpath);
save('config.mat', 'username','workpath','storepath','-v7.3');