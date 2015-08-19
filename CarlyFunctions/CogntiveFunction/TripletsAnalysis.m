function [ CompiledCog CompiledCogLabel] = WCSAnalysis( sub, plotFlag )
%function [GenAcc GenRT SwitchAcc SwitchRT AccDiff RTDiff]=TripletAnalysis(name)

%exception cognitve data
if strcmp(sub, 'Forget03')==1
    name=[sub '_Triplets.xlsx'];[num,txt,raw]=xlsread(name);
    name=[sub '_Trip1_practice.xlsx'];[num1,txt1,raw1]=xlsread(name); %Missing this data...
    name=[sub '_Trip2.xlsx'];[num2,txt2,raw2]=xlsread(name);
    name=[sub '_Trip3.xlsx'];[num3,txt3,raw3]=xlsread(name);
else %Not an exception
    name=[sub '_Triplets.xlsx'];[num,txt,raw]=xlsread(name);
    name=[sub '_Trip1.xlsx'];[num1,txt1,raw1]=xlsread(name);
    name=[sub '_Trip2.xlsx'];[num2,txt2,raw2]=xlsread(name);
    name=[sub '_Trip3.xlsx'];[num3,txt3,raw3]=xlsread(name);
end

%% Measures that I have
%'TextDisplay1.ACC' indicates if the match was corred (1 and 0)
correct=num(:,44);


%RT for High and Low Frequency probabilities

if exist('txt4')==1 %This is for switch02 who did the same number of trial but in 4 sessions
    freq=[txt1(3:end, 54); txt2(3:end, 54); txt3(3:end, 54); txt4(3:end, 54)];
    RTTottal=[num1(:,31); num2(:,31); num3(:,31); num3(:,31) ];
    ResonseKey= [txt1(3:end, 35); txt2(3:end, 35); txt3(3:end, 35); txt4(3:end, 35)];
    n=size(num1,1)+size(num2,1)+size(num3,1)+size(num4,1);
    correctBase=[num1(:,32); num2(:,32); num3(:,32); num4(:,32)];
else
    correctBase=[num1(:,32); num2(:,32); num3(:,32) ];
    n=size(num1,1)+size(num2,1)+size(num3,1);
    freq=[txt1(3:end, 54); txt2(3:end, 54); txt3(3:end, 54)];
    RTTottal=[num1(:,31); num2(:,31); num3(:,31) ];
    ResonseKey= [txt1(3:end, 35); txt2(3:end, 35); txt3(3:end, 35)];
end
for t=1:n
    if strcmp(freq{t}, 'H')==1 && correctBase(t)==1
        highRT(t, 1)=RTTottal(t);highAcc(t, 1)=correctBase(t);
        lowRT(t, 1)=NaN; lowAcc(t, 1)=NaN;
        trillRT=NaN; trillAcc=NaN;
        repRT=NaN; repAcc=NaN;
        omission(t,1)=NaN;
    elseif strcmp(freq{t}, 'L')==1 && correctBase(t)==1
        lowRT(t, 1)=RTTottal(t);lowAcc(t, 1)=correctBase(t);
        highRT(t, 1)=NaN;highAcc(t, 1)=NaN;
        trillRT=NaN; trillAcc=NaN;
        repRT=NaN; repAcc=NaN;
        omission(t,1)=NaN;
    elseif strcmp(freq{t}, 'R')==1 && correctBase(t)==1
        repRT=RTTottal(t);repAcc(t, 1)=correctBase(t);
         highRT(t, 1)=NaN; highAcc(t, 1)=NaN;
        lowRT(t, 1)=NaN; lowAcc(t, 1)=NaN;
         trillRT=NaN; trillAcc=NaN;
         omission(t,1)=NaN;
     elseif strcmp(freq{t}, 'T')==1 && correctBase(t)==1
        trillRT=RTTottal(t); trillAcc(t, 1)=correctBase(t);
         highRT(t, 1)=NaN; highAcc(t, 1)=NaN;
        lowRT(t, 1)=NaN; lowAcc(t, 1)=NaN;
        repRT=NaN; repAcc=NaN;
        omission(t,1)=NaN;
    elseif  correctBase(t)==0
        
        highRT(t, 1)=NaN; 
        lowRT(t, 1)=NaN; 
        trillRT=NaN;
        repRT=NaN; 
        
        if strcmp(ResonseKey(t), '')==1
            omission(t,1)=NaN;
        else%was an omission error
        omission(t,1)=1;
        end
        
        if strcmp(freq{t}, 'H')==1
            highAcc(t, 1)=0;
            lowAcc(t, 1)=NaN;
            trillAcc(t,1)=NaN;
            repAcc(t,1)=NaN;
        end
        if strcmp(freq{t}, 'L')==1
            lowAcc(t, 1)=0;
            highAcc(t, 1)=NaN;
            trillAcc(t,1)=NaN;
            repAcc(t,1)=NaN;
        end
        if strcmp(freq{t}, 'T')==1
            trillAcc(t,1)=0;
            highAcc(t, 1)=NaN;
            lowAcc(t, 1)=NaN;
            repAcc(t,1)=NaN;
        end
        if strcmp(freq{t}, 'R')==1
            repAcc(t,1)=0;
            highAcc(t, 1)=NaN;
            lowAcc(t, 1)=NaN;
            trillAcc(t,1)=NaN;
        end
    end
