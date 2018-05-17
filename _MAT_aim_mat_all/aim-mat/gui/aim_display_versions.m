% procedure for 'aim-mat'
% function aim_display_versions(handles)
%   INPUT VALUES:
%   RETURN VALUE:
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org




function aim_display_versions(handles)

%PCP
pcpnames=get(handles.listbox0,'String');
for i=1:length(pcpnames)
	str=sprintf('ver=handles.all_options.pcp.%s.revision;',pcpnames{i});
	try 
		eval(str);
	catch
		ver='Revision not known';
	end
	text{1}{i}.columname='PCP';
	text{1}{i}.modulename=pcpnames{i};
	text{1}{i}.version=ver;
end
%BMM
bmmnames=get(handles.listbox1,'String');
for i=1:length(bmmnames)
	str=sprintf('ver=handles.all_options.bmm.%s.revision;',bmmnames{i});
	try 
		eval(str);
	catch
		ver='Revision not known';
	end
	text{2}{i}.columname='BMM';
	text{2}{i}.modulename=bmmnames{i};
	text{2}{i}.version=ver;
end
%NAP
napnames=get(handles.listbox2,'String');
for i=1:length(napnames)
	str=sprintf('ver=handles.all_options.nap.%s.revision;',napnames{i});
	try 
		eval(str);
	catch
		ver='Revision not known';
	end
	text{3}{i}.columname='NAP';
	text{3}{i}.modulename=napnames{i};
	text{3}{i}.version=ver;
end
%STROBES
strobesnames=get(handles.listbox3,'String');
for i=1:length(strobesnames)
	str=sprintf('ver=handles.all_options.strobes.%s.revision;',strobesnames{i});
	try 
		eval(str);
	catch
		ver='Revision not known';
	end
	text{4}{i}.columname='STROBES';
	text{4}{i}.modulename=strobesnames{i};
	text{4}{i}.version=ver;
end
%SAI
sainames=get(handles.listbox4,'String');
for i=1:length(sainames)
	str=sprintf('ver=handles.all_options.sai.%s.revision;',sainames{i});
	try 
		eval(str);
	catch
		ver='Revision not known';
	end
	text{5}{i}.columname='SAI';
	text{5}{i}.modulename=sainames{i};
	text{5}{i}.version=ver;
end
%USER
usernames=get(handles.listbox6,'String');
for i=1:length(usernames)
	str=sprintf('ver=handles.all_options.user.%s.revision;',usernames{i});
	try 
		eval(str);
	catch
		ver='Revision not known';
	end
	text{6}{i}.columname='USER';
	text{6}{i}.modulename=usernames{i};
	text{6}{i}.version=ver;
end
%MOVIES
movienames=get(handles.listbox5,'String');
for i=1:length(movienames)
	str=sprintf('ver=handles.all_options.movie.%s.revision;',movienames{i});
	try 
		eval(str);
	catch
		ver='Revision not known';
	end
	text{7}{i}.columname='MOVIES';
	text{7}{i}.modulename=movienames{i};
	text{7}{i}.version=ver;
end


figure;
win=get(gca,'Parent');
set(win,'Name','All models and all versions');
set(win,'NumberTitle','off');
set(win,'MenuBar','none');
movegui(win,'center');
pos=get(win,'Position');
set(win,'Visible','on');
box = uicontrol('Style', 'ListBox','Position', [0,0,pos(3),pos(4)],'HorizontalAlignment','left');
set(box,'Parent',win);
set(box,'FontSize',10);

str=[];
counter=1;
for i=1:7
	nr_modules=length(text{i});
	str{counter}=text{i}{1}.columname ;
	counter=counter+1;
% 	str=[str text{i}{1}.columname '\n'];
	for j=1:nr_modules
		ver=strrep(text{i}{j}.version,'$','');
		str{counter}=['       ' text{i}{j}.modulename '     ' ver];
		counter=counter+1;
% 		str=[str text{i}{j}.modulename '\t' text{i}{j}.version '\n'];
	end
end


% display the conflicts

str{counter}='' ;
counter=counter+1;
str{counter}='' ;
counter=counter+1;
% conflicts:
if isfield(handles.info,'conflicts')
	conflicts=handles.info.conflicts;
else
	return
end


if isempty(conflicts)
	str{counter}='no conflicts';
% 	counter=counter+1;%#ok
else
	str{counter}='conflicts:';
	counter=counter+1;
	for i=1:length(conflicts)
		str{counter}=conflicts{i};
		counter=counter+1;
	end
end



set(box,'String',str);
set(box,'max',length(str));



