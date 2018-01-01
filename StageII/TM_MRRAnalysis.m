% This script serves as the top module for MRR Analysis
clear;clc;

%% USER PARAMETERS
MetricID = 1;               % MMI (1), NCCR (2), Corr(3)
Scale = 25;             % max MRR vector length is 50 pixels

DatasetDirMaster = 'D:\BurqData\IntelliGolf\Datasets\RedStickGolfCourse_15122016\OutputS1';
DatasetDirSlave = DatasetDirMaster;
MRROutputDir = DatasetDirMaster;


options.distance=13;
options.scale=1;
options.templateSze=19;
options.fieldSze=((options.templateSze-1)/2*3-1);
options.medFilt=1;
options.maxPt=1500;
options.corrThreshold=0.8;



%% INITIALIZATION
FilelistMaster = dir([DatasetDirMaster '\*NIR*.mat']);
FilelistSlave = dir([DatasetDirSlave '\*RED*.mat']);

if length(FilelistMaster)~=length(FilelistSlave)
    error('unequal no. of master and slave images');
end
N = length(FilelistMaster);

ElaspedTime = zeros(N,1);
MeanMRR = zeros(N,1);

%% ALGORITHM
for k = 1:N
    
    % READ THE IMAGE
    MasterImg = ReadImageS2([DatasetDirMaster '\' FilelistMaster(k).name]);
    SlaveImg = ReadImageS2([DatasetDirSlave '\' FilelistSlave(k).name]);

    % PROCESS IMAGES
    OutFileName = GetMRRAnalysisOutputFileNames(DatasetDirSlave,FilelistSlave(k).name,MetricID);
    tic
    [PtsMaster,PtsSlave,H,dist]=RegTB(MasterImg,SlaveImg,MetricID,options,OutFileName.ET);
    ElaspedTime(k) = toc;

    %% VISUALIZATION
    % PLOT/SAVE MRR TO DISK
    MeanMRR(k) = VisualizeMRR(PtsMaster,PtsSlave,Scale,OutFileName);
    
    % UPDATE THE USER
    fprintf('%.0f%% done - %s processed\n',k/N*100,FilelistSlave(k).name);    

end

% SAVE TIME ON DISK
csvwrite(sprintf('%s\\%s_%d.csv',MRROutputDir,'MeanMRR_ElaspedTime',MetricID)...
    ,[MeanMRR ElaspedTime]);



