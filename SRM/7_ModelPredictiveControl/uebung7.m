clc; clear;
addpath(genpath("Aufgabe_7_Modell"))

%% Uebung 7

init_simulation;
i = 1;
[G, H] = dio(model.B, model.A, i)
[Gd, Hd] = dio(model.Bd, model.Ad, i)
[E, F] = dio(model.C, model.D, i)
