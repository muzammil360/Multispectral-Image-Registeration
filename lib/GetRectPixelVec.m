function [P,X,Y] = GetRectPixelVec(Width,Height)
% function P = GetRectPixelVec(Width,Height)
% This function returns all the pixel coordinates. Each column vector is
% [x,y,1]'
%
% INPUTS:
% Width:            width of image
% Height:           height of image
%
% OUTPUTS:
% P:                3-by-(width*height) matrix with each column as pixel coordinate
% X:                X coordinate in meshgrid format
% Y:                Y coordinate in meshgrid format
[X,Y]=meshgrid(0:Width-1,0:Height-1);
P = [X(:) Y(:) ones(Width*Height,1)]';

end