% This script takes a stage 2 MRR analysis report and computes all the necessary statistics to be reported for that MRR analysis.
clear;clc

%% USER CONTROL
InputFileAddr = 'D:\ImageRegisterationPaper\Datasets\RedStickGolfCourse_15122016\OutputS22\MeanMRR_ElaspedTime_1.csv';


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
