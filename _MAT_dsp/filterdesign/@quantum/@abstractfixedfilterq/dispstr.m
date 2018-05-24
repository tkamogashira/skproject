function varargout = dispstr(this, varargin)
%DISPSTR   Return the formatted strings.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

% Ignore the format, can only work fixed.
if ischar(varargin{end})
    fmt = varargin{end};
    varargin(end) = [];
else
    fmt = 'dec';
end

switch lower(fmt(1:3))
    case 'dec'
        for indx = 1:length(varargin)
            varargout{indx} = signal_num2str(double(varargin{indx}));
        end
    case 'hex'
        for indx = 1:length(varargin)
            [rows, cols] = size(varargin{indx});
            if cols > 1 && rows > 1
                str = [];
                for jndx = 1:cols
                    str = [str repmat('  ', rows, 1) hex(varargin{indx}(:,jndx))];
                end
                str(:, 1:2) = [];
            else
                if isa(varargin{indx}, 'embedded.fi')
                    str = hex(varargin{indx});
                else
                    str = num2hex(varargin{indx});
                end
            end
            varargout{indx} = str;
        end
    case 'bin'
        for indx = 1:length(varargin)
            [rows, cols] = size(varargin{indx});
            if cols > 1 && rows > 1
                str = [];
                for jndx = 1:cols
                    str = [str repmat('  ', rows, 1) bin(varargin{indx}(:,jndx))];
                end
                str(:, 1:2) = [];
            else
                str = bin(varargin{indx});
            end
            varargout{indx} = str;
        end
end

% [EOF]
