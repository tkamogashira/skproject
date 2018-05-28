function L = SetupList(Full);
% SetupList - list current setup files
%   SetupList with no output args displays list of setup files.
%   L = SetupList returns the list in cellstring.
%   Only setup files with default extension are displayed.
%   Setup files that are local to other computers are not listed.
%
%   SetupList('full') also lists the values contained in the setup files.
%
%   See also ToSetupFile, FromSetupFile, SetupFile, setupdir.

% get default extension of setup files
if nargin<1, Full = 0; end % default: no full listing, just names


[dum dum SetupExt] = fileparts(setupfilename(''));
F = dir([setupdir filesep '*' SetupExt]);
F = {F.name};
% strip off the extension
for ii=1:length(F),
    F{ii} = strtok(F{ii}, '.');
end
% find out what local prefix is 
[dum localPrefix dum] = fileparts(setupfilename('A'));
localPrefix = localPrefix(1:end-1);

L = {};
for ii=1:length(F), % add decoded F{ii} if okay
    SUF = local_code_filename(F{ii}, localPrefix);
    if ~isempty(SUF), L = [L SUF]; end
end

% only display if no outarg is specified
if nargout==0,
    disp(' ');
    for ii=1:length(L),
        sf = L{ii};
        disp(['---------   ' sf ]);
        if Full, 
            display(FromSetupFile(sf)); 
            disp(' ');
        end
    end
    clear L;
end

%==============
function cf = local_code_filename(FN, localPrefix);
% code setup file to the way it is used in tosetupfile & fromsetupfile:
%  MyPC-only_FOO      -> FOO
%  OtherPC-only_FOO   -> ''
%  ANY                -> ~ANY
istart = length(localPrefix)+1;
SomeLocal = ~isempty(regexp(FN,'^\w+-only_', 'once' ));
MyLocal = ~isempty(regexp(FN, localPrefix, 'once' ));
if MyLocal, cf = FN(istart:end);
elseif SomeLocal, cf='';
else, cf = ['~' FN];
end


