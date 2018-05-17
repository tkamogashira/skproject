% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function ret=getmaximacharacteristics(where,maxpos,minpos,maxs,mins)
% gibt die wesentlichen Eigenschaften der Maxima zurück:
% absoulte_height
% position = position of the maximum
% distance = mean distance to neighbour mins 
% contrast = peak to trough ration of max to neighbour mins 
% supheight = height above the neighbour peaks

nr=length(where);
for i=1:nr
    [minleft,minleftwo]=getminimumleftof(where(i),maxpos,minpos,maxs,mins);
    [minright,minrightwo]=getminimumrightof(where(i),maxpos,minpos,maxs,mins);
    [maxleft,maxleftwo]=getmaximumleftof(where(i),maxpos,minpos,maxs,mins);
    [maxright,maxrightwo]=getmaximumrightof(where(i),maxpos,minpos,maxs,mins);
    
    current_val=maxs(find(maxpos==where(i)));
    ret{i}.absheight=current_val;

    ret{i}.position=where(i);
    
    ret{i}.contrast=getmaxcontrast(where(i),maxpos,minpos,maxs,mins);
    ret{i}.width=getmaxwidth(where(i),maxpos,minpos,maxs,mins);

    if ~isempty(minleft) & ~isempty(minright)
        ret{i}.distance=(abs(minrightwo) - abs(minleftwo))/2; % Mittelwert der Abstände zu den nächsten beiden peaks
    end
    if isempty(minleft)
        ret{i}.distance=abs(minrightwo);
    end
    if isempty(minright)
        ret{i}.distance=abs(minleftwo);
    end

    if ~isempty(maxleft) & ~isempty(maxright)
        ret{i}.supheight=current_val/(maxleft+maxright)/2;
    end

    if isempty(maxleft)
        if isempty(maxright)
            ret{i}.supheight=0;
        else
            ret{i}.supheight=current_val/maxright;
        end
    end

    if isempty(maxleft)
        if isempty(maxright)
            ret{i}.supheight=0;
        else
            ret{i}.supheight=current_val/maxright;
        end
    end
end