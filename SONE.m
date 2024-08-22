%% Function to transform data to good input for SONE algorithm

function data = SONE(time,pres,lat,lon,temp,psal,aou)
% function data = SONE(time,pres,lat,lon,temp,psal,aou)

% By Liniger et al (XXXX)
% MBARI / liniger@mbari.org

% Bayesian neural network to estimate [NO3] in the Southern Ocean
% The structure is very similar to Bittig et al. (2018)

% Please cite paper when using this function, or the [NO3] dataset resulting from
% Liniger et al. (XXXX)

% In the paper, we average output of 5 neural networks to obtain our [NO3] gridded product. This function runs
% your data to be transformed as good input for the NNs. 
% NNs variables are: net_1010, net_1020, net_2010, net_1515, net_2020. The
% weights and bias for every NN are stored in the said NN files.

% INPUT
% 1. time - date /  matlab format (UTC) (example: if date is 15-Jan-2014,
% date input must be 735614)
% 2. pres - pressure / dbar
% 3. lat - latitude / °N
% 4. lon - longitude / °E (-180to180)
% 5. temp - temperature  / °C 
% 6. psal - practical salinity  
% 7. aou - Apparent Oxyge Utilization

% If you have dissolved oxygen and not AOU as an input, suggested AOU
% calculation from function:
% https://www.mbari.org/technology/matlab-scripts/oceanographic-calculations/ 

% If input data is a matrix, data need to be organized m rows x n
% columns with m rows being the variables, i.e row1 = time, row2 = pres ,
% [...], row7 = aou. Columns (n) are unique data point with co-located predictors.
% You need all co-located predictors for a given data point, if one data is missing, the entire
% colum need to be removed as NaN are not taken into account in the NN.
% You could choose to have input as single vectors too.

% OUTPUT
% Transformed data before putting them in the NN 

% Transform Time following Sauzede et al 2017
d = datevec(time);
d1= datetime(d(:,1:3));
doy = day(d1,'dayofyear');
dy(1,:) = (doy * pi) / 182.625;
clear d d1 doy

% Pressure following Sauzede et al 2017
for i = 1:length(pres)
press_corr(1,i) = (pres(i)/20000) + (1 / ((1 + exp(-pres(i)/300))^3));
end

clear i

% Transform Longitude following Carter et al 2021
lon1 = cosd(lon - 20);
lon2 = cosd(lon - 110);

% Step2. Create data sequence
data=cat(1,dy,press_corr,lat,lon1,lon2,temp,psal,aou);
disp('The data is ready and good to be put in the NNs to estiamte Nitrate')

% Your data should be ready! Now go to 'code_SONE' from Step3. to finish





