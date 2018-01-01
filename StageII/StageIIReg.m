function OutputImg = StageIIReg(InputImg,H)

    % GET ALL PIXEL LOCATIONS
    ImgWidth = size(InputImg,2);
    ImgHeight = size(InputImg,1);
    
    [X,Y]=meshgrid(1:ImgWidth,1:ImgHeight);
    P = [X(:) Y(:) ones(ImgWidth*ImgHeight,1)]';
    
    % TRANSFORM ALL PIXEL LOCATIONS
	Pt = H\P;               % equivalent to inv(H)*P
    Pt = Pt./repmat(Pt(3,:),3,1);
    
    % PREP FOR INTERP2
    xVec = Pt(1,:)';
    yVec = Pt(2,:)';
    
    XMap =reshape(xVec,ImgHeight,ImgWidth);
    YMap =reshape(yVec,ImgHeight,ImgWidth);
    
    OutputImg = interp2(X,Y,InputImg,XMap,YMap);
    
end

