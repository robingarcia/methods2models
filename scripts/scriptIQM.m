%% In this section the purpose of the script should be described.
% Purpose of activity:
%
% Required previous scripts to be run:
%
% Author: Robin Garcia Victoria
%
% Date: 08.11.2016
%

%% Installation of IQM Tools
% This block should always be on the top of every analysis script with IQM
% Tools. It might only be ommitted in the case that a central installation
% of IQM Tools is present on the computer system and the IQM Tools are
% automatically loaded during the startup of MATLAB.
clc;                        % Clear command window
clear all;                  % Clear workspace from all defined variables
close all;                  % Close all figures
fclose all;                 % Close all open files
restoredefaultpath();       % Clear all user installed toolboxes

% In the next line, please enter the path to your IQM Tools folder. It can
% be a relative or an absolute path.
PATH_IQM            = 'D:\IQM Tools Suite';
oldpath             = pwd(); cd(PATH_IQM); installIQMtoolsInitial; cd(oldpath);

%% "Initialize the compliance mode".
% IQM Tools allows to automatically generate logfiles for all output that
% is generated using the functions "IQMprintFigure" and
% "IQMwriteText2File". These logfiles contain the username, the name of the
% generated file (including the path), and the scripts and functions that
% have been called to generate the output file. In order to ensure this is
% working correctly, the only thing that needs to be done is to execute the
% following command at the start of each analysis script.

% The input argument to the "IQMinitializeCompliance" function needs to be
% the name of the script file.
IQMinitializeCompliance('TEMPLATE_SCRIPT_NAME');

%% Here your code starts
