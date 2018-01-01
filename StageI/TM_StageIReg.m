% This script serves as the top module for stage I registeration
clear;clc;
%% USER PARAMETERS
% 2nd test of golf course 
% DatasetDirMaster = 'D:\BurqData\IntelliGolf\Datasets\Second_test_of_GolfCourse\RAW';
% DatasetDirSlave = 'D:\BurqData\IntelliGolf\Datasets\Second_test_of_GolfCourse\RAW';
% Stage1OutputDirMaster = 'D:\BurqData\IntelliGolf\Datasets\Second_test_of_GolfCourse\OutputS1';
% Stage1OutputDirSlave = Stage1OutputDirMaster;

% Red Stick GolfCourse 15122016
DatasetDirMaster = 'D:\BurqData\IntelliGolf\Datasets\RedStickGolfCourse_15122016\RAW';
DatasetDirSlave = DatasetDirMaster;
Stage1OutputDirMaster = 'D:\BurqData\IntelliGolf\Datasets\RedStickGolfCourse_15122016\OutputS1';
Stage1OutputDirSlave = Stage1OutputDirMaster;


Handbag.Master.FocalLengthX = 3.98;   % mm - along x axis
Handbag.Master.FocalLengthY = 3.98;   % mm - along y axis
Handbag.Master.PPX = 2.490536;        % mm - X principal point 
Handbag.Master.PPY = 1.826803;        % mm - Y principal point 
Handbag.Master.CCDX = 4.8;            % mm - CCD width (along X)
Handbag.Master.CCDY = 3.6;            % mm - CCD height (along Y)
Handbag.Master.nPixelX = 1280;        % pixels - along X axis
Handbag.Master.nPixelY = 960;         % pixels - along Y axis
Handbag.Master.FisheyeAffineMat = [1665.575462527,0;0,1665.575462527];
Handbag.Master.FisheyePoly = [0,1,0.009255253,-0.143464052];
Handbag.Master.RigRelatives = [-0.0739133613702653,0.267927087194982,-0.14312233908997];

Handbag.Slave.FocalLengthX = 3.98;   % mm - along x axis
Handbag.Slave.FocalLengthY = 3.98;   % mm - along y axis
Handbag.Slave.PPX = 2.450003;        % mm - X principal point 
Handbag.Slave.PPY = 1.705237;        % mm - Y principal point 
Handbag.Slave.CCDX = 4.8;            % mm - CCD width (along X)
Handbag.Slave.CCDY = 3.6;            % mm - CCD height (along Y)
Handbag.Slave.nPixelX = 1280;        % pixels - along X axis
Handbag.Slave.nPixelY = 960;         % pixels - along Y axis
Handbag.Slave.FisheyeAffineMat = [1665.780696328,0,0,1665.780696328];
Handbag.Slave.FisheyePoly = [0,1,0.009290101,-0.145406216];
Handbag.Slave.RigRelatives = [-0.00243069504857684,0.291506824565826,-0.0380101692393319];


%% INITIALIZATION
FilelistMaster = dir([DatasetDirMaster '\*NIR*']);
FilelistSlave = dir([DatasetDirSlave '\*RED*']);

if length(FilelistMaster)~=length(FilelistSlave)
    error('unequal no. of master and slave images');
end

%% ALGORITHM

% for k=1:length(FilelistMaster)
for k = 1:1
    
    % READ THE IMAGE
    MasterImg = ReadImageS1([DatasetDirMaster '\' FilelistMaster(k).name]);
    SlaveImg = ReadImageS1([DatasetDirSlave '\' FilelistSlave(k).name]);
    
    % PROCESS IMAGES
    [MasterImgS1,SlaveImgS1] = StageIReg(MasterImg,SlaveImg,Handbag);
    
    % SAVE TO DISK
    WriteImageS1(MasterImgS1,Stage1OutputDirMaster,FilelistMaster(k).name,'_S1');
    WriteImageS1(SlaveImgS1,Stage1OutputDirSlave,FilelistSlave(k).name,'_S1');
    
    % UPDATE THE USER
    fprintf('%.0f%% done - %s processed\n',k/length(FilelistMaster)*100,FilelistSlave(k).name);
end


%% VISUALIZATION

