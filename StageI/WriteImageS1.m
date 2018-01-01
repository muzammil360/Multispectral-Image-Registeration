function WriteImageS1(Image,Directory,Filename,Suffix)
% This function write the output image to disk
%
% INPUT
% Image:            input image to be written 
% Directory:        directory to be written to 
% Filename:         original filename
% Suffix:           suffix to be appended to filename before extension
% 
% OUTPUT
% <none> 

Filepath = [Directory '\' Filename(1:end-4) Suffix '.TIF'];
imwrite(Image,Filepath);

% TiffObj = Tiff(Filepath,'w');

% tagstruct.ImageLength = size(Image,1);

% TiffObj.setTag(tagstruct)
% TiffObj.write(Image);
% TiffObj.close();
end