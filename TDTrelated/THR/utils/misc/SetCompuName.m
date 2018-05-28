function SetCompuName(Name);
% SETCOMPUNAME - set name of computer
%   SETCOMPUNAME FOO sets the computer name to "FOO".
%   Note: these names are meaningful only within PHOENIX
%
%   See also COMPUNAME.

% because compuname and setcompuname are used by XXXsetupfile, calling
% XXXsetupfile here would cause endless recursion. we use Matlab basics
% instead.

if ~isvarname(Name),
    error('Computer name must be valid Matlab identifier. See ISVARNAME');
end
% delegate the work to compuname (for consistency reasons)
compuname('-setcompuname', Name);




