function [ihit, CFN, L]=matchcache(CFN,Param);
% matchcache - paramlist for cache file. Helper file for putcache & getcache.
%   Usage:
%      [ihit, CFN, List]=matchcache(CFN,Param)
%      [ihit, CFN, List]=matchcache(CFN) : return oldest entry

ihit = []; % default: no hit
L = []; % def: nothing stored
CFN = fullfilename(CFN, tempdir, 'ncache');
if exist(CFN,'file'),
    L = load('-mat', CFN, 'ParamList');
    L = L.ParamList;
    N = numel(L);
    if nargin<2, % return oldest entry
        [dum, ihit] = min([L.time]);
    else, % find match w Param
        for ii=1:length(L),
            if isequalwithequalnans(Param, L(ii).Param),
                ihit = ii;
                break;
            end
        end
    end
end











