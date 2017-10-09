function tex2standalone(texname)
% This function generates a preformatted Latex script.
% The generated Latex script is a standalone script in order to precompile 
% .tex-files which where generated with 3rd party toolbox matlab2tikz.
%
% [SYNTAX]
% tex2standalone(texname)
% [INPUT]
% texname:    string
% 
% [OUTPUT]
% Standalone .tex file
% 
% [EXAMPLE]
% tex2standalone('blubb.tex')
% 
% blubb_r.tex
% which contains:
% \documentclass{standalone}
% \usepackage{pgfplots}
% \pgfplotsset{compat=newest}
% \pgfplotsset{plot coordinates/math parser=false}
% \newlength\figureheight
% \newlength\figurewidth
% \begin{document}
% \input{
% blubb.tex
% }
% \end{document}
%
%   +++++++++++++ ATTENTION +++++++++++++++
% This function requires MATLAB 2017a or later!


[directory,filename,extension]=fileparts(texname);
input_name = [filename extension];
output_name = [filename '_r' extension];
if ~isempty(directory)
cd(directory)
else
    cd .
end

fid=fopen(output_name,'w');
test = "\documentclass{standalone}";
test = test + newline + "\usepackage{pgfplots}";
test = test + newline + "\pgfplotsset{compat=newest}";
test = test + newline + "\pgfplotsset{plot coordinates/math parser=false}";
test = test + newline + "\newlength\figureheight";
test = test + newline + "\newlength\figurewidth";
test = test + newline + "\begin{document}";
test = test + newline + "\input{";
test = test + newline + input_name;
test = test + newline + "}";

test = test + newline + "\end{document}";
fprintf(fid, '%s\n\r',test);
fclose(fid);
if ~isempty(directory)
cd ..;
else
end
end

