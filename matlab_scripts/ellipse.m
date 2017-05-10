% test for ellipse

% daten
%data = rand(8000,3);

% ballgröße
%ballsize = [0.2,0.2, 0.2];
ballsize = [1,5,3]*0.1;

% ballzentrum
%center = [0.5,0.3,0.5];

% verschieben
X_Cor = bsxfun(@minus, data, center);

% quadrieren
X_Cor2 = bsxfun(@times, X_Cor.^2, 1./ballsize.^2);

% im ball
inball = sum(X_Cor2,2) < 1;

% Test
scatter3(data(:,1),data(:,2),data(:,3),'b.')
hold on
scatter3(data(inball,1),data(inball,2),data(inball,3),'ro')

legend('all data','in ball') 