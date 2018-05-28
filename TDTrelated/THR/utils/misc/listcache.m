function [L, CFN]=listcache(CFN);
% listcache - paramlist for cache file. Helper file for putcache & getcache.
%   Usage: [L, CFN]=listcache(CFN)

CFN = fullfile(CFN, tempdir, 'ncache');
if ~exist(CFN,'file'), 
    L = []; 
else,
    L = load('-mat', CFN, 'ParamList');
    L = L.ParamList;
end











