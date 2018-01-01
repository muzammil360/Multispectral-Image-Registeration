function WriteImageS1(Image,Directory,Filename,Suffix)
% This function write the output image and image data to disk
%
% INPUT
% Image:            input image to be written 
% Directory:        directory to be written to 
% Filename:         original filename
% Suffix:           suffix to be appended to filename before extension
% 
% OUTPUT
% <none> 

Filepath1 = [Directory '\' Filename(1:end-4) Suffix '.TIF'];
imwrite(Image,Filepath1);

Filepath2 = [Directory '\' Filename(1:end-4) Suffix '.mat'];
save(Filepath2,'Image');


end