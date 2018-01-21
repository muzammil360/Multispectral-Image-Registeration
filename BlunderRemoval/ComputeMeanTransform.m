function [OutputT,Flag,InlierFrac,GoodIdx] = ComputeMeanTransform(InputT,MinInThres)
% function [OutputT,Flag] = ComputeMeanTransform(InputT,MinInThres) takes 
% in a list of transforms and returns the mean transform after applying 
% blunder removal algorithm

N = size(InputT,3);
Data = reshape(InputT,[],N);

GoodIdx = true(1,N);
iter = 0;

while(true)  % loop breaks on condition below making it dowhile
    Z = zscore(Data(:,GoodIdx),[],2);
    
    NewGoodIdx = all(abs(Z)<1);
    ENewGoodIdx = true(size(GoodIdx));
    ENewGoodIdx(GoodIdx) = NewGoodIdx;
    
    iter = iter+1;
    fprintf('Iteration: %d\n',iter);
    GoodIdx = GoodIdx & ENewGoodIdx;
    % WARNING: DUE TO LINE ABOVE, THE PROGRAM WILL RUN FOR ONLY 1 ITERATION 
    
    if (sum(NewGoodIdx) == sum(GoodIdx))
    break;
    end
    

end


InlierFrac = sum(GoodIdx)/N;

if InlierFrac >= MinInThres
    OutputT = mean(InputT(:,:,GoodIdx),3);
    Flag = true;
else
    OutputT = zeros(3);
    Flag = false;
end

end