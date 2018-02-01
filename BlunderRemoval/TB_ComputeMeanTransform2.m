% This script computes mean transform a bunch of transforms
clear;clc


%% USER CONTROL
InputDir1 = 'D:\ImageRegisterationPaper\Datasets\RedStickGolfCourse_15122016\OutputS1';
InputDir2 = 'D:\ImageRegisterationPaper\Datasets\RedStickGolfCourse_15122016\OutputS21';
InputDir3 = 'D:\ImageRegisterationPaper\Datasets\RedStickGolfCourse_15122016\OutputS22';

InputDir = {InputDir1, InputDir2, InputDir3};

MetricID = 1;
MinInThres = 0.7;

OutputFileAddr = 'D:\ImageRegisterationPaper\Datasets\RedStickGolfCourse_15122016\CommonTransforms';
OutputFileName = ['MeanET_S1S21S22_' num2str(MetricID) '.csv'];


%% INITIALIZATION
m = length(InputDir);
FilelistBag = cell(1,m);
FilelistLenVec = zeros(1,m);
for k=1:m
    path = [InputDir{k} '\' sprintf('*_ET%d.csv',MetricID)];
    Filelist = dir(path);
    FilelistLenVec(k) = length(Filelist);
    FilelistBag{k} = Filelist;
end

if (sum(diff(FilelistLenVec))~=0)
    errordlg('Some H in atleast 1 input folder is missing');
end

N = FilelistLenVec(1);

T = zeros(3,3,N);

ImgNo = zeros(N,1);
for r = 1:N
    FileAddr = [InputDir '\' Filelist(r).name];
    T(:,:,r) = csvread(FileAddr);
    ImgNo(r) = str2double(Filelist(r).name(19:22));
end

%% ALGORITHM

%% VISUALIZATION




%% Words
- get H file list for each of the stage
- make sure each stage has equal number of files.
- for each image, read H from all stages and get them multiplied
