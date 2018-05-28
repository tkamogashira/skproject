function n = CompuName
% COMPUNAME - name of computer, if known
%   COMPUNAME returns a character string containing the name of
%   the computer. You can set this name by SETCOMPUNAME.
%   If no name has been defined, COMPUNAME returns "??".
%   Note: these names are meaningful only within SGSR.
%
%   See also SETCOMPUNAME.

    n = '??';
    try
        ID.computer = '';
        ID = getFieldsFromSetupFile(ID,'computerID');
        n = ID.computer;
    end
end
