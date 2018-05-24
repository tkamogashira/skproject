function x = shufcorr(M);
% shufcorr - normalized shuffled correlation among matrix columns 
%    shufcorr(M) computes the normalized average correlation between the
%    columns of matrix M. Each column C of M is normalized, i.e. shifted to
%    be zero-mean and scaled to have unit-norm.
%    Then the correlation between each pair of non-identical columns is
%    computed and averaged. The implementation is efficient for M with
%    relatively few columns and large number of rows.
%
%    See also CORR.

[Nrow, Ncol] = size(M);
% zero-mean columns
Means = mean(M,1);
for icol=1:Ncol,
    M(:,icol) = M(:,icol) - Means(icol);
end
% normalize columns
for icol=1:Ncol,
    InvNorm = 1/norm(M(:,icol));
    M(:,icol) = M(:,icol).*InvNorm;
end

% don't loop over pairs of columns, but use sums
Msum = sum(M,2); % across-col sum
A = Msum.'*Msum;
B = sum(sum(M.^2));
x = (A-B)/(Ncol-1)/Ncol;




