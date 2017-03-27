function [ y_DNA ] = DNAcontent(time,T, G1,S )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Mitotic Index
%
% I = ((P+M+A+T)/N) *100%
% P = Prophase / M = Metaphase / A = Anaphase / T = Telophase / N =Cells
%

%two=(1:length(time));
%two(1:length(time)) = 2;
%two = 2;

%four=(1:length(time));
%four(1:length(time)) = 4;
%four = 4;

%T = cell2mat(T);
%y_DNA = cell(1,length(time)-1);


%for k = 1:length(T)
    %z = T(1,k);
     % T = Period of the cell cycle
p_g1 = 11; %G1; %T*0.5; % Duration G1-Phase
%p_g2 = T*0.16; % Duration G2-Phase
%p_gm = T*0.04; %p_gm Duration M-Phase
p_s = 13; %S; %13; %S; %T - p_g1 - p_g2 - p_gm;%z*0.3;  %Duration S-Phase
%slope = abs(2/(p_g2 - p_g1));
%t_1 = T/2;
%t_2 = 0.8*T;
slope = (2/(p_g1 - p_s));
%slope = (two./(p_s));
%slpe = (length(time>=p_g1):length(time<(p_g1+p_s)));
%slpe(1:length(time)) = 2;
%slpe = two+slope; %(slope.*time);
%slpe = two+slpe;
y_DNA = zeros(1,length(time));
f_1=@(time)(2);
f_2=@(time)(4);
f_3=@(time)(slope*time+(2-time*slope));
y_DNA(time<p_g1) = f_1(time);
y_DNA(p_g1<= time < p_s) = f_3(time); 
y_DNA(time > p_s) = f_2(time);

      
%a=two((time >= 0) & (time < p_g1)); % 2N
%b=b((time >= p_g1) & (time < (p_g1 + p_s))); % 2N -> 4N
%c=four((time >= (p_g1 + p_s)) & (time < T)); % 4N

%alength = length(a);
%clength = length(c);
%tlength = length(time);
%blength = tlength - alength - clength;
%b = 2:(2/(blength-1)):4;

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

%y_DNA = [a,b,c]; %A PROBLEM IS TO SOLVED HERE!!!!
%plot(y_DNA);
end


