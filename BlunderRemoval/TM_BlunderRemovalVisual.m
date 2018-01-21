% This script loads all the transformation matrices of a dataset and
% applies the blunder removal algorithm
clear;clc

%% USER CONTROL
InputDir = 'D:\ImageRegisterationPaper\Datasets\RedStickGolfCourse_15122016\OutputS1';
MetricID = 1;

%% INITIALIZATION
Filelist = dir([InputDir '\' sprintf('*ET%d.csv',MetricID)]);
N = length(Filelist);
T = zeros(3,3,N);
mH = zeros(3,3);
for r = 1:N
    FileAddr = [InputDir '\' Filelist(r).name];
    T(:,:,r) = csvread(FileAddr);
end

%% ALGORITHM + VISUALIZATION
figure(1);
k=1;
for r = 1:2
    for c = 1:3
        subplot(230+k);        
        H = T(r,c,:);
        H = H(:);
        
        u1 = mean(H);
        s1 = std(H);
        LimUp1 = u1+s1;
        LimDn1 = u1-s1;
        
        GoodIdx = (H<LimUp1) & (H>LimDn1);
        u2 = mean(H(GoodIdx));
        mH(r,c) = u2;
        
        stem(H); hold on;
        line([1 N],[LimUp1 LimUp1],'Color','r'); hold on;
        line([1 N],[LimDn1 LimDn1],'Color','r'); hold on;
        line([1 N],[u2 u2],'Color','g'); hold on;
%         line([1 N],[LimDn2 LimDn2],'Color','g'); hold on;
        
        
        
        title(sprintf('H(%d,%d)',r,c));
        k = k+1;
    end
end


