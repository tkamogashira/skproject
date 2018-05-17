% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function [fre,oct,nr_note]=note2fre(note)

% translates the note to the frequency

note_names=['A ';'B ';'C ';'C#';'D ';'D#';'E ';'F ';'F#';'G ';'G#';'H '];
lowest_note=27.5;   % Hz =A1 440 Hz= a5


rnote=note(1);
if strcmp(rnote(1),' ') || double(rnote(1))==9
    note=note(2:end);
    rnote=note(1);
end
if strcmp(note(2),'#') 
    rnote=[rnote '#'];
    octnum=note(3);
elseif strcmp(note(2),'b')
    rnote=[rnote 'b'];
    octnum=note(3);
else
    octnum=note(2);
end

  
% http://www.jita.com.cn/Seiten/Theorie/musik_theorie_1.htm
switch rnote
    case {'A','a'}
        nr_note=1;
    case {'A#','a#','Bb','bb'}
        nr_note=2;
    case {'H','h','B','b'}
        nr_note=3;
    case {'C','c'}
        nr_note=4;
    case {'C#','c#','Db','db'}
        nr_note=5;
    case {'D','d'}
        nr_note=6;
    case {'D#','d#','Eb','eb'}
        nr_note=7;
    case {'E','e'}
        nr_note=8;
    case {'F','f'}
        nr_note=9;
    case {'F#','f#','Gb','gb'}
        nr_note=10;
    case {'G','g'}
        nr_note=11;
    case {'G#','g#','Ab','ab'}
        nr_note=12;
    otherwise
        fre=0;
        return
end

oct=str2num(octnum);

% compansate for that the octave changes at C
if nr_note > 3
    calcoct=oct-1;
else
    calcoct=oct;
end
gescent=calcoct*1200+100*(nr_note-1);
fre=cent2fre(lowest_note,gescent);


