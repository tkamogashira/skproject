function fibres_used = DSACXACextractor()

% DSACXACextractor
% extracts the fibres with different NRHO-datasets (thus data at more than one SPL) out of DSACXAC,
% writes a psLATgen-code for it and stores it in the file 'tekstvoorpslat.txt'
% it returns the name of this file
% 
% while the program is running, the number of the current row in DSACXAC is displayed
%
% TF 26/08/2005

storagefile = 'tekstvoorpslat.txt';
fibres_used = 0;

load psSACXAC;
D = DSACXAC;
n = numel(D);
M=[];

cDF=''; %current datafile
cCell=0; %current cell
cellevaluated=0;  % =1 if we're still with the same cell

currRow=0; % this is the row in the storage-file

for i=1:n
    
    disp(i);
    
    %the 3 lines text for psLATgen (this is in the for-loop to ensure that the values of line1,2,3 are each time set back to the original
    line0='%Fibre 0';
    line1='List = GenWFList(struct([]), ''A0454'', [2;3;4], [+1, -1], ''discernvalue'', ''getfield(dataset($filename$, $iseqp$), ''''spl'''')'');';
    line2='T = GenWFPlot(List, rangnummer, ''discernfieldlabel'', ''Intensity'', ''discernfieldunit'', ''dB SPL'',''plot'',''no''); % reference = ds referentie';
    line3='D = [D; ExtractPSentry(T, XFieldName, YFieldName)];';
    
    if D(i).ds1.filename~=cDF % we are in a new datafile
        cDF=D(i).ds1.filename;
        cCell=0;
    end
        
    if D(i).ds1.icell~=cCell % we're in a new cell
            cCell = D(i).ds1.icell;
    else %we're still in the same cell, thus the cell has already been evaluated
            cellevaluated=1;
    end
  
    
    if ~cellevaluated %if the cell has not yet been written
        
        [dsnrs,spls,refnr,refrank] = getDSSPL(D,i);
        
        if refnr~=0 % if cell is ok for use
           line0 = strrep(line0,'0',int2str(D(i).ds1.icell));
           line1 = strrep(line1,'A0454',D(i).ds1.filename);
           line1 = strrep(line1,'[2;3;4]', vec2String(dsnrs));
           line2 = strrep(line2,'rangnummer',int2str(refrank));
           line2 = strrep(line2,'referentie',int2str(refnr));
                
           M=str2mat(M,line0,line1,line2,line3,'');
           fibres_used = fibres_used + 1;
        end
     else
        cellevaluated=0;
     end
  end

dlmwrite(storagefile,M,'',0,0);

%--------------------------------------------------------------------------------------------------------
function [datasets, spls, refds, refrank] = getDSSPL(D,i)

%reads for a certain cell all the numbers of the datasets and the corresponding spl's
%a cell array is returned, with one row and 3 columns.
% element 1 = a vector with the dataset numbers
% element 2 = the corresponding spls
% element 3 = the reference dataset
% element 4 = a number, which gives the rank of the reference spl (=70dB)
%
% if there are multiple datasets with the same spl, the last one is chosen
% if there is no spl 70dB or just one dataset of the cell, empty matrices and values '0' are returned


cellnr=D(i).ds1.icell;
datasets=[];
refds=0;
spls=[];
refrank=0;
output={[],0,0};
refok=0;

for j=i:numel(D)
    if D(j).ds1.icell==cellnr % are we still at the same cell
        
        s = D(j).stim.spl;
        if ~isequal(find(spls==s(1)),[]), datasets(find(spls==s(1)))=D(j).ds1.iseq; %if there is already some dataset of this cell with the same spl, choose the latest dataset
        else
            datasets = [datasets D(j).ds1.iseq];
            spls = [spls s(1)];
        end
    end
        
    if (j==numel(D))|(D(j).ds1.icell~=cellnr) % return if we are at another cell or at the end of the list
        if (isequal(find(spls==70),[]))|(numel(datasets)==1) %if there is no 70 dB, datasets=[] and spls=[], refds=0, refnr=0
            datasets=[];
            spls=[];
            refds=0;
            refrank=0;
            return;
        else
            refds = datasets(find(spls==70));
            sortedspls = sort(spls);
            refrank=((numel(sortedspls)+1)-find(sortedspls==70));
            return;
        end
    end
end

%------------------------------------------------------------------------------------------------------------
function string = vec2String(vector);
%turns a number vector in a string, separated by ';' en with '[' in the beginning and ']' at the end

nv = numel(vector);
string = '';

for i=1:nv
    string = [string int2str(vector(i)) ';'];
end

%remove the last ';' and add '[' and ']'

ne = numel(string);
string=string(1:(ne-1));
string=['[' string ']'];

%------------------------------------------------------------------------------------------------------------

