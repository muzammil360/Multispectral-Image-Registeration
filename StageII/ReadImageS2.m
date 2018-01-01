function OutImage = ReadImageS2(MatFilename)
% function Image = ReadImageS2(Filename) reads the image data from the mat
% file address
%
% INPUT
% MatFilename:              input image data file name 
%
% OUTPUT
% OutImage:                    image matrix


load(MatFilename);
OutImage = Image;


end