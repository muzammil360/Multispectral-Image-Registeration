function OutputImg = StageIIReg(InputImg,H,PrincipalPoint)

    % GET ALL PIXEL LOCATIONS
    ImgWidth = size(InputImg,2);
    ImgHeight = size(InputImg,1);
    
    [X,Y]=meshgrid(1:ImgWidth,1:ImgHeight);
    Xc = X - PrincipalPoint(1);          % Shift origin to principal point 
    Yc = Y - PrincipalPoint(2);
    
    P = [Xc(:) Yc(:) ones(ImgWidth*ImgHeight,1)]';
    
    % TRANSFORM ALL PIXEL LOCATIONS
	Pt = H\P;               % equivalent to inv(H)*P
    Pt = Pt./repmat(Pt(3,:),3,1);
    
    % PREP FOR INTERP2
    xVec = Pt(1,:)';
    yVec = Pt(2,:)';
    
    XMap =reshape(xVec,ImgHeight,ImgWidth);
    YMap =reshape(yVec,ImgHeight,ImgWidth);
    
    XMap = XMap + PrincipalPoint(1);    % Shift origin to back to top left
    YMap = YMap + PrincipalPoint(2);
        
    OutputImg = interp2(X,Y,InputImg,XMap,YMap);
    
end

