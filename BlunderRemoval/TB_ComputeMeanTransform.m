% This script computes mean transform a bunch of transforms
clear;clc


%% USER CONTROL
InputDir = 'D:\ImageRegisterationPaper\Datasets\RedStickGolfCourse_15122016\OutputS22_NCC-Com';
MetricID = 2;
MinInThres = 0.7;
OutputFileName = ['MeanET' num2str(MetricID) '.csv'];

%% INITIALIZATION
Filelist = dir([InputDir '\' sprintf('*ET%d.csv',MetricID)]);
N = length(Filelist);
T = zeros(3,3,N);
mH = zeros(3,3);
ImgNo = zeros(N,1);
for r = 1:N
    FileAddr = [InputDir '\' Filelist(r).name];
    T(:,:,r) = csvread(FileAddr);
    ImgNo(r) = str2double(Filelist(r).name(19:22));
end

%% ALGORITHM
[OutT,Flag,InlierFrac,GoodIdx] = ComputeMeanTransform(T,MinInThres);

%% VISUALIZATION

T13 = reshape(T(1,3,:),[],1);
T23 = reshape(T(2,3,:),[],1);



subplot(211);
stem(ImgNo,[T13 50*GoodIdx']);
title('T13 with Good T');
legend('T13','isSelected');
ylim([-15 15]);

subplot(212);
stem(ImgNo,[T23 50*GoodIdx']);
title('T23 with Good T');
legend('T23','isSelected');
ylim([-15 15]);

InlierFrac


% write to disk
if (Flag == true)
    OutputFileAddr = [InputDir '\' OutputFileName];
    csvwrite(OutputFileAddr,OutT);
end