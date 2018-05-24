function code = genmcode(this)
%GENMCODE   Generate M-code

%   Author(s): J. Schickler
%   Copyright 1999-2010 The MathWorks, Inc.

code = sigcodegen.mcodebuffer;

if issupported(this),

    Hd = get(this, 'Filter');

    if isa(Hd, 'mfilt.abstractcic')
        code.addcr('set(Hd, ...');
        code.addcr('    ''InputWordLength'',    %d, ...', Hd.InputWordLength);
        code.addcr('    ''InputFracLength'',    %d, ...', Hd.InputFracLength);
        code.add('    ''FilterInternals'',    ''%s''', Hd.FilterInternals);

        if ~strcmpi(Hd.FilterInternals, 'fullprecision')
            code.addcr(', ...');
            code.add('    ''OutputWordLength'',   %d', Hd.OutputWordLength);
        end

        if any(strcmpi(Hd.FilterInternals, {'specifywordlengths', 'specifyprecision'}))
            code.addcr(', ...');
            code.add('    ''SectionWordLengths'', %s', mat2str(Hd.SectionWordLengths));
        end

        if strcmpi(Hd.FilterInternals, 'specifyprecision')
            code.addcr(', ...');
            code.addcr('    ''OutputFracLength'',   %d, ...', Hd.OutputFracLength);
            code.add('    ''SectionFracLengths'', %s', mat2str(Hd.SectionFracLengths));
        end

        code.add(');');
    elseif isa(Hd, 'mfilt.holdinterp')
        arith = Hd.Arithmetic;
        if strcmpi(arith, 'fixed')
            code.addcr('set(Hd, ''Arithmetic'', ''%s'', ...', Hd.Arithmetic);
            code.addcr('    ''InputWordLength'', %d, ...', Hd.InputWordLength);
            code.addcr('    ''InputFracLength'', %d);', Hd.InputFracLength);
        else
            code.addcr('set(Hd, ''Arithmetic'', ''double'');');
        end
    else
        arith = Hd.Arithmetic;
        if strcmpi(arith, 'fixed')
            code.addcr('% Set the arithmetic property.');
        end
        code.add('set(Hd, ''Arithmetic'', ''%s''', arith);
        % If the arithmetic is not fixed, there's nothing else.
        if strcmpi(arith, 'fixed')
            code.addcr(', ...');

            s = get(this, 'prevAppliedState');

            signed = mat2str(strcmpi(s.signed, 'on'));
            info   = qtoolinfo(Hd);
            norm   = isfield(info, 'normalize');
            if isfilterinternals(this)

                code.addcr(genmcode(getcomponent(this, 'coeff'), Hd, 'coeff', s.coeff));
                code.addcr('    ''Signed'',         %s, ...', signed);
                code.addcr(genmcode(getcomponent(this, 'input'), Hd, 'input', s.input));
                code.add('    ''FilterInternals'',  ''%s''', ...
                    filterInternalsMap(this.FilterInternals));

                if strcmpi(this.FilterInternals, 'full')
                    code.add(');');
                else
                    code.addcr(', ...');
                    code.addcr('    ''OutputWordLength'',  %d, ...', s.output.wordlength);
                    code.addcr('    ''OutputFracLength'',  %d, ...', s.output.fraclengths{1});
                    code.addcr('    ''ProductWordLength'', %d, ...', s.product.wordlength);
                    code.addcr('    ''ProductFracLength'', %d, ...', s.product.fraclengths{1});
                    code.addcr('    ''AccumWordLength'',   %d, ...', s.accum.wordlength);
                    code.addcr('    ''AccumFracLength'',   %d, ...', s.accum.fraclengths{1});
                    code.addcr('    ''RoundMode'',         ''%s'', ...', s.roundmode);
                    code.add('    ''OverflowMode'',      ''%s'');', s.overflowmode);
                end
            else

                % These aren't required so we have to add them ourselves.
                info.input.syncops  = [];
                info.output.syncops = [];

                if norm
                    info = rmfield(info, 'normalize');
                end

                f = fieldnames(info);

                for indx = 1:length(f)
                    cf = f{indx};
                    h = getcomponent(this, 'tag', cf);
                    tmpCode = genmcode(h, Hd, cf, s.(cf));
                    if ~isempty(tmpCode)
                      code.addcr(tmpCode);
                    end
                end

                code.addcr('    ''signed'',        %s, ...', signed);
                code.addcr('    ''RoundMode'',     ''%s'', ...', s.roundmode);
                code.add('    ''OverflowMode'',  ''%s''', s.overflowmode);

                if isempty(info.accum) || strcmpi(Hd.AccumMode, 'Full')
                    code.addcr(');');
                else
                    if strcmpi(s.castbeforesum, 'on'),
                        cbs = 'true';
                    else
                        cbs = 'false';
                    end

                    code.addcr(', ...');
                    code.addcr('    ''CastBeforeSum'', %s);', cbs);
                end

            end
            % Normalize or unnormalize the filter.
            code.cr;
            if norm
                if strcmpi(s.normalize, 'on')
                    code.addcr('normalize(Hd);');
                else
                    code.addcr('denormalize(Hd);');
                end
            end
        else
            code.add(');');
        end
    end
end

% -------------------------------------------------------------------------
function finternals = filterInternalsMap(finternals)

switch lower(finternals)
    case 'specify all'
        finternals = 'SpecifyPrecision';
    case 'full'
        finternals = 'FullPrecision';
    case 'minimum section word lengths'
        finternals = 'minwordlengths';
    case 'specify word lengths'
        finternals = 'specifywordlengths';
end

% [EOF]
