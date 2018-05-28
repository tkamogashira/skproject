function se = StrMat2Nstr(sm);
% STRMAT2NSTR - converts char matrix (strvcat type) into linefeed-delemited string
%   Note: blanks are not trimmed

Nr = size(sm,1);
se = [sm, repmat(char(10),Nr,1)]';
se = se(:)';

