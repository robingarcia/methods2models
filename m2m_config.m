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
domail = input('Do you want notification mails [0=no]:');
if domail 
    mail = input('Mail adress:');
    password = input('Password:');
    server = input('SMTP server:');
    mail_username = input('SMTP username:');
    setpref('Internet','E_mail',mail);
    setpref('Internet','SMTP_Server',server);
    setpref('Internet','SMTP_Username',mail_username);
    setpref('Internet','SMTP_Password',password);
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.starttls.enable', 'true' );
    props.setProperty('mail.smtp.socketFactory.port','587');
    sendmail(mail,'Msg from m2m toolbox','Success!');
else
    save('config.mat', 'username','workpath','storepath','-v7.3');
end