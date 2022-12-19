function [dp,cbins] = drawhist(X,M)
    if ~exist('M','var')
        % Valeur par défaut si M non fourni
                
        % Largeur ayant le meilleur compromis biais-variable
        dx = 3.49 * std(X) * length(X) ^ (-1/3);
        
        M = ceil((max(X) - min(X)) / dx); %nombre de bins associé é dx
        msg = "optimale";
    else
        % M fourni
        dx = (max(X) - min(X)) / M;     % On calcule dx é partir de M
        msg = "imposée";
    end
    
    [counts, cbins] = hist(X, M);    % On précise ici le nombre de bins de l'histogramme

    dp = counts./(length(X)*dx);    % On normalise l'histogramme en densité de probabilités
    
    % Affichage
    stem(cbins, dp); 
    hold on;
    xlabel(sprintf("\\Deltax = %f (%s)",dx, msg));
    title(sprintf("Estimation DP (\\Deltax=%d)", dx));
end

