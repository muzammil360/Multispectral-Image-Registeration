function [pts_master,pts_aligned,dist]=RegMMI(master,slave,options)

master=im2double(master);
slave=im2double(slave);
master_points1= detectSURFFeatures(master);
pt=master_points1.selectStrongest(options.maxPt);
options.templateSze=51;
options.fieldSze=59;
if(mod(options.templateSze,2)==0 )% iseven
    d1=options.templateSze/2;
elseif( mod(options.templateSze,2)==1) % isodd
    d1= (options.templateSze-1)/2;
end
if(mod(round(options.fieldSze),2)==0) % iseven
    d2=options.fieldSze/2;
elseif (mod(round(options.fieldSze),2)==1) % isodd
    d2= (options.fieldSze-1)/2;
end

count=1;
min_val=0;
pts_aligned=0;
pts_master=0;
dist=0;
nPt = pt.length();
for i=1:pt.length()
    
    
    current_loc= pt(i);
    x_orig=round(current_loc.Location(1));
    y_orig=round(current_loc.Location(2));
    %% for single image testing
    % y_orig = 344;
    % x_orig=315;
    if( (y_orig-d2-1)>0&& (x_orig-d2-1)>0&&(y_orig+d2+1)<size(master,1)&& (x_orig+d2+1)<size(master,2))
        
        
        
        %% Initialization
        p=[y_orig x_orig];
        temp = master(p(1)-d1: p(1)+d1,p(2)-d1:p(2)+d1);
        field = slave(p(1)-d2: p(1)+d2,p(2)-d2:p(2)+d2);
        
        %% Algorithm
        %         tic
        map = MMImap(temp,field);
        %         toc
        [~,ind]=min(map(:));
        x1 = ceil(ind/size(map,1));
        y1 = rem(ind,size(map,2));
        y_new = (y1-1)+p(1)-(d2-d1);
        x_new = (x1-1)+p(2)-(d2-d1);
        
        dist_sq = (x_orig-x_new).^2 + (y_orig-y_new).^2;
        %set distance to 18 for geometric alignment
        if (dist_sq<options.distance)
            pts_aligned(count,1)=x_new;
            pts_aligned(count,2)=y_new;
            pts_master(count,1)=x_orig;
            pts_master(count,2)=y_orig;
            dist(count,1)=dist_sq;
            count=count+1;
        end
        
        %%                        Visualization
        %         figure(1); imshow(nir); title('Master');
        %         hold on; plot(p(2),p(1),'r*'); ax1 = gca;
        %         figure(2); imshow(red); title('Slave');
        %         hold on; plot(p(2),p(1),'r*'); ax2 = gca;
        %         hold on; plot(x_new,y_new,'g*');
        %         linkaxes([ax1 ax2]);
        %         figure(3); imshow(temp); title('Template')
        %         figure(4); imshow(field); title('Field');
        %         figure(6); mesh(map); colorbar;
        %         pause();
        
    end
    %     fprintf('%d/%d - %0.2f%% completed\n',i,nPt,i/nPt*100);
end
dist=mean(dist);
end

function map = MMImap(temp,field)
[m, n] = size(temp);
[p, q] = size(field);
map = zeros(p-m+1,q-n+1);
I1 = temp;
for x = 0:(q-n)
    for y = 0:(p-m)
        I2 = field((1:m)+y,(1:n)+x);
        f = cal_mi(I1,I2);
        map(y+1,x+1) = f;
    end
end
end

function f = cal_mi(I1,I2)
size1 = size(I1);
size2 = size(I2);
if  ne(size1,size2)
    error('Size of input not same');
end
I1 = round(I1(:)*255)+1;
I2 = round(I2(:)*255)+1;
ht = accumarray([I1 I2],1);
ht = ht/length(I1);  % normalized joint histogram
ym = sum(ht );       % sum of the rows of normalized joint histogram
xm = sum(ht,2);       % sum of columns of normalized joint histogran
Hy   =      sum(ym.*log2(ym+(ym==0)));
Hx   =      sum(xm.*log2(xm+(xm==0)));
h_xy =  sum(sum(ht.*log2(ht+(ht==0)))); % joint entropy
f = -(Hx+Hy)/h_xy;   % Mutual information
end