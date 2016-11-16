function [toettcher2008] = model_toettcher2008iqm

% Lade Zeitvektor vom m-Model
%timev=final_model_modified();


% Importiere Zellmodell
toettcher2008 = IQMmodel('model_toettcher2008.txt');

% Starte Simulation
toettcher2008 = IQMsimulate(toettcher2008, x_T);
end
