function A=sumV(varargin)
N=length(varargin);
M=(1:1:N);
S=[varargin{1}];
for s=2:N
    S=[S varargin{s}];
end;
B=find(M ~= 3);
A=[S(3) S(B)];
end