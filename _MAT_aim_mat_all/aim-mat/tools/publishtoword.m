% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


% publishtoword

% publish the figures on the screen
% this is a script, not a function


% exclude the windows with the following names:
exclude{1}='browser';

global publish_parameters;
% if publish_parameters==1
exclude{2}='parameter';
% end

global extra_publish

% first search through all windows for the parameter ones
% all_windows=get(0,'children');
all_windows=allchild(0);
for i=1:length(all_windows)
    if strcmp(get(all_windows(i),'type'),'figure');
        titl=get(all_windows(i),'name');
        if strcmp(titl,'browser')
            browserwindow=all_windows(i);
        end
        %         for j=1:length(exclude)  TODO
        if ~isempty(strfind(lower(titl),exclude{2})) && publish_parameters==1

            hand=all_windows(i);
            dat=guidata(hand);
            params=dat.params;
            disp(params);
        end
        %         end
    end
end

clear createdfigs
global createdfigs
global was_unit_info
createdfigs=[];
createtits=[];
count=0;
for i=1:length(all_windows)
    if strcmp(get(all_windows(i),'type'),'figure');
        titl=get(all_windows(i),'name');

        % special
        if strfind(titl,'unitinfo')==1
            handles=guidata(browserwindow);
            cur_un=handles.info.current_unit;
            cur_an=handles.info.current_animal;
            unitinfo=getunitinfo(handles,cur_an,cur_un);
            nr_coms=length(unitinfo.comment);
            for ii=1:nr_coms
                alcoms=unitinfo.comment{ii};
                nr_comm=length(alcoms);
                disp(sprintf('\n'));
                thres=unitinfo.thresh;
                atten=unitinfo.stimulus_parameter{unitinfo.ex_number(i)}.attenuation_db_power_atten.values;
                abovethres=thres-atten;
                disp(sprintf('Automatic classification of Unit %d of Animal %d Experiment %d (%2.0f dB above threshold)',cur_un,cur_un,unitinfo.ex_number(i),abovethres));
                for iii=1:nr_comm
                    disp(alcoms{iii});
                end
                disp(sprintf('--> Unit was classified automatically as %s',unitinfo.found_type{ii}));
                disp(sprintf('\n'));
            end

            was_unit_info=1;
        else
            was_unit_info=0;
        end
        can_be_published=1;
        for j=1:length(exclude)
            if ~isempty(strfind(titl,exclude{j}))
                can_be_published=0;
                break
            end
        end
        if can_be_published
            %             disp(titl)
            fig=all_windows(i);

            nfignam=sprintf('c:\\temp\\tempfig%d.fig',count);
            saveas(fig,nfignam)
            %             open('c:\temp\tempfig.fig');
            %             refresh
            count=count+1;
            creatednames{count}=nfignam;
            createtits{count}=titl;
        end
    end
end

%%
if length(createtits)>0
    [nr_x,nr_y]=size(extra_publish);
    if nr_y<nr_x
        extra_publish=extra_publish';
        [nr_x,nr_y]=size(extra_publish);
    end
    if nr_x>0
        if nr_y>0
            disp(extra_publish{1,1});
        end
        if nr_y>1
            disp(extra_publish{1,2});
        end
        if nr_y>2
            disp(extra_publish{1,3});
        end
        if nr_y>3
            disp(extra_publish{1,4});
        end
        if nr_y>4
            disp(extra_publish{1,5});
        end
        if nr_y>5
            disp(extra_publish{1,6});
        end
        if nr_y>6
            disp(extra_publish{1,7});
        end
        if nr_y>7
            disp(extra_publish{1,8});
        end
        if nr_y>8
            disp(extra_publish{1,9});
        end
        if nr_y>9
            disp(extra_publish{1,10});
        end
    end
    disp(createtits{1})
    open(creatednames{1});
    createdfigs(1)=gcf;
end

%%
if length(createtits)>1
    [nr_x,nr_y]=size(extra_publish);
    if nr_y<nr_x
        extra_publish=extra_publish';
        [nr_x,nr_y]=size(extra_publish);
    end

    if nr_x>1
        if nr_y>0
            disp(extra_publish{2,1});
        end
        if nr_y>1
            disp(extra_publish{2,2});
        end
        if nr_y>2
            disp(extra_publish{2,3});
        end
    end
    disp(createtits(2))
    open(creatednames{2});
    createdfigs(2)=gcf;
end

%%
if length(createtits)>2
    [nr_x,nr_y]=size(extra_publish);
    if nr_y<nr_x
        extra_publish=extra_publish';
        [nr_x,nr_y]=size(extra_publish);
    end

    if nr_x>2
        if nr_y>0
            disp(extra_publish{3,1});
        end
        if nr_y>1
            disp(extra_publish{3,2});
        end
        if nr_y>2
            disp(extra_publish{3,3});
        end
    end
    disp(createtits(3))
    open(creatednames{3});
    createdfigs(3)=gcf;
end

%%
if length(createtits)>3
    [nr_x,nr_y]=size(extra_publish);
    if nr_y<nr_x
        extra_publish=extra_publish';
        [nr_x,nr_y]=size(extra_publish);
    end

    if nr_x>3
        if nr_y>1
            disp(extra_publish{4,1});
        end
        if nr_y>1
            disp(extra_publish{4,2});
        end
        if nr_y>2
            disp(extra_publish{4,3});
        end
    end

    disp(createtits(4))
    open(creatednames{4});
    createdfigs(4)=gcf;
end
