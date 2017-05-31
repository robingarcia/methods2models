function [ y_DNA ] = DNAcontent(time,T,G1,S)
%This function simulates the DNA duplication during cell cycle (2N -> 4N)
%The simulated DNA is needed in order to determine the start and the end of   
%the cell cycle.
% [SYNTAX]
% [ y_DNA ] = DNAcontent(time,T,G1,S)
% 
% [INPUT]
% time:       number: Time interval
% T:          number: Cell cycle period
% G1:         number: Length of G1 phase
% S:          number: Length of S phase
% 
% [OUTPUT]
% y_DNA:      number: Simulated DNA
% Example:

G1 = G1/T; % Neccessary??
S = S/T;   % Neccessary??

dS = T*(S-G1);  %Duration of S-Phase
G1 = T*G1;      % Duration G1-Phase
slope = 2/dS;   % Slope between 2N -> 4N
y_DNA = zeros(1,length(time));
f_3=@(time)(slope.*time+(2-(slope*G1)));
y_DNA(time < G1) = 2;
y_DNA(time > S*T) = 4;
y_DNA(time >= G1 & time <= S*T) = f_3(time(time >= G1 & time <= S*T));
end


