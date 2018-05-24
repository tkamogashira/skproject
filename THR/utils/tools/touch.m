function touch(FN, varargin);
% touch - set date of file
%   touch Foo    sets the date of file Foo to now.
%
%   Touch calls a DOS utility. To learn more, try
%
%       touch -h

if nargin<1,
    varargin{1} = '-h';
    FN = '';
end

cmd = '!c:\installs\touch\touch.exe ';
for iarg=1:nargin-1,
    cmd = [cmd varargin{iarg} ' '];
end
cmd = [cmd ' ' FN]
eval(cmd)






