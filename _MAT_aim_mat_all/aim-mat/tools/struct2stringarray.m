% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function lines=struct2stringarray(str,strname)
% goes recursevly through the struct and appends a line for each
% structthing

lines=[];

counter=1;
if isstruct(str)
    names=fieldnames(str);
    conts=struct2cell(str);
    for i=1:length(names);
        cstr=names{i};
        
        nr_cont=length(str);
        for kkk=1:nr_cont
            if nr_cont==1
                strstr=sprintf('%s.%s',strname,cstr);
            else
                strstr=sprintf('%s(%d).%s',strname,kkk,cstr);
            end
            %             eval(sprintf('vari=str.%s;',cstr));
            eval(sprintf('vari=str(%d).%s;',kkk,cstr));
            
            newlinestr='';
            if isstruct(vari)
                newlinestr=struct2stringarray(vari,strstr);
                nrlines=length(newlinestr);
                for j=1:nrlines
                    lines{counter}=newlinestr{j};counter=counter+1;
                end
            else
                if isnumeric(vari)
                    nrlines=size(vari,1);
                    nrcolumns=size(vari,2);
                    res='';
                    for jj=1:nrcolumns
                        for ii=1:nrlines
                            res=sprintf('%s %s',res,num2str(vari(ii,jj)));
                        end
                        if nrlines>1 && jj< nrlines
                            res=[res ';'];
                        end
                    end
                    
                    if length(vari)>1
                        newlinestr=sprintf('%s=[%s]',strstr,res);
                    else
                        newlinestr=sprintf('%s=%s',strstr,num2str(vari));
                    end
                else
                    if iscell(vari)
                        res='';
                        for jj=1:length(vari)
                            subvari=vari{jj};
                            if iscell(subvari)
                                res2='';
                                for kk=1:length(subvari)
                                    res2=sprintf('%s {''%s''}',res2,subvari{kk});
                                end
                                newlinestr{jj}=sprintf('%s{%d}=[%s]',strstr,jj,res2);
                            elseif isstruct(subvari)
                                strstrh=sprintf('%s{%d}',strstr,jj);
                                newlinestr{jj}=struct2stringarray(subvari,strstrh);
                            elseif isstr(vari{jj})
                                res=sprintf('%s {''%s''}',res,vari{jj});
                                newlinestr=sprintf('%s=[%s]',strstr,res);
                            end
                        end
                    else
                        newlinestr=sprintf('%s=''%s''',strstr,vari);
                    end
                end   
                %                         try
                if iscell(newlinestr)
                    for oo=1:length(newlinestr)
                        newstrcell=newlinestr{oo};
                        if iscell(newstrcell)
                            for iii=1:length(newstrcell)
                                lines{counter}=newstrcell{iii};counter=counter+1;
                            end
                        else
                            lines{counter}=newstrcell;counter=counter+1;
                        end
                        %                     lines=[lines newlinestr{oo}];counter=counter+1;
                    end
                else
                    lines{counter}=newlinestr;counter=counter+1;
                end
                %                     catch
                %                         p=0
                %                     end
            end
        end
    end
else % not a struct, 
    
end