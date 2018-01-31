function [bd, idx] = matches(d, descs)
% matches Match feature descriptor with best candidate.
%
%   Given a feature descriptor and a set of possible candidates, choose a match 
%   based on a chosen set of criteria. If *no* matches are bound that are 
%   suitable, return NaN for the best descriptor.
%
%   Inputs:
%   -------
%    d      - mx1 descriptor to match.
%    descs  - mxn set of candidate descriptors to select against.
%
%   Outputs:
%   --------
%    bd   - mx1 best match from candidate set.
%    idx  - Index of match (column) in original descs array.

    descs_size = size(descs);
    min_err = 9999999999;
    %normalize feature
    y = normc(double(d));
    %get nearest neighbour
    for i = 1:descs_size(2)
        cand = normc(double(descs(:,i)));
        err = sum(y - cand);
        err = dot(err,err.');
        %get error
        if err < min_err
            min_err = err;
            idx = i;
            bd = descs(:,i);
        end
    end
    %if no suitable candidates return NaN
    if min_err > 0.001
        idx = NaN; 
    end
    [r,a] = matchFeatures(d.',descs.','MatchThreshold',4);
    if size(r) ~= 0
        idx = r(2);
    else
        idx = NaN;
    end
%     a=normc(double(descs));
%     
%     idx = knnsearch(a',b');
%     disp(idx)
%------------------
  
end
