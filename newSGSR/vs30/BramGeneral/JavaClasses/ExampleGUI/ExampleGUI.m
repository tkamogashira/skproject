function ExampleGUI(Flag, varargin)
%EXAMPLEGUI an example GUI that uses the JAVA Swing package.
%   EXAMPLEGUI starts up an example GUI that uses the JAVA Swing package and
%   also contains the callbacks for the GUI that need MATLAB intervention.

%B. Van de Sande 20-07-2005

persistent GUIhandle;

%If no flag is specified, initialization is assumed ...
if (nargin == 0), Flag = 'init'; end

%Switchyard ...
switch Flag
case 'init',
    %Initialization of GUI ...
    ScreenSize = get(0, 'ScreenSize');
    Width = ScreenSize(3)/2; Height = ScreenSize(4)/2;
    x = (ScreenSize(3)-Width)/2; y = (ScreenSize(4)-Height)/2;
    GUIhandle = javaObject('ExampleGUIJava', x, y, Width, Height, datadir);
case 'load',
    %Loading the spreadsheet of the GUI with data on request ...
    try, 
        S = log2lut(char(GUIhandle.getCurrentFullFileName));
        if isempty(S), error('To catch block ...'); end
        GUIhandle.setSpreadSheetData({S.iSeq}, {S.IDstr});
    catch,
        GUIhandle.clearSpreadSheetData;
    end
case 'show',
    %Display information on dataset in dialog box ...
    try,
        Str = disp(dataset(char(GUIhandle.getCurrentFullFileName), double(GUIhandle.getCurrentSeqNr)));
        javax.swing.JOptionPane.showMessageDialog(GUIhandle.getFrame, ...
            Str, 'ExampleGUI', javax.swing.JOptionPane.INFORMATION_MESSAGE);
    catch, 
        error(sprintf('Dataset %s <%s> could not be loaded.', ...
            char(GUIhandle.getCurrentFullFileName), char(GUIhandle.getCurrentSeqID))); 
    end
case 'sort',
    %Reloading the spreadsheet of the GUI with sorted data ...
    ColNr = varargin{1}; SeqNrs = cat(1, varargin{2}{:}); SeqIDs = varargin{3};
    if (ColNr == 0),
        [SeqNrs, idx] = sort(SeqNrs);
        SeqIDs = SeqIDs(idx);
    else,    
        [SeqIDs, idx] = sort(SeqIDs);
        SeqNrs = SeqNrs(idx);
    end
     GUIhandle.setSpreadSheetData(num2cell(SeqNrs), SeqIDs);
case 'thr',
    %Display threshold curve for current selected dataset ...
    try,
        dsTHR = dataset(char(GUIhandle.getCurrentFullFileName), double(GUIhandle.getCurrentSeqNr));
        EvalTHR(dsTHR);
    catch, 
        error(sprintf('Dataset %s <%s> could not be loaded or does not contain threshold curve.', ...
            char(GUIhandle.getCurrentFullFileName), char(GUIhandle.getCurrentSeqID))); 
    end    
otherwise, 
    error(sprintf('''%s'' is not a valid flag.', Flag)); 
end    