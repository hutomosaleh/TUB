function [AM, sun_elevation, sun_azimuth] = SunDate(latitude, longitude, DOY, LT, TZ)
    J = 360 * DOY / 365;  % Day angle [?]
    declination = 0.3948 ...  % [?]
                  - 23.2559 * cosd(J + 9.1) ...
                  - 0.3915 * cosd(2*J + 5.4) ...
                  - 0.176 * cosd(3*J + 26);

    % Time Equation (In Minutes)
    TEQ = (0.0066 + 7.3525 * cosd(J + 85.9) ...
          + 9.9359 * cosd(2*J + 108.9) ...
          + 0.3387 * cosd(3*J + 105.2));

    % Preallocate matrix size
    AM = zeros(1, length(LT));
    sun_azimuth = zeros(1, length(LT));
    sun_elevation = zeros(1, length(LT));

    for i = 1:length(LT)
        % True local time (in Hour)
        TLT = LT(i) - TZ + (4 * longitude + TEQ) / 60;
        % Hour angle
        w = (12 - TLT) * 15;
        % Sun elevation 0? - 90?
        sun_elevation(i) = asind(cosd(w) * cosd(latitude) * cosd(declination) ...
                        + sind(latitude) * sind(declination));
        % Air mass
        AM(i) = 1 / sind(sun_elevation(i));
        % Sun azimuth
        azimuth = acosd((sind(sun_elevation(i)) * sind(latitude) - sind(declination)) ...
                  / (cosd(sun_elevation(i)) * cosd(latitude)));
        if (TLT > 12)
            sun_azimuth(i) = 180 + azimuth;
        else
            sun_azimuth(i) = 180 - azimuth;
        end
    end
end