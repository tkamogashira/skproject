% support file for 'aim-mat'
%
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function [str,oct,nr_note]=fre2note(fre)

% translates the fre to the nearest real note in a-g

if fre==0
    str='no';
    oct=0;
    nr_note=-1;
    return
end

note_names=['A ';'A#';'B ';'C ';'C#';'D ';'D#';'E ';'F ';'F#';'G ';'G#'];
lowest_note=27.5;   % Hz =A1 440 Hz= a4

for i=1:length(fre)
    if fre(i)>0
        cent(i)=fre2cent(lowest_note,fre(i));
        % how many octaves?
        nr_octs(i)=round(cent(i)/1200)-1;
        oct(i)=nr_octs(i)+1;
        
        % how many tones?
        cento(i)=mod(cent(i),1200)/100;
        nr_note(i)=round(cento(i)+1);
        if nr_note(i)>12
            nr_note(i)=1;
        end
        %     nr_note(find(nr_note>12))=1;
    else
        nr_note(i)=0;
    end
end
% compansate for that the octave changes at C
for i=1:length(fre)
    if nr_note(i) > 3 && nr_note(i) < 7
        nr_octs(i)=nr_octs(i)+1;
    end    
end

for i=1:length(fre)
    if nr_note(i)==0
        str{i}=['00'];
    elseif strcmp(note_names(nr_note(i),2),' ')
        if nr_octs(i)<0
            str{i}=[note_names(nr_note(i)) '0'];
        else
            str{i}=[note_names(nr_note(i)) num2str(nr_octs(i))+1];
        end
    else
        if nr_octs(i)<0
            str{i}=[note_names(nr_note(i),1:2) '0'];
        else
            str{i}=[note_names(nr_note(i),1:2) num2str(nr_octs(i))+1];
        end
    end
end
