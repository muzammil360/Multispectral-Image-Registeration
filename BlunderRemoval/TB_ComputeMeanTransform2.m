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

T = zeros(3,3,N,m);
ImgNo = zeros(N,m);

for i = 1:m
    Filelist = FilelistBag{i};
    for r = 1:N
        FileAddr = [InputDir{i} '\' Filelist(r).name];
        T(:,:,r,i) = csvread(FileAddr);
        ImgNo(r,i) = str2double(Filelist(r).name(19:22));
    end
end

if (sum(sum(ImgNo - repmat(ImgNo(:,1),1,3)))~=0)
    errordlg('Image numbers do not match up properly');
end

%% ALGORITHM
FlagAll = false(1,m);
InlierFracAll = zeros(1,m);
GoodIdxAll = false(N,m);

for i = 1:m
    [OutT,Flag,InlierFrac,GoodIdx] = ComputeMeanTransform(T(:,:,:,i),MinInThres);
    FlagAll(i) = Flag;
    InlierFracAll(i) = InlierFrac;
    GoodIdxAll(:,i) = GoodIdx';
end

GoodIdx = all(GoodIdxAll,2);
InlierFrac = sum(GoodIdx)/length(GoodIdx);


H = zeros(3,3,sum(GoodIdx));
idx = 1:N;
idx = idx(GoodIdx);
iter = 1;

for r = idx
   H_temp = eye(3);
   
   for i = 1:m
       H_temp = T(:,:,r,i)*H_temp;
   end
    H(:,:,iter) = H_temp;
    iter = iter+1;
end


if InlierFrac >= MinInThres
    OutputT = mean(H,3);
    Flag = true;
else
    OutputT = zeros(3);
    Flag = false;
end


%% VISUALIZATION
% write to disk
if (Flag == true)
    OutputFileAddr = [OutputFileAddr '\' OutputFileName];
    csvwrite(OutputFileAddr,OutT);
end



