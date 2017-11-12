%% m2m_init
if exist('config.mat','file')==0
    m2m_config
else
    load config.mat
end
