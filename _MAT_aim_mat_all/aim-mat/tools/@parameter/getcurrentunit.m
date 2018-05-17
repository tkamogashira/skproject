% method of class @parameter
%
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org
function [selectedunit,fullunitname]=getcurrentunit(param,text,panel)
% returns the unit that this value is currently set to


cont=param.entries;
nrent=length(cont);

if nargin<3 % search in all subsections
    panel='all';
end

nr=getentrynumberbytext(param,text,panel);
if nr>0
    type=cont{nr}.type;
    if ~strcmp(type,'float') && ~strcmp(type,'slider')
        selectedunit='only floats have units...';
        fullunitname='';
        return
    end
    
    handleb=gethandle(param,text,panel,1);
    if ~isequal(handleb,0) && ishandle(handleb) % yes, there is a screen representation
        unitty=cont{nr}.unittype;
        if isa(unitty,'unit_none')
            selectedunit='';
            fullunitname='';
        else
            handleb2=gethandle(param,text,panel,2);
            unitnr=get(handleb2,'value');
            possibleunitstr=getunitstrings(unitty);
            selectedunit=possibleunitstr{unitnr};
            possible_units_full=getunitfullstrings(unitty);
            fullunitname=possible_units_full{unitnr};
        end
        return
    else % no representation on screen
        selectedunit=cont{nr}.orgunit;
        return
    end
else
    error('error, the entry does not exist');
    %     val=0;  % we must return a logical value otherwise it can generate difficult errors
end