function [MasterImgS1,SlaveImgS1] = StageIReg(MasterImg,SlaveImg,Handbag)
% function [MasterImgS1,SlaveImg] = StageIReg(MasterImg,SlaveImg,Handbag)
% This function performs the stage I geometric registeration
%
% INPUT: 
% MasterImg:        input master(fixed) image
% SlaveImg:         input slave(moving) image
% Handbag:          structure holding params for processing
%
% OUTPUT:
% MasterImgS1:      Stage I output of master image
% SlaveImgS1:       Stage I output of slave image


% GET CAMERA MATRIX
PixelRes = Handbag.Master.nPixelX/Handbag.Master.CCDX;
Handbag.Master.PPX = Handbag.Master.PPX * PixelRes;
Handbag.Master.PPY = Handbag.Master.PPY * PixelRes;
Handbag.Slave.PPX = Handbag.Slave.PPX * PixelRes;
Handbag.Slave.PPY = Handbag.Slave.PPY * PixelRes;

[Sm,Fm]=GetCameraMatrix(Handbag.Master.FocalLengthX ,PixelRes,Handbag.Master.PPX,Handbag.Master.PPY);
[Ss,Fs]=GetCameraMatrix(Handbag.Slave.FocalLengthX ,PixelRes,Handbag.Slave.PPX,Handbag.Slave.PPY);
Km = Sm*Fm;
Ks = Ss*Fs;

% GET PROJECTION ON MOVING SPACE
[Pm,X,Y] = GetRectPixelVec(Handbag.Slave.nPixelX,Handbag.Slave.nPixelY);
Ps = GetProjectionOnSlaveSpace(Pm,Sm,Ss,Fs,Handbag);

% GET PROJECTION ON DISTORTED SPACE
Psd = GetProjectionOnDistortedSpace(Ps,Handbag.Slave.FisheyePoly,...
    Handbag.Slave.FisheyeAffineMat,Ks,...
    Handbag.Slave.PPX, Handbag.Slave.PPY);
Pmd = GetProjectionOnDistortedSpace(Pm,Handbag.Master.FisheyePoly,...
    Handbag.Master.FisheyeAffineMat,Km,...
    Handbag.Master.PPX, Handbag.Master.PPY);

% PREP MAP 4 REMAP
[PsdX,PsdY] = PrepMap4Remap(Psd,Handbag.Slave.nPixelX,Handbag.Slave.nPixelY);
[PmdX,PmdY] = PrepMap4Remap(Pmd,Handbag.Master.nPixelX,Handbag.Master.nPixelY);

% REMAP
SlaveImgS1 = interp2(X,Y,SlaveImg,PsdX,PsdY);
MasterImgS1 = interp2(X,Y,MasterImg,PmdX,PmdY);

end


function [S,F]=GetCameraMatrix(FocalLength,PixelRes,PPX,PPY)
% function [S,F]=GetCameraMatrix(Handbag)
% This function computes the camera matrices
%
% INPUTS:
% FocalLength:      focal length of camera (mm)
% PixelRes:         pixels per unit length of film (Pixel/mm)
% PPX:              principal point x-axis (pixel)
% PPY:              principal point y-axis (pixel)
%
% OUTPUTS:
% S:                real world coordinate to pixel coordinate transformation
% F:                pinhole camera model transformation

F = [FocalLength, 0, 0
    0, FocalLength, 0
    0, 0, 1];
S = [PixelRes, 0, PPX
    0, PixelRes, PPY
    0, 0, 1];

end


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

function Ps = GetProjectionOnSlaveSpace(Pm,Sm,Ss,Fs,Handbag)
% function Ps = GetProjectionOnSlaveSpace(Pm)
% This function converts points from master space to slave
% space
% Unit of points is pixels
% 
% INPUTS:
% Pm:           Output of GetRectPixelVec() function
% Sm:           S matrix of master camera
% Ss:           S matrix of slave camera
% Fs:           F matrix of slave camera
% Handbag: structure holding params for processing
%
% OUTPUTS:
% Ps:          correspoing slave space points (pixel coor)


