function H = GetTransform(Dir,FileName,MetricID,UseIndividualTransform)
% function H = GetTransform(Dir,FileName,UseIndividualTransform)
% This function returns the transformation matrix to be applied. 
%
% INPUT
% Dir:              input dataset directory/input common T address
% FileName:         relevent image name to be transformed
% MetricID:         metric id of metric used to estimate transform
% UseIndividualTransform:   decision flag (function returns individual transform if true)
%
% OUTPUT
% H:                3x3 transformation matrix
% 


if (UseIndividualTransform == true)        
    FileAddr = [Dir '\' FileName(1:end-4) '_ET' num2str(MetricID) '.csv'];
    H = csvread(FileAddr);
elseif (UseIndividualTransform == false)
%     FileAddr = [Dir '\' 'MeanET' num2str(MetricID) '.csv'];
    FileAddr = Dir;
    H = csvread(FileAddr);
else
    errordlg('Error: Invalid UseIndividualTransform param ')
end

end