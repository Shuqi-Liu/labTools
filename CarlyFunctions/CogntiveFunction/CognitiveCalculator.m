function [ CompiledCog CompiledCogLabels] = CognitiveCalculator( subs, plotflag )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for i=1:length(subs)
    [wcs wcslabels]=WCSAnalysis(subs{i}, plotflag);
    [trip triplabels]= TripletsAnalysis(subs{i}, plotflag);
    [swm swmlabels]= SWMAnalysis(subs{i});
end
CompiledCog=[wcs trip swm];
CompiledCogLabels= [wcslabels, triplabels, swmlabels];
end

