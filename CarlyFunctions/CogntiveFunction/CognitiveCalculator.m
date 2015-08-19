function [ CompiledCog CompiledCogLabels] = CognitiveCalculator( subs, plotflag )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for i=1:length(subs)
    [wcs(i, :) wcslabels(i, :)]=WCSAnalysis(subs{i}, plotflag);
    [trip(i, :) triplabels(i, :)]= TripletsAnalysis(subs{i}, plotflag);
    [swm(i, :) swmlabels(i, :)]= SWMAnalysis(subs{i}, plotflag);
end
CompiledCog=[wcs trip swm];
CompiledCogLabels= [wcslabels, triplabels, swmlabels];
end

