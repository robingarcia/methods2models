function M2M_timepointsP(p_value,samples)
%This function generates a plot of the inversion method
%A subplot which consists of two histograms is generated
%On the left side, there is the unifrom distribution. 
%On the right side, the is the new distribution.
%
% [SYNTAX]
% M2M_timepointsP(p_value,samples)
% 
% [INPUTS]
% p_value         Uniform distributed numbers
% samples         Random numbers which follows a particular distribution

%==========================================================================
%     methods2models
%     Copyright (C) 2017  Robin Garcia Victoria
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%==========================================================================
%% Single timepoints via inversion method
f = figure;
p = uipanel('Parent',f,'BorderType','none');  
p.TitlePosition = 'centertop'; 
p.FontSize = 12;
p.FontWeight = 'bold';

subplot(1,2,1,'Parent',p)
histogram(p_value(:,1),20);
grid on
title('Uniform distribution','Interpreter','latex')
ylabel('Number of cells')

subplot(1,2,2,'Parent',p)
histogram(samples(:,1),20);
grid on
title('New distribution $$f(a)=2 \gamma e^{- \gamma a}$$','Interpreter','latex')
xlabel('Periods (h)')
ylabel('Number of cells')
% matlab2tikz( 'inversion.tex', 'height', '\fheight', 'width', '\fwidth','floatFormat','%.3g' )
%% Uniform distribution
% histogram(p_value(:,1));
% grid on
% title('Uniform distribution')
% ylabel('Number of cells')
end

