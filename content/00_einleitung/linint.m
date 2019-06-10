function y=linint(t,tv,yv)
% Die Funktion linint interpoliert die in den Vektoren abgelegten Daten tv,yv linear.
% Dazu sollten die Daten in tv sortiert sein und ein t zwischen dem ersten
% und letzten Eintrag von tv eingegeben werden
%
% Eingabeparameter: tv, yv = Zeitpunkte und Messwerte,
% t = gewünschter Auswertezeitpunkt
% Ausgabeparameter: y = linear interpolierter Messwert zum Zeitpunkt t
%
%
n=length(tv); % ermittelt die Länge des Vektors bzw. die Anzahl der Messwerte
%
if t<tv(1) % ist t<tv(1) ?
    y=yv(1);
elseif t>tv(n) % ist t>tv(n) ?
    y=yv(n);
else % t liegt zwischen tv(1) und tv(n)
    for i=1:n-1 % for-Schleife
        if (t>=tv(i))&(t<=tv(i+1)) % t zwischen tv(i) und tv(i+1)
        % hier müssen Sie die Punkte ergänzen:
            y=3
        %
            return % vorzeitiges Verlassen der for-Schleife
        end
    end
end