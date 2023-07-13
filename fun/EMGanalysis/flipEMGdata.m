function [flippedEMGData] =flipEMGdata(EMGdata, phaseDim,muscleDim)
%This function swaps the first and second half of EMGdata along phaseDim, 
%but only for the SECOND half of the array EMGdata along dimension muscleDim
N=size(EMGdata,muscleDim);
EMGdata1=sliceArray(EMGdata,1:N/2,muscleDim); %data for first half of the muscle
EMGdata2=sliceArray(EMGdata,(N/2+1):N,muscleDim); %data for 2nd half of the muscle
flippedEMGData=cat(muscleDim, EMGdata1, fftshift(EMGdata2,phaseDim)); %put back together in original dimension, but 2nd half of the muscle have interval 7-12 in the front of 1-6 (this is to align L/R leg to the same time point e.g., Slow heelstrike)
end

