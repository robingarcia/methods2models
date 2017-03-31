function [ y_DNA ] = DNAcontent(time,T,G1,S)
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
G1 = T*G1; %G1; %T*0.5; % Duration G1-Phase
%p_g2 = T*0.16; % Duration G2-Phase
%p_gm = T*0.04; %p_gm Duration M-Phase
S = T*S; %S; %13; %S; %T - p_g1 - p_g2 - p_gm;%z*0.3;  %Duration S-Phase
%slope = abs(2/(p_g2 - p_g1));
%t_1 = T/2;
%t_2 = 0.8*T;
slope = (2/(S - G1));
%slope = (two./(p_s));
%slpe = (length(time>=p_g1):length(time<(p_g1+p_s)));
%slpe(1:length(time)) = 2;
%slpe = two+slope; %(slope.*time);
%slpe = two+slpe;
y_DNA = zeros(1,length(time));
f_1=@(time)(2);
f_2=@(time)(4);
f_3=@(time)(slope.*time+(2-(slope*G1)));

y_DNA(time < G1) = f_1(time);
y_DNA(time > S) = f_2(time);
y_DNA(time >= G1 & time <= S) = f_3(time(time >= G1 & time <= S));

end


