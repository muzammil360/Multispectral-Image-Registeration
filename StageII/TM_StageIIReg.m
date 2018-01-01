% This script serves as the top module for stage II registeration
clear;clc;

%% USER PARAMETERS
InputDir = 'D:\BurqData\IntelliGolf\Datasets\RedStickGolfCourse_15122016\OutputS1';
StageIIRegOutputDir = 'D:\BurqData\IntelliGolf\Datasets\RedStickGolfCourse_15122016\OutputS21';
UseIndividualTransform = true;
CommonTransfromPath = '';
MetricID = 1;
OutputFileNameSuffix = '_S21';


%% INITIALIZATION
InputFilelist = dir([InputDir '\*RED*.mat']);
N = length(InputFilelist);


%% ALGORITHM
% for k = 1:N
for k = 1:1
    
    % READ THE IMAGE
    Img = ReadImageS2([InputDir '\' InputFilelist(k).name]);
    
    % GET APPROPRIATE TRANSFORM
    H = GetTransform(InputDir,InputFilelist(k).name,MetricID,UseIndividualTransform);
    
    % APPY REGISTERATION
    OutputImg = StageIIReg(Img,H);    
    
    % SAVE TO DISK
    WriteImageS1(OutputImg,StageIIRegOutputDir,InputFilelist(k).name,OutputFileNameSuffix);
   
    % UPDATE THE USER
    fprintf('%.0f%% done - %s processed\n',k/N*100,InputFilelist(k).name);

end



%% VISUALIZATION