end

%highRTEarly=mean(highRT(find(isnan(highRT)==0, 5, 'first')));
if length(highRT)<750
    display('I AM ASSUMING THAT THE FIRST EXPOSURE IF MISSING!')
    highRTEarly=nanmean(RTTottal(1:5));
    highAccEarly=nanmean(correctBase(1:5));
    lowRTEarly=nanmean(RTTottal(1:5));
    lowAccEarly=nanmean(correctBase(1:5));
    highRTSS1=nanmean(highRT(6:55));
    highAccSS1=nanmean(highAcc(6:55));
    lowRTSS1=nanmean(lowRT(6:55));
    lowAccSS1=nanmean(lowAcc(6:55));
else
    highRTEarly=nanmean(RTTottal(1:10));
    highAccEarly=nanmean(correctBase(1:10));
    lowRTEarly=nanmean(RTTottal(1:10));
    lowAccEarly=nanmean(correctBase(1:10));
    highRTSS1=nanmean(highRT(200:250));
    highAccSS1=nanmean(highAcc(200:250));
    lowRTSS1=nanmean(lowRT(200:250));
    lowAccSS1=nanmean(lowAcc(200:250));
    
end


highRTSS2=nanmean(highRT(450:500));
highRTSS3=nanmean(highRT(end-49:end));
highRTDelta1=(highRTEarly-highRTSS1);
highRTDelta2=(highRTEarly-highRTSS2);
highRTDelta3=(highRTEarly-highRTSS3);

%highAccEarly=mean(highAcc(find(isnan(highAcc)==0, 5, 'first')));


highAccSS2=nanmean(highAcc(450:500));
highAccSS3=nanmean(highAcc(end-49:end));
highAccDelta1=(highAccEarly-highAccSS1);
highAccDelta2=(highAccEarly-highAccSS2);
highAccDelta3=(highAccEarly-highAccSS3);

%lowRTEarly=mean(lowRT(find(isnan(lowRT)==0, 5, 'first')));


lowRTSS2=nanmean(lowRT(450:500));
lowRTSS3=nanmean(lowRT(end-49:end));
lowRTDelta1=(lowRTEarly-lowRTSS1);
lowRTDelta2=(lowRTEarly-lowRTSS2);
lowRTDelta3=(lowRTEarly-lowRTSS3);

%lowAccEarly=mean(lowAcc(find(isnan(lowAcc)==0, 5, 'first')));


lowAccSS2=nanmean(lowAcc(450:500));
lowAccSS3=nanmean(lowAcc(end-49:end));
lowAccDelta1=(lowAccEarly-lowAccSS1);
lowAccDelta2=(lowAccEarly-lowAccSS2);
lowAccDelta3=(lowAccEarly-lowAccSS3);

if plotFlag

