function M = GVD(FNCs, ArgList, varargin);
% GVD - generalized VanderMonde matrix using inline objects
%    M = GVD({EXP1 EXP2 ...EPXN}, ArgList, X,Y,..) returns a  generalized
%    VanderMonde matrix M whose columns are functions Fnc_1..Fnc_N expressed
%    in the inline expressions EXP1 .. EXPN. The elements of each column
%    are the results of evaluating Fnc_j in the respective elements of X,
%    Y.. . Thus M(i,j) = Fnc_j(X(i),Y(i),..). The function arguments X,Y.. 
%    must be arrays of equal or compatible size. ArgList is a cellstr
%    which lists, in the correct order, the names of the symbolic variables 
%    used in EXP1..EXPN. The correct order is that corresponding to X,Y.. .
%
%    Examples
%        GVD({'x.^3' 'x.^2' 'x' '1' }, {'x'}, X) is the Vandermonde 
%               matrix M(i,j)=X(i).^(4-j)
%
%        GVD('1' 'x+y', '(x+y).^2' '(x-y).^2', ('x' 'y'}, X,Y)
%
%    See also VANDER, SameSize, Monomial, PolyValND.

if length(varargin)~=length(ArgList),
    error('# of variables passed to GVD must match # of formal function args');
end

Nf = length(FNCs); % # functions = # columns of M
[varargin{:}] = SameSize(varargin{:});
Nvar = length(varargin); % # variables passed to the inline functions
Nval = numel(varargin{1}); % number of X values = # rows of M

for ii=1:Nvar,
    varargin{ii} = varargin{ii}(:); % force into column vector
end

M = zeros(Nval, Nf);
for ii=1:Nf,
    Fnc = inline(FNCs{ii}, ArgList{:});
    M(:,ii) = feval(Fnc, varargin{:});
end















