function [ y_DNA ] = DNAcontent(time,T )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Mitotic Index
%
% I = ((P+M+A+T)/N) *100%
% P = Prophase / M = Metaphase / A = Anaphase / T = Telophase / N =Cells
%

two=(1:length(time));
two(1:length(time)) = 2;

four=(1:length(time));
four(1:length(time)) = 4;
%T = cell2mat(T);
%y_DNA = cell(1,length(time)-1);

%y_DNA = zeros(1,T);
%for k = 1:length(T)
    %z = T(1,k);
     % T = Period of the cell cycle
p_g1 = T*0.5; % Duration G1-Phase
p_g2 = T*0.16; % Duration G2-Phase
p_gm = T*0.04; %p_gm Duration M-Phase
p_s = T - p_g1 - p_g2 - p_gm;%z*0.3;  %Duration S-Phase
%slope = abs(2/(p_g2 - p_g1));
%t_1 = z/2;
%t_2 = 0.8*z;
%slope = (2/(t_2 - t_1));
slope = (2/(p_s));
%slpe = (length(time>=p_g1):length(time<(p_g1+p_s)));
%slpe(1:length(time)) = 2;
slpe = (slope.*time)+2;
%slpe = two+slpe;
      
a=two((time >= 0) & (time < p_g1)); % 2N
b=slpe((time >= p_g1) & (time < (p_g1 + p_s))); % 2N -> 4N
c=four((time >= (p_g1 + p_s)) & (time < T)); % 4N

%a = piecewise(2, 0<=time<p_g1*T,0);
%b = piecewise(slope*time+a, p_g1*T<= time <= (p_g1+p_s)*T, 0);
%c = piecewise(4,(p_g1+p_s)*T <= time <=T,0);

% function  y = piecewise(time)
% % First interval
% y(find(0<= time & time < p_g1)) = 2;
% 
% % Second interval
% time2 = time(p_g1 <= time & time < p_g1+p_s);
% y(find(p_g1 <= time & time < p_g1+p_s)) = slope*time2 + 2;
% 
% % Third interval
% time3 = time((p_g1+p_s)*T <= time & time <= T);
% y(find(p_g1+p_s)*T <= time & time <= T) = 4;

y_DNA = [a,b,c];
%plot(y_DNA);
end


