%% Code to use SONE algorithm

% Details on how to set up the input data are described in the SONE
% function. The function is to tansform the data, not applying the
% algorithm! This code applies the algorithm

% You will need to have AOU as your initial data.

%% Step1. Load the different neural networks that we trained from Southern Ocean BGC-Argo data
% You will need to set up the path where you saved the NNs! Or just load
% them manually

load .../net_1010
load .../net_1020
load .../net_2010
load .../net_2020
load .../net_1515

%% Step2. Prepare you data before putting it into the Neural Network
% Remember: These NNs were trained for the Southern Ocean!

% The function is: data = SONE(time,pres,lat,lon,temp,psal,aou)
% If you have your data in a table, just replace by the row number
% Example: If your longitude is in row3 in your file '
% data, just put 'data(3,:)' in the below line

% Run your data through the function to transform them
data = SONE(time,pres,lat,lon,temp,psal,aou);

%% Step3. Now that the data are transformed, put them in the NNs and averaged the NO3 output

% The performance of each NN is described in Liniger et al. (submitted. Aug 2024)
% For more details, see Liniger et al. (XXXX).

no3a = net_1010(data);
no3b = net_1020(data);
no3c = net_2010(data);
no3d = net_2020(data);
no3e = net_1515(data);

no3all = cat(1,no3a,no3b,no3c,no3d,no3e);

% Average the output
for i = 1:length(data(1,:))

    no3_av(1,i) = mean(no3all(:,i));

end

clear no3a no3b no3c no3d no3e

% no3_av gives you the averaged predicted NO3 for each corresponding
% co-located data point that you have as input!



