function [E, F, G, H] = einSchrittVoraus(B, A, C, D, d, i)
    [E, F] = dio(A, B, i);
    [G, H] = dio(C, D, i-d+1);
end