% procedure for 'aim-mat'
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% mix the parts of old_struct with the parts of add_struct
% old entries in old_struct with identical names are overwritten with the entries
% from add_struct
% works recursive up to the second layer
% 
% 
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org





function [new_struct,conflicts]=mixstruct(old_struct,add_struct)
% old_struct is the original structure
% add_struct is the new struct, that can have new options 
% a warning is given, if a module doesnt exist any more
% and these options are removed from the parameter file.
% 
% new parameters are added to the old parameters for each module


conflicts=[];
conflict_counter=1;

newcolumns=fieldnames(add_struct);

new_struct=old_struct;

for i=1:length(newcolumns)
	curr_col=newcolumns{i};
	if ~strcmp(curr_col,'signal')
	if ~isfield(old_struct,curr_col) % add whole new fields from the new struct
		est=sprintf('new_struct.%s=add_struct.%s;',curr_col,curr_col);
		eval(est);
	else % its already there, but not neccessarily up to date
		eval(sprintf('old_columns=old_struct.%s;',curr_col));
		eval(sprintf('new_columns=add_struct.%s;',curr_col));
		old_modules=fieldnames(old_columns);
		new_modules=fieldnames(new_columns);
		
	
		for j=1:length(new_modules)
			if ~isfield(old_columns,new_modules{j}) % add whole new module
				est=sprintf('new_struct.%s.%s=new_columns.%s;',curr_col,new_modules{j},new_modules{j});
				eval(est);
				constr=sprintf('conflicts{%d}=''new module added: %s %s'';',conflict_counter,newcolumns{i},new_modules{j});
				eval(constr);conflict_counter=conflict_counter+1;
			else  % both are there, but check the versions
				if ~strcmp(newcolumns{i},'signal') && ~strcmp(newcolumns{i},'graphics')
					ver1str=sprintf('ver1=old_struct.%s.%s.revision;',newcolumns{i},new_modules{j});
					try % old version
						eval(ver1str);
						ver11=ver2num(ver1);
					catch
						constr=sprintf('conflicts{%d}=''old module had no revision number: module: %s.%s'';',conflict_counter,newcolumns{i},new_modules{j});
						eval(constr);conflict_counter=conflict_counter+1;
% 						ver11='no version';
						ver11=-1;
						%ver12=-1;
					end
					ver2str=sprintf('ver2=add_struct.%s.%s.revision;',newcolumns{i},new_modules{j});
					try % new version
						eval(ver2str);
						ver21=ver2num(ver2);
					catch
						ver2='no version';
						constr=sprintf('conflicts{%d}=''loaded newer version on module: %s.%s (current version: no version)'';',conflict_counter,newcolumns{i},new_modules{j});
						eval(constr);conflict_counter=conflict_counter+1;
					end
% 					if isnumeric(ver11) && isnumeric(ver12) && isnumeric(ver21) && isnumeric(ver22)
						if ver21>ver11 %|| (ver21==ver11 && ver22>ver12)
							constr=sprintf('conflicts{%d}=''module %s.%s loaded with higher version number (old: %d.%d new: %d.%d)'';',conflict_counter,newcolumns{i},new_modules{j},ver11,ver12,ver21,ver22);
							eval(constr);conflict_counter=conflict_counter+1;
						end
						if ver21<ver11 %|| (ver21==ver11 && ver22<ver12)
							constr=sprintf('conflicts{%d}=''module %s.%s loaded with lower version number (old: %d.%d new: %d.%d)'';',conflict_counter,newcolumns{i},new_modules{j},ver11,ver12,ver21,ver22);
% 							constr=sprintf('conflicts{%d}=''module loaded with lower version number: module: %s.%s revision %d.%d  (current version: %d.%d )'';',conflict_counter,newcolumns{i},new_modules{j},ver11,ver12,ver21,ver22);
							eval(constr);conflict_counter=conflict_counter+1;
						end
						if ver21==ver11 % && ver22==ver12
							% 							constr=sprintf('conflicts{%d}=''no conflict: module: %s.%s revision %d.%d '';',conflict_counter,newcolumns{i},new_modules{j},ver11,ver12);
							% 							eval(constr);conflict_counter=conflict_counter+1;
						end
					end
% 				end
			end
			% next to version checking is checking all parameters. If new
			% ones are there, add them!
			% but only, if the module is already there
			if isfield(old_columns,new_modules{j})
				oldstr=sprintf('old_parameter=old_columns.%s;',new_modules{j});
				eval(oldstr);
				newstr=sprintf('new_parameter=fieldnames(new_columns.%s);',new_modules{j});
				eval(newstr);
				for k=1:length(new_parameter)
					if ~isfield(old_parameter,new_parameter{k})
						addstr=sprintf('new_struct.%s.%s.%s=add_struct.%s.%s.%s;',newcolumns{i},new_modules{j},new_parameter{k},newcolumns{i},new_modules{j},new_parameter{k});
						eval(addstr);
						valstr=sprintf('value=new_struct.%s.%s.%s;',newcolumns{i},new_modules{j},new_parameter{k});
						eval(valstr);
						if isnumeric(value)
							value=num2str(value);
						end
						constr=sprintf('conflicts{%d}=''new parameter added to the module: %s.%s : %s=%s'';',conflict_counter,newcolumns{i},new_modules{j},new_parameter{k},value);
						eval(constr);conflict_counter=conflict_counter+1;
					end
				end
			end
		end
	end
	% look for modules that have gone. These are not taken into
	% consideration any more and deleted from the options
	for j=1:length(old_modules)
		if ~isfield(new_columns,old_modules{j}) % add whole new module
			constr=sprintf('conflicts{%d}=''module was deleted: %s %s'';',conflict_counter,newcolumns{i},old_modules{j});
			eval(constr);conflict_counter=conflict_counter+1;
			rmstr=sprintf('new_struct.%s=rmfield(new_struct.%s,''%s'');',newcolumns{i},newcolumns{i},old_modules{j});
			eval(rmstr);
		end				
	end
end
end

function vernum=ver2num(ver)
% ver now comes in the format: '$Revision: 585 $'
% not 'Revision: 1.2', so there's now no dot
wherecolon=strfind(ver,':');
wheredollar=strfind(ver,'$');
wheredollar=wheredollar(2);
%wheredot=strfind(ver,'.');
vernum=str2num(ver(wherecolon+1:wheredollar-2));
%ver2=str2num(ver(wheredot+1:end-1));
if ~isnumeric(vernum)
	vernum=-1;
end
%if ~isnumeric(ver2)
%	ver2=-1;
%end


