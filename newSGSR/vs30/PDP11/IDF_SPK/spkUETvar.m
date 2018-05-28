function [X1, X2] = spkUETvar(varargin)
% [VAR1 VAR2] = spkUETvar(varargin) - return UET variables of SPK data as Nx2 matrix
if isstruct(varargin{1})
   SPK = varargin{1};
elseif isa(varargin{1},'dataset')
   ds = varargin{1};
   SPK = SPKget(ds.filename, -ds.iseq);
else
   SPK = SPKget(varargin{:});
end
QQ=cat(1,SPK.subseqInfo{:});
X1 = cat(1,QQ.var1);
X2 = cat(1,QQ.var2);
