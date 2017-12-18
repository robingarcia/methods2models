%% C-Matrix Berechnung Toettcher
C=WChooseK(1:27,2); %Reihenfolge ist egal
c = zeros(1, 28);
c(1,[3 4 9 10 30]) = 1;
i=1;
c(1,C(i,:))=1;
data_combi=c*data;
%% C-Matrix Berechnung Garcia
% Version 1
data_combi=C(2,:)*data;

% Version 2
data_combi=data(C(2,:));