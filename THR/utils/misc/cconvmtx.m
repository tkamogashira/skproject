function M = cconvmtx(C);
% cconvmtx - convolution matrix for circular convolutions
%    M = cconvmtx(C), where C is a column array, is a matrix such that M*X
%    equals cconv(C,X,N), where X is a column array having the same size 
%    as C, and N is length(C).
%
%    For row arrays C, X*M == cconv(M,X,N)
%
%    See also CONVMTX, CCONV.

N = ArginDefaults('N',[]);
isrow = size(C,2)>1;
C = C(:);
N = size(C,1);
M = convmtx([C;C], N);
M = M(N+1:2*N,:);
if isrow,
    M = M.';
end