function Output = ReadImageS1(ImagePath)
% This function reads the tif image from disk and converts it to double
%
% INPUT
% ImagePath:        path of image to be read
%
% OUTPUT
% Output:           output image

Output = im2double(imread(ImagePath));

end