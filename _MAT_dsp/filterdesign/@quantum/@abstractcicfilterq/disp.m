function disp(this, varargin)
%DISP   Display this object.

% Offset parameter was added to allow re-use of this method by both the
% CICDECIM & CICINTERP objects, but with different alignments.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

props = {{'InputWordLength', 'InputFracLength'}, {'FilterInternals'}};

if strcmpi(this.FilterInternals,'MinWordLengths'),
    props{2} = {props{2}{1}, 'OutputWordLength'};
elseif strcmpi(this.FilterInternals,'SpecifyWordLengths')
    props{2} = {props{2}{1}, 'SectionWordLengths',...
        'OutputWordLength'};
elseif strcmpi(this.FilterInternals,'SpecifyPrecision')
    props{2} = {props{2}{1}, 'SectionWordLengths','SectionFracLengths', ...
        'OutputWordLength','OutputFracLength'};
end

siguddutils('dispstr', this, props, varargin{:});

% [EOF]
