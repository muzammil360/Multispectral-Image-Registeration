function MeanMRR = VisualizeMRR(PtsMaster,PtsSlave,Scale,OutFileName)
% function VisualizeMRR(PtsMaster,PtsSlave,OutFileName)
% This function plots and saves the MRR to disk. This also saves the raw points to disk
%
% INPUTS
% PtsMaster:            nx2 matrix containing pixel location in master image
% PtsSlave:             nx2 matrix containing matched pixel location in slave image
% Scale:                each MRR vector can be scaled to improve visualization
% OutFileName:          structure containing output file names 
%
% OUTPUTS
% MeanMRR:              mean distance between matched pixel locations 
%

% If MMI fails to find any matching point at all, then force the values for
% the sake of program continuity
if (length(PtsMaster)==1 && length(PtsSlave)==1)
    PtsMaster = [0 0];
    PtsSlave = [960 1280];
end

x1 = PtsSlave(:,1);
y1 = PtsSlave(:,2);
x2 = PtsMaster(:,1);
y2 = PtsMaster(:,2);

dx = x1 - x2;
dy = y1 - y2;

r = sqrt(dx.^2 + dy.^2);

% scale = MaxVecLen/max(r);
dx1 = dx*Scale;
dy1 = dy*Scale;

MeanMRR = mean(r);

quiver(x2,y2,dx1,dy1,'AutoScale','off');
ax=gca;
ax.YDir = 'reverse';
ax.YLim=[1 960];            % height of our image is 960
ax.XLim=[1 1280];           % width of our image is 1280

print(gcf,OutFileName.MRRPLot,'-dpdf','-bestfit');

% Write output to disk
csvwrite(OutFileName.MRRPts,[PtsMaster PtsSlave]);

end