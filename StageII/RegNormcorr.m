function [pts_master, pts_aligned,dist] = RegNormcorr( master,aligned,options)%align,corr_val,scale )

%%
%setting templates window size
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
scale=options.scale;
%---------------Selecting points through harris corner detection-----------
manual=0;
master_points1= detectSURFFeatures(master);
master_points1=master_points1.selectStrongest(options.maxPt);
%%                      Main pipeline

count=1;
max_normed=0;
pts_aligned=0;
pts_master=0;
dist=0;
for i=1:master_points1.size%pts_array_size
    if(manual==1)
        x_cood=110 ;
        y_cood=574;
        diff_val=500;
    else
        diff_val=5;
        current_loc= master_points1(i);
        x_cood=current_loc.Location(1);
        y_cood=current_loc.Location(2);
    end
    if(((x_cood-d1) >= 0) &&  ((y_cood-d1) >= 0) && ((x_cood+d1) < 1280) && ((y_cood+d1) < 960))
        [ref_template,rect1] = imcrop(master,[x_cood-d1 y_cood-d1 d1*2 d1*2]);
        
        if(((x_cood-d2) >= 0) &&  ((y_cood-d2) >= 0) && ((x_cood+d2) < 1280) && ((y_cood+d2) < 960))
            [search_template,rect2] = imcrop(aligned,[x_cood-d2 y_cood-d2 d2*2 d2*2]);
            
            %%                    Notes to calculate aligned point below
            %            1) xpeak and ypeak are the peak values found through corr.
            %            2) then template_sze_master is subtracted to remove correlation padding.
            %            3) padding size=(size of template from master image-1)/2
            %            4) afterwards cood are translated back to aligned image coordinate frame
            %               by adding (x or y)_cood-tmplate_sze_alit from master image to be found in aligned image
            %            6) Afterwards -1 is subtracted from the rgned which is starting point of search template image
            %            5) x_cood or y_cood is coordinates of poinesultant value from above steps to move one step
            %               back in rows and cols as because of above steps you land on first cood location in search
            %               template image
            %
            %% upsampling
            ref_template=imresize(ref_template,scale*size(ref_template)-(scale-1),'Method','bicubic');
            search_template=imresize(search_template,scale*size(search_template)-(scale-1),'Method','bicubic');
            %% To search master template in search template image
           
            if(mean2(ref_template)==ref_template(1,1))
                continue;
            end
            normed=normxcorr2(ref_template,search_template);
            if(max(normed(:))>options.corrThreshold)
                [ypeak, xpeak] = find(normed==max(normed(:)));
                aligned_x_cood=(xpeak(1)+(scale-1))/scale+x_cood-d2-d1-1;
                aligned_y_cood=(ypeak(1)+(scale-1))/scale+y_cood-d2-d1-1;
                
                %% Main Pipeline
                dist_sq = (x_cood-aligned_x_cood).^2 + (y_cood-aligned_y_cood).^2;
                %set distance to 18 for geometric alignment
                if (dist_sq<options.distance && x_cood>0&& aligned_x_cood>0&& y_cood>0&& aligned_y_cood>0)% Select pts only with 1 pxl diff
                    max_normed(count)=max(normed(:));
                    pts_aligned(count,1)=aligned_x_cood;
                    pts_aligned(count,2)=aligned_y_cood;
                    pts_master(count,1)=x_cood;
                    pts_master(count,2)=y_cood;
                     dist(count,1)=dist_sq;
                    count=count+1;
                    
                end
                
            end
        end
    end
    %     fprintf('%d/%d - %0.2f%% completed\n',i, size(master_points1,1),i/ size(master_points1,1)*100);
end
dist=mean(dist);
end