figure
subplot(2,2,1)
plot(highRT, '*r');hold on
plot(lowRT, '*b')
plot(trillRT, '*k')
plot(repRT, '*k')
plot([1 250 500 750], [highRTEarly highRTSS1 highRTSS2 highRTSS3], '-ko','LineWidth',3, 'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','r'); hold on
plot([1 250 500 750], [lowRTEarly lowRTSS1 lowRTSS2 lowRTSS3],'-ko','LineWidth',3,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','b')
title('RT Evolution')

subplot(2,2,2)
% plot(highAcc, '*r'); hold on
% plot(lowAcc, '*b')
% plot(trillAcc, '*k')
% plot(repAcc, '*k')
plot([1 250 500 750], [highAccEarly highAccSS1 highAccSS2 highAccSS3], '-ko','LineWidth',3, 'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','r'); hold on
plot([1 250 500 750], [lowAccEarly lowAccSS1 lowAccSS2 lowAccSS3],'-ko','LineWidth',3,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','b')
legend('High Frequency Triplets', 'Low Frequency Triplets', 'Location', 'south')
title('Acc Evolution')

subplot(2,2,3)
plot([250 500 750], [highRTDelta1 highRTDelta2 highRTDelta3], '-ko','LineWidth',3, 'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','r'); hold on
plot([250 500 750], [lowRTDelta1 lowRTDelta2 lowRTDelta3],'-ko','LineWidth',3,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','b')
title('Delta RT Evolution')

subplot(2,2,4)
plot([250 500 750], [highAccDelta1 highAccDelta2 highAccDelta3], '-ko','LineWidth',3, 'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','r'); hold on
plot([250 500 750], [lowAccDelta1 lowAccDelta2 lowAccDelta3],'-ko','LineWidth',3,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','b')
title('Delta Acc Evolution')


% figure % Will show omissions are error
% plot(highRT, '*r');hold on%Correct High
% plot(lowRT, '*b'); %Correct low
% plot(omission, 'ok', 'MarkerFaceColor', 'k')%omissions

end

BaselineAccuracy=nanmean(correctBase);
lowMean=nanmean(lowRT);
highMean=nanmean(highRT);
repMean=nanmean(repRT);
trillMean=nanmean(trillRT);
%'TextDisplay1.RT' indicates ms?  or do I want 'TextDisplay1.RTTime'
RT=num(:,51);
%% Measure that I want

%General Accuracy
ImplicitAcc=nanmean(correct);

%need to know if it was frequent, and wether they rated it as frequent or
%infrequent
for i=1:64
    if strcmp(txt(i+2, 58), 'H')==1 && strcmp(txt(i+2, 51), 'm')==1 %high frequency triplet and answer high frequecy
        MeanRatingHighT(i)=2;
        MeanRatingLowT(i)=NaN;
         MeanRatingRepT(i)=NaN;
         MeanRatingTrillT(i)=NaN;
    elseif strcmp(txt(i+2, 58), 'H')==1 && strcmp(txt(i+2, 51), 'x')==1 %high frequency triplet and answer low frequecy
        MeanRatingHighT(i)=1;
        MeanRatingLowT(i)=NaN;
         MeanRatingRepT(i)=NaN;
         MeanRatingTrillT(i)=NaN;
    elseif strcmp(txt(i+2, 58), 'L')==1 && strcmp(txt(i+2, 51), 'm')==1 %low frequency triplet and answer high frequecy
        MeanRatingHighT(i)=NaN;
        MeanRatingLowT(i)=2;
         MeanRatingRepT(i)=NaN;
         MeanRatingTrillT(i)=NaN;
    elseif strcmp(txt(i+2, 58), 'L')==1 && strcmp(txt(i+2, 51), 'x')==1 %low frequency triplet and answer low frequecy
        MeanRatingHighT(i)=NaN;
        MeanRatingLowT(i)=1;
         MeanRatingRepT(i)=NaN;
         MeanRatingTrillT(i)=NaN;
    elseif strcmp(txt(i+2, 58), 'R')==1 && strcmp(txt(i+2, 51), 'm')==1 %repetition triplet and answer high frequecy
        MeanRatingHighT(i)=NaN;
        MeanRatingLowT(i)=NaN;
        MeanRatingRepT(i)=2;
        MeanRatingTrillT(i)=NaN;
    elseif strcmp(txt(i+2, 58), 'R')==1 && strcmp(txt(i+2, 51), 'x')==1 %repitition triplet and answer low frequecy
        MeanRatingHighT(i)=NaN;
        MeanRatingLowT(i)=NaN;
        MeanRatingRepT(i)=1;
        MeanRatingTrillT(i)=NaN;
    elseif strcmp(txt(i+2, 58), 'T')==1 && strcmp(txt(i+2, 51), 'm')==1 %trill  triplet and answer high frequecy
        MeanRatingHighT(i)=NaN;
        MeanRatingLowT(i)=NaN;
         MeanRatingRepT(i)=NaN;
          MeanRatingTrillT(i)=2;
    elseif strcmp(txt(i+2, 58), 'T')==1 && strcmp(txt(i+2, 51), 'x')==1 %trill triplet and answer low frequecy
        MeanRatingHighT(i)=NaN;
        MeanRatingLowT(i)=NaN;
         MeanRatingRepT(i)=NaN;
         MeanRatingTrillT(i)=1;
    end
end
MeanRatingHigh=nanmean(MeanRatingHighT);
MeanRatingLow=nanmean(MeanRatingLowT);
MeanRatingRep=nanmean(MeanRatingRepT);
MeanRatingTrill=nanmean(MeanRatingTrillT);

%At some point may want to normalize based on the 'SR-Box' pard

%testingData=rand(1,10000)>.5;
testingData=rand(1,10000)>.75;
%takingFrom=randi([1 10000],1,1000);
takingFrom=[1:2:10000];
mean(testingData(takingFrom))

CompiledCog=[ImplicitAcc MeanRatingHigh MeanRatingLow MeanRatingRep MeanRatingTrill BaselineAccuracy lowMean highMean...
    highRTEarly highRTSS1 highRTSS2 highRTSS3...
    highRTDelta1 highRTDelta2 highRTDelta3...
    lowRTEarly lowRTSS1 lowRTSS2 lowRTSS3...
    lowRTDelta1 lowRTDelta2 lowRTDelta3...
    highAccEarly highAccSS1 highAccSS2 highAccSS3...
    lowAccEarly lowAccSS1 lowAccSS2 lowAccSS3...
    highAccDelta1 highAccDelta2 highAccDelta3...
    lowAccDelta1 lowAccDelta2 lowAccDelta3];

CompiledCogLabel={'ImplicitRecAcc', 'ImplicitRecHigh', 'ImplicitRecLow', 'ImplicitRecRep', 'ImplicitRecTrill',...
    'ImplicitExpoAcc', 'ImplicitExpoRTHigh', 'ImplicitExpoRTLow',...
    'ImplicithighRTEarly', 'ImplicithighRTSS1', 'ImplicithighRTSS2', 'ImplicithighRTSS3',...
    'ImplicithighRTDelta1', 'ImplicithighRTDelta2', 'ImplicithighRTDelta3',...
    'ImplicitlowRTEarly', 'ImplicitlowRTSS1', 'ImplicitlowRTSS2', 'ImplicitlowRTSS3',...
    'ImplicitlowRTDelta1', 'ImplicitlowRTDelta2', 'ImplicitlowRTDelta3',...
    'ImplicithighAccEarly', 'ImplicithighAccSS1', 'ImplicithighAccSS2', 'ImplicithighAccSS3',...
    'ImplicitlowAccEarly', 'ImplicitlowAccSS1', 'ImplicitlowAccSS2', 'ImplicitlowAccSS3',...
    'ImplicithighAccDelta1', 'ImplicithighAccDelta2', 'ImplicithighAccDelta3',...
    'ImplicitlowAccDelta1', 'ImplicitlowAccDelta2', 'ImplicitlowAccDelta3'};

% EXCEL1=[highRTSS3 lowRTSS3 highAccSS3 lowAccSS3 highRTDelta3 lowRTDelta3 highAccDelta3 lowAccDelta3];
% EXCEL2=[highRTSS1 highRTSS2 highRTSS3 lowRTSS1 lowRTSS2 lowRTSS3... 
%     highRTDelta1 highRTDelta2 highRTDelta3 lowRTDelta1 lowRTDelta2 lowRTDelta3];