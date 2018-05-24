function stripCallback(Src, Event, CB, varargin) %#ok<INUSL>
% stripCallback - remove obligatory Src,Event callback args
%   stripCallback(Src,Ev, @Foo, ...) passes the arguments indicated
%   by the ellipses to callback function Foo. This allows the usage of
%   arbitrary functions as callback functions, without having to build in
%   these first two unsollicited input arguments.

if ~isfhandle(CB),
    error('3rd arg tof stripCallback must be function handle.');
end
% everything to callback function
feval(CB, varargin{:});


