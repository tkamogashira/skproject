function [C, H] = struct2char(S, Ns);
% struct2char - convert struct w char-valued fields to aligned char matrix
%    [C, H] = struct2char(S, Nspace) constructs a char matrix whose rows contain
%    the field values of the elements of S, aligned and separated by at
%    least Nspace blanks. H is a header containing the fieldnames, aligned
%    the same way as C. 
%
%    The char-matrix format is conveniently used as the String property of 
%    a listbox uicontrol.
%
%    See also structview.

Ns = arginDefaults('Ns',3);

S = S(:);
FNS = fieldnames(S);
Nrow = numel(S);
Ncol = numel(FNS);
Sep = repmat(' ', Nrow, Ns); % whitespace separating the columns

C = ''; H = '';
for ifld=1:Ncol,
    fn = FNS{ifld};
    Col = {S.(fn)};
    iempty = cellfun(@isempty, Col);
    if any(isnumeric([Col{~iempty}])), % convert numbers to strings
        Col = cellfun(@num2str, Col, 'UniformOutput', 0);
    end
    % replace empty entries by space to avoid size mismatches
    [Col{iempty}] = deal(' ');
    Col = strvcat(Col{:});
    C = [C, Col];
    C = [C, Sep];
    colWidth = size(Col,2)+Ns;
    h = [fn repmat(' ',1, 512)];
    h = h(1:colWidth);
    H = [H, h];
end


