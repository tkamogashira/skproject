function cc = KC(SS1,SS2,dur,binwidth);
%KC - Kruis Correleren
%   cc = KC(SS1,SS2) %berekent 'kruiscorrelatie'
%   
%   CAVE    1/KC accepteert alleen cellarrays met identiek aantal colommen
%           2/als SS1 volledig gelijk is  aan SS2 wordt een autocorrelatie berekend
%           3/spikes buiten analysewindow moeten verworpen worden vooraleer KC wordt aangeroepen

%ARGUMENTS
%   SS1 = SpikeSet1 ; cellarray(1 rij,x colommen)
%   SS2 = SpikeSet2; cellarray(1 rij, x colommen)
%   dur = duration of analysiswindow in milliseconds
%OUTPUT
%   cc.tau = vector with bincenters of interval-length.
%   cc.KC  = vector with number of intervals
%   cc.NF(1)=divide cc.KC with this factor to get result independent of number of reps and of analysiswindow
%   cc.NF(2)=RATE (spikes/second) 


if ~iscell(SS1) | ~iscell(SS2) | ~isequal(nargin,4)
error('4 inputs please and SS1 and SS2 must be a cellarrays');   
end

if ~isequal(size(SS1,2),size(SS2,2))
 error('SS1 and SS2 must have the same numbers of columns');
else 
 a = size(SS1,2);  
end

maxlag =30;

if isequal(SS1,SS2)
    Com = nchoosek(1:a,2); %AUTOCORR: 1/identieke spiketrains uitgesloten
                           %          2/symmetrie impliceert redundantie welke rekenvoordeel oplevert
    Delay = 0:binwidth:maxlag; 
    A = 'ac';    
elseif ~isequal(SS1,SS2)
    COM = nchoosek(1:a,2); 
    Com = [COM;[COM(:,2),COM(:,1)];[(1:a)',(1:a)']];
    Delay = 0:binwidth:maxlag;
    Delay = [-1*fliplr(Delay(2:end)),Delay];
    A = 'cc';    
end

cc=struct('tau',[],'KC',[],'NF',[]);

NCo = 0;
ZEROS = 0;
switch A
case 'cc'
for i = 1:length(Com)
    spiketrain1 = SS1{1,Com(i,1)};
    spiketrain2 = SS2{1,Com(i,2)};
    if ~isempty(spiketrain1) & ~isempty(spiketrain2)
        ISImatrix = repmat(spiketrain1',1,length(spiketrain2)) ...
                    - repmat(spiketrain2,length(spiketrain1),1);
        IISImatrix = find( abs(ISImatrix) <= maxlag );       %Alleen intervallen kleiner dan MaxLag.
        if ~isempty(IISImatrix)
            ISImatrix = ISImatrix(IISImatrix);
            Co = histc((ISImatrix), Delay);             
            
            if size(Co,1) > size(Co,2)
            Co = Co';
            end
            NCo = NCo + Co;
        end   
    end   
end
case 'ac'
for i = 1:length(Com)
    spiketrain1 = SS1{1,Com(i,1)};
    spiketrain2 = SS2{1,Com(i,2)};
    if ~isempty(spiketrain1) & ~isempty(spiketrain2)
        ISImatrix = repmat(spiketrain1',1,length(spiketrain2)) ...
                    - repmat(spiketrain2,length(spiketrain1),1);
        IISImatrix = find( abs(ISImatrix) <= maxlag );       %Alleen intervallen kleiner dan MaxLag.
        if ~isempty(IISImatrix)
            ISImatrix = ISImatrix(IISImatrix);
            ZEROS = ZEROS + length(find(ISImatrix==0));
            Co = histc(abs(ISImatrix),Delay);
            
            if size(Co,1) > size(Co,2)
            Co = Co';
            end
            NCo = NCo + Co;
        end   
    end   
end
end

NCo = NCo(1:end-1);

switch A
case 'ac'
Ns1 = cat(2,SS1{:});
RATE = 1000 * length(Ns1) / ((dur)*a); %rate
NF =  2*size(Com,1)*(dur)/ 1000; 
cc.tau = [-1 * fliplr(Delay(1:end-1)+binwidth/2),(Delay(1:end-1)+binwidth/2)];
NCo(1) = NCo(1) + ZEROS;                %foutieve nultelling opheffen
cc.KC = [fliplr(NCo),NCo];
case 'cc'
Ns1 = cat(2,SS1{:});   
Ns2 = cat(2,SS2{:});
RATE = 1000 * (length(Ns1) + length(Ns2)) / (2*(dur)*a); %rate
NF =  size(Com,1)*(dur)/ 1000; 
cc.tau = Delay(1:end-1)+binwidth/2;
cc.KC = NCo;
end

cc.NF  = [NF,RATE];