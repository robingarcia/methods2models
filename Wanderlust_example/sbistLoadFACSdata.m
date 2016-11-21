function sbistExpData_obj = sbistLoadFACSdata(file,folder)

%% Function to load FACS Data into sbistExperimentData_obj
%
% The function reads the .cvs file (data export from IZI MACSQuant Analyzer)
% and then writes the data into the sbistExperimentData_obj.
% Data itself is stored in a hypercube with varying dimensions based on the
% number of Doses and experimental conditions. A describtion of these is
% also given in the struct. If experimental conditions and input doses are
% not given in one dataset of the xls sheetm, but in another then they are
% asumed to be 0 for inputs and 1 for experimental conditions, such as
% knockouts.
% The Data hypercube has the dimension:
% time - state - replicates - dose1 -...- doseN - condition1 -...- conditionN
% The hypercube therefor has at minimum 3 dimensions 

%
%% Usage
% -----------------------------
% Inputs:
% file      - .cvs file (MACSQuant Analyzer export)
% folder    - directory where the file is
% 
% Output:
% sbistExpData_obj
% -----------------------------
%% sbistExpData_obj = sbistLoadFACSdata(file,folder)
% 
% file = 'das2014-02-12_DAPI_Geminin.001_P1_P2.csv';
% folder = '/home/kk/Documents/PhD/PS_Fucci_TRAIL/Data/140213_Dani_FACS_ERA';

% Parse input
if folder(end)~=filesep
    folder(end+1) = filesep;
end


%% Load the file
folfile = [folder file];

% extract file info and get  name
[pathname,filename,~] = fileparts(folfile);

%% Find Metadata
% Create sbistExperimentData object
Exp = sbistExperimentData; 
Exp.name		= filename;
Exp.location	= pathname;
Exp.type		= 'FACS';
Exp.laboratory	= 'IZI';
Exp.notes		= strsplit(filename,'_');


% date
regStr			= '(19|20)\d\d([- /.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])';	% find string of the form: yyyy-mm-dd
[startIndex,endIndex] = regexp(filename,regStr,'start','end');
expdate			= filename(startIndex:endIndex);
Exp.date		= datestr(datenum(expdate,'yyyy-mm-dd'));

Exp.experimenter= filename(1:startIndex-1);


%% Import Data from FACS Readout file
% Reads the raw data from an FACS Experiment and create a
% struct with all information.
%% Read the data
delimiterIn = ';';
headerlinesIn = 21;
A = importdata(folfile,delimiterIn,headerlinesIn);


%% grap header info and write to details struct
rawhead = A.textdata(1:end-1);		% last cell has no information

% structnames
strucnameInds	= cellfun(@(x) strcmp(x(end),':'),rawhead);
strucnames		= rawhead(strucnameInds);
for i = 1:length(strucnames)
	strucnames{i} = strucnames{i}(1:end-1);
	strucnames{i}(strucnames{i} == ' ') = '_';
end

% struct data ~strucnamesInds
structdata = rawhead(~strucnameInds);
for i = 1:length(structdata)
	structdata{i} = strsplit(structdata{i},';');
	numdata = str2double(structdata{i});
	if ~all(isnan(numdata))
		structdata{i} = numdata;
	end	
end

expdetails = cell2struct(structdata,strucnames);

% details struct
Exp.measured_states = expdetails.Username;
Exp.rhs = Exp.measured_states;
Exp.details.header = expdetails;
Exp.details.conditions = {'time', 'measured_states', 'replicates'};
Exp.details.condition_values = {1,Exp.measured_states,1:size(A.data,1)};
Exp.details.cubedimensions = cellfun('length',Exp.details.condition_values);
dcube = A.data';
% Necessary as otherwise last singleton dimension gets lost
dcube = reshape(dcube,Exp.details.cubedimensions);
Exp.details.datacube = dcube;


% population 
Exp.population.type = 'population';
Exp.population.size = Exp.details.cubedimensions(end);

Exp = sbistGetUniqueExpConditions(Exp);
sbistExpData_obj = Exp;
