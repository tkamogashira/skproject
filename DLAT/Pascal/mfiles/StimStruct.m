function D = StimStruct(Stim,Exp,varargin)

% STIMSTRUCT - Make a struct of a certain stimulus type.
%   Make a struct of certain stimulus type (Stim) for a given 
%   experiment (Exp). Stim should be a string such as 'NTD' and Exp 
%   should be a string such as 'M0545'. Multiple experiments can be 
%   searched to make one struct when Exp is given as a cell array, eg:
%   {'M0545','M0545B','M0545C','M0545D','M0545E','M0545F'}. The default 
%   variable in the sturuct is the Sequence ID given as D.id. This should
%   never be given as an additional variable. Additional variables can be 
%   added to the struct and should be given as pairs, where the first 
%   argument is the variable to be included in the struct and the second is 
%   (part of) a dataset object. For example,
%   
%   D = StimStruct('THR',{'M0545','M0545B','M0545C'},...
%               'SPL','ds.Stimulus.StimParam.SPL')

% MMCL Jan 2006

%----------- Make struct of all 'Stim' functions & additional varargins ---------------

%Initialize data struct
U=[];
if length(varargin)>1 %check for varargins
    for i = 1:length(varargin)/2
        eval([upper(varargin{2*i-1}) ' = [];']); %Initialize varargin struct
    end
end

% Get relevant data for each experiment
for q = 1:length(Exp)
    Exp{q}
    a=getuserdata(Exp{q});
    S = getfield(a,'DSInfo');
    R=[];
    m=1;
    for n = 1:length(S)
        T = getfield(S(n),'dsID');
        R{n} = T;
        if ~isempty(findstr(R{n},Stim))
            u{m} = R{n}; 
            try 
               ds = dataset(Exp{q},u{m});
               if length(varargin)>1
                    for i = 1:length(varargin)/2
                        eval([lower(varargin{2*i-1}) '{m} = num2str(' varargin{2*i} ');']);
                    end
               end
               m = m+1;
            catch
                disp(['Cannot evaluate dataset ' Exp{q} ' ' u{m}]);
                u = u(1:m-1); % remove this ds from u as it cannot be evaluated
            end
        end
    end
    VarList = who;
    if ~isempty(strmatch('u',VarList)); % check if any new variables have been found
        U=[U,u]; 
        clear u;
        if length(varargin)>1
            for i = 1:length(varargin)/2
                eval([upper(varargin{2*i-1}) ' = [' upper(varargin{2*i-1}) ',' lower(varargin{2*i-1}) '];']);
                eval(['clear ' lower(varargin{2*i-1})]);
            end
        end
    end
end

% Write all data to a struct D
StructString = ['D = struct(''id'',U ']; %Initialize StructString with default variable U
if length(varargin)>1
    for i = 1:length(varargin)/2
        %Add additional varargin variables to StructString
        StructString = [StructString ' ,''' lower(varargin{2*i-1}) ''',' upper(varargin{2*i-1})]; 
    end
end
StructString = [StructString ')']; % close StructString
eval(StructString);
