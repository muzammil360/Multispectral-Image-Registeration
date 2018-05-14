% This script takes a stage 2 MRR analysis report and computes all the necessary statistics to be reported for that MRR analysis.
clear;clc

%% USER CONTROL
InputFileAddr = 'D:\ImageRegisterationPaper\Datasets\RedStickGolfCourse_15122016\OutputS23_NCC-Com\MeanMRR_ElaspedTime_2.csv';


%% INITIALIZATION

%% ALGORITHM
data = csvread(InputFileAddr);
MMRR = data(:,1);
Time = data(:,2);

MMRR(MMRR==1600) = [];




%% OUTPUT

Mean = mean(MMRR)
Median = median(MMRR)
Mode = mode(MMRR)
Std = std(MMRR)
Min = min(MMRR)
Max = max(MMRR)
MeanTime = mean(Time)

stem(MMRR); title('MMRR plot');
figure(2);
stem(Time); title('Time Plot');
