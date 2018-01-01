function[pts_master,pts_aligned,H,dist]=RegTB(master,aligned,i,options,out_name)
if(i==1)
    tic
    fprintf('Function=MMI_MMR\n');
    pause(1);
    [pts_master,pts_aligned,dist] = RegMMI(master,aligned,options);
    dist=sqrt(dist);
    H=homography(pts_master,pts_aligned);
%     csvwrite('csvlist1.txt',H);
%     csvwrite('F:\UzairAzhar\IntelliGolf\geometric_alignment_images\new_test\csvlist_MMI.txt',H);
    
    %Calculating Ransac Points
    %     points_m = cornerPoints(pts_master);
    %     points_a = cornerPoints(pts_slave);
    %     [fundMatrx, inliers] = estimateFundamentalMatrix(points_m,points_a,'Method','RANSAC','NumTrials',2000,'DistanceThreshold',1e-4);
    %     pts_masterRansac=pts_master(inliers,:);
    %     pts_alignedRansac=pts_slave(inliers,:);
    toc
elseif(i==2)
    tic
    fprintf('Ftn=NormCorr_MMR\n');
    pause(1);
    [pts_master,pts_aligned,dist] = RegNormcorr(master,aligned,options);
    H=homography(pts_master,pts_aligned);
%     csvwrite('csvlist2.txt',H);
%     csvwrite(out_name,H);
    
    %Calculating Ransac Points
    %     points_m = cornerPoints(pts_master);
    %     points_a = cornerPoints(pts_slave);
    %     [fundMatrx, inliers] = estimateFundamentalMatrix(points_m,points_a,'Method','RANSAC','NumTrials',2000,'DistanceThreshold',1e-4);
    %     pts_masterRansac=pts_master(inliers,:);
    %     pts_alignedRansac=pts_slave(inliers,:);
    toc
elseif(i==3)
    tic
    fprintf('Ftn=Corr_MMR\n');
    pause(1);
    [pts_master,pts_aligned,dist] = RegCorr(master,aligned,options);
    H=homography(pts_master,pts_aligned);
%     csvwrite('csvlist3.txt',H);
    %Calculating Ransac Points
    %     points_m = cornerPoints(pts_master);
    %     points_a = cornerPoints(pts_slave);
    %     [fundMatrx, inliers] = estimateFundamentalMatrix(points_m,points_a,'Method','RANSAC','NumTrials',2000,'DistanceThreshold',1e-4);
    %     pts_masterRansac=pts_master(inliers,:);
    %     pts_alignedRansac=pts_slave(inliers,:);
    toc
else
    error('Invalid Metric Algorithm\n');
end

csvwrite(out_name,H);
end

function H=homography(pts_master,pts_aligned)
%Calculating Homogeneous Matrix
count =0;
% w and h is principal point of camera
% Transformed pt from red to master of our sequoia
% w=664.587013699377;
% h=485.807105336483;

w = 653.3341;
h = 454.7299;

if(size(pts_master,1)>=4)
    for i=1:size(pts_master,1)
        x1 = pts_aligned(i,1)-w;
        y1= pts_aligned(i,2)-h;
        x2 = pts_master(i,1)-w;
        y2= pts_master(i,2)-h;
        count=count+1;
        M1(count,:)=[-x1 -y1  -1 0  0  0  x1*x2  y1*x2 x2];
        count=count+1;
        M1(count,:)=[0, 0, 0, -x1, -y1, -1, x1*y2, y1*y2 y2];
    end
    [u,s,v]=svd(M1);
    H=reshape(v(:,end),3,3)';
    H=H/H(3,3);
    P=[10 10 1]';
    P2=H*P;
    P2=P2/P2(3)
    %Testing Homography matrix
%     M1_ = u*s*v';
%     dM = M1 - M1_;
%     max(dM(:))
%     s(9,9)
else H=0;
end


end