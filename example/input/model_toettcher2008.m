function [toettcher2008] = model_toettcher2008

% Lade Zeitvektor vom m-Model
timev=model_toettcher2008matlab();

% Importiere Zellmodell
toettcher2008 = IQMmodel('model_toettcher2008.txt');

% Starte Simulation mit Zeitvektor von MATLAB-Model
toettcher2008 = IQMsimulate(toettcher2008, timev.x);
end