% Convert pixel to mm space
% pm = inv(Sm)*Pm;
pm = Sm\Pm;             % Sm\Pm is equivalent to inv(Sm)*Pm

% Take image plane to z=f
pm(3,:) = Handbag.Master.FocalLengthX;

% Transfer to moving (slave) space
RotVec = Handbag.Slave.RigRelatives- Handbag.Master.RigRelatives;
R = RotationVector2Matrix(RotVec);
ps = Fs*R*pm;

% Project points on z=1
coef = ps(3,:);
ps = ps./repmat(coef,3,1);

% Convert mm to pixel space
Ps = Ss*ps;

end

function RotMatrix = RotationVector2Matrix(Theta)
% function RotMatrix = RotationVector2Matrix(Theta)
% This function converts a rotation vector to a matrix
% INPUTS
% Theta:            3 element vector containing rotation about x,y,z respectively
%
% OUTPUTS:
% RotMatrix:        Rotation matrix

xTheta = Theta(1);
yTheta = Theta(2);
zTheta = Theta(3);


Rx= [1,0,0 
    0, cosd(xTheta), -sind(xTheta) 
    0, sind(xTheta), cosd(xTheta)];
Ry= [cosd(yTheta), 0, sind(yTheta) 
    0, 1,0
    -sind(yTheta), 0, cosd(yTheta)];
Rz= [cosd(zTheta), -sind(zTheta), 0 
    sind(zTheta), cosd(zTheta), 0 
    0,0,1];

RotMatrix = Rx*Ry*Rz;
end

function PDistorted = GetProjectionOnDistortedSpace(P,DistCoff,AffineMat,CameraMatK,PPX,PPY)
% function PDistorted = GetProjectionOnDistortedSpace(P,DistCoff,AffineMat,CameraMatK,PPX,PPY)
% This function projects points from linear space to distored space
% INPUTS
% P:                points in linear space
% DistCof:          fisheye distortion coefficients 
% AffineMat:        fisheye affine matrix
% CameraMatK:       camera matrix K
% PPX:              principal point x-axis (pixel)
% PPY:              principal point y-axis (pixel)
%
% OUTPUTS
% PDistorted:       points projected on distorted space

p0 = DistCoff(1);
p1 = DistCoff(2);
p2 = DistCoff(3);
p3 = DistCoff(4);

% convert to normalized real world coordinates (z=1);
p = CameraMatK\P;            % p=inv(K)*P;

X = p(1,:);
Y = p(2,:);

X2 = X.^2;
Y2 = Y.^2;

sum = X2+Y2;

r = sqrt(sum);

theta = (2 / pi) * atan(r);

row = p0 + p1*theta + p2*(theta.^2) + p3*(theta.^3);

tmp = row./r;

Xh = X.*tmp;
Yh = Y.*tmp;

C = AffineMat(1);
D = AffineMat(3);
E = AffineMat(2);
F = AffineMat(4);

Xd = C*Xh + D*Yh + PPX;
Yd = E*Xh + F*Yh + PPY;

PDistorted = [Xd;
    Yd;
    ones(size(Xd))];

end



function [XMap,YMap] = PrepMap4Remap(P,Width,Height)
% function [XMap,YMap] = PrepMap4Remap(P)
% This function separates X and Y maps from P
% INPUTS
% P:                3-by-(width*height) matrix containing x and y map
% Width:            width of image
% Height:           height of image
%
% OUTPUTS:
% XMap:             X map in P
% YMap: Y map in P
%
% Note: For info on XMap and YMap, please see "Geometric Image Transformations" of opencv
% documentation 


xVec = P(1,:)';
yVec = P(2,:)';

XMap =reshape(xVec,Height,Width);
YMap =reshape(yVec,Height,Width);

end