function [ForExcel wcslabel] = WCSAnalysis( sub, plotflag )
%function [GenAcc GenRT SwitchAcc SwitchRT AccDiff RTDiff]=WCSAnalysis(name)
%This is how the data will be prcoessed from EPrime

%exception cognitve data
if strcmp(sub, 'Forget02')==1
    name=[sub '_WCS.xlsx'];[num,txt,raw]=xlsread(name);
    name=[sub '_color.xlsx'];[numBcolor]=xlsread(name);
    name=[sub '_shape.xlsx'];[numBshape]=xlsread(name);
    name=[sub '_count.xlsx'];[numBcount]=[];
else %Not an exception
    name=[sub '_WCS.xlsx'];[num,txt,raw]=xlsread(name);
    name=[sub '_color.xlsx'];[numBcolor]=xlsread(name);
    name=[sub '_shape.xlsx'];[numBshape]=xlsread(name);
    name=[sub '_count.xlsx'];[numBcount]=xlsread(name);
end

%% Measures that I have
%'Block' contains the trial numbers (#'s)
n=max(num(:,20));

%'Target.ACC' indicates if the match was corred (1 and 0)
correct=num(:,32);
numError=n-sum(correct);

%Set up baseline accuracies
nBaseline=max(numBcolor(:,20))-max(numBcolor(:,25));%because there are 2 practice trials
ColorAccBase=nansum(numBcolor(:,32))/nBaseline;
ShapeAccBase=nansum(numBshape(:,32))/nBaseline;
if isempty(numBcount)==1%This is for forget 02 who didn't have this baseline
    CountAccBase=nanmean([ColorAccBase ShapeAccBase])
else
    CountAccBase=nansum(numBcount(:,32))/nBaseline;
end

%'Rule' contains the matching rule (i.e., 'Color', 'Count', or 'Shape')
rule=txt(3:n+2, 26);
if strcmp(rule(1), '?')==1 %This probably only applies to OG96
    for t=1:n
        if strcmp(txt(2+t, 23), txt(2+t, 31))==1 %if the rule is match by shape
            rule{t}='Shape';
        elseif strcmp(txt(2+t, 23), txt(2+t, 24))==1 %if the rule is match by count
            rule{t}='Count';
        elseif strcmp(txt(2+t, 23), txt(2+t, 22))==1 %if the rule is match by color
            rule{t}='Color';
        end
    end
end

%For plotting purposes
for t=1:n
    if strcmp(txt(2+t, 23), txt(2+t, 31))==1 %if the rule is match by shape
        plotrule(t)=-1;
    elseif strcmp(txt(2+t, 23), txt(2+t, 24))==1 %if the rule is match by count
        plotrule(t)=0;
    elseif strcmp(txt(2+t, 23), txt(2+t, 22))==1 %if the rule is match by color
        plotrule(t)=1;
    end
end

for t=1:n
    %want to know the rule they were matching too even if wrong
    if strcmp(txt(2+t, 39), txt(2+t, 31))==1 %if key pressed matches shape answer
        ruleMatching2{t}='Shape';
    elseif strcmp(txt(2+t, 39), txt(2+t, 24))==1 %if key pressed matches count answer
        ruleMatching2{t}='Count';
    elseif strcmp(txt(2+t, 39), txt(2+t, 22))==1 %if key pressed matches color answer
        ruleMatching2{t}='Color';
    elseif strcmp(txt(2+t, 39), '')==1
        ruleMatching2{t}='';
    else
        ruleMatching2{t}='';
    end
end

switchTrial(1)=0; sameTrial(1)=0;sequence(1)=0;
for t=2:n
    if  strcmp(rule(t), rule(t-1))==1
        switchTrial(t)=0;
        sameTrial(t)=1;
    else
        switchTrial(t)=1;
        sameTrial(t)=0;
    end
    %Sequntial perseveration
    %If they are matching to the same rule twice in a row and both are
    %wrong
    if strcmp(ruleMatching2{t}, ruleMatching2{t-1})==1 && correct(t)==0 && correct(t-1)==0
        sequence(t)=1;
    else
        sequence(t)=0;
    end
end

nswitch=sum(switchTrial);
nsequence=sum(sequence);

%For plotting purposes
for t=1:n
    if strcmp(txt(2+t, 23), txt(2+t, 31))==1 %if the rule is match by shape
        plotrule(t)=-1;
    elseif strcmp(txt(2+t, 23), txt(2+t, 24))==1 %if the rule is match by count
        plotrule(t)=0;
    elseif strcmp(txt(2+t, 23), txt(2+t, 22))==1 %if the rule is match by color
        plotrule(t)=1;
    end
    if strcmp(txt(2+t, 39), txt(2+t, 31))==1 %if they were matchign to shape
        plotthought(t)=-1;
        omission(t)=NaN;
    elseif strcmp(txt(2+t, 39), txt(2+t, 24))==1 %if they were matchign to count
        plotthought(t)=0;
        omission(t)=NaN;
    elseif strcmp(txt(2+t, 39), txt(2+t, 22))==1 %if they were matchign to color
        plotthought(t)=1;
        omission(t)=NaN;
    else %i.e., they didn't respond to this trial
        plotthought(t)=NaN;
        omission(t)=plotrule(t);
    end
end

%Want to know the number of perseveration errors
%I will do this by finding the number of times subjects answered for the
%previous rule

perseverationTrial=zeros(find(switchTrial==1, 1, 'first'), 1);
previousrule=rule{1};
for t=find(switchTrial==1, 1, 'first'):n
    if strcmp(ruleMatching2(t), '')==1 % empty
        perseverationTrial(t)=NaN;
    elseif strcmp(rule(t), rule(t-1))==1 && strcmp(ruleMatching2(t), previousrule)==1 %the rule hasn't changed and you make a perseverations error
        perseverationTrial(t)=1;
        IllogicalPerseverationT(t)=1;
    elseif strcmp(rule(t), rule(t-1))==1 && strcmp(ruleMatching2(t), previousrule)==0  %The rule hasn't changed and you don't perseverate, not that you get it right!
        perseverationTrial(t)=0;
    elseif strcmp(rule(t), rule(t-1))==0 && strcmp(ruleMatching2(t), previousrule)==1  %The rule has changed and you make a perseverations error
        perseverationTrial(t)=1;
        previousrule=rule{t-1};
    elseif strcmp(rule(t), rule(t-1))==0 && strcmp(ruleMatching2(t), previousrule)==0  %The rule has changed and you don't perseverate, not that you get it right!
        perseverationTrial(t)=0;
        previousrule=rule{t-1};
        
    else
        display('If you are seeing this something unexpected happenend... good luck')
        break
    end
end
perseverationResponses=nansum(perseverationTrial); %Normal is 11 for full Wisconsin
PERperseveration=perseverationResponses/n;
PERperseverationError=perseverationResponses/numError;
IllogicalPerseveration=sum(IllogicalPerseverationT);
totalPerseveration=IllogicalPerseveration+nsequence;
%need to calculate the perseveration error?
%would like to look at the number of illogical responses?

SwitchAt=[1 find(switchTrial==1) n+1];
if SwitchAt(end)==129
    SwitchAt(end-1:end)=[];
    nswitchtemp=nswitch-2;
else
    nswitchtemp=nswitch;
end

Error=0;
for s=1:nswitchtemp+1
    trials= [SwitchAt(s):SwitchAt(s+1)-1];
    %Should take 2 or less errors to figure out the swithcing rule
    if correct(trials(1))==1 %First trial is correct
        Error=Error+length(find(correct([trials(1):trials(end)])==0));
        if s==1
            display('this person is anticipating the switches')
        end
        blockACC(s)=1-(length(find(correct([trials(1):trials(end)])==0))/(length(trials)-2));
    elseif correct(trials(1))==0 && correct(trials(2))==1%if the first is wrong, but the second is correct
        Error=Error+length(find(correct([trials(2):trials(end)])==0));
        blockACC(s)=1-(length(find(correct([trials(2):trials(end)])==0))/(length(trials)-1));
    elseif correct(trials(1))==0 && correct(trials(2))==0 %if the first and second are wrong
        Error=Error+length(find(correct([trials(3):trials(end)])==0));
        blockACC(s)=1-(length(find(correct([trials(3):trials(end)])==0))/(length(trials)-2));
    end
    BlockRule{s}=rule{trials(1)};
end

ColorAcc=nanmean(blockACC(find(strcmp(BlockRule, 'Color')==1)));
CountAcc=nanmean(blockACC(find(strcmp(BlockRule, 'Count')==1)));
ShapeAcc=nanmean(blockACC(find(strcmp(BlockRule, 'Shape')==1)));

%'Target,RESP' tells you what key, if any, they hit, might need if we want
%to look at ommission differently
% % omission=zeros(n, 1);
% % omission(find(num(:,39==0)))=1;
%'Target.RT' indicates ms?  or do I want 'Target.RTime'
RT=num(:, 39);

%% Measure that I want

%General accuracy and reaction time
GenAcc=sum(correct)/n;
GenRT=sum(RT)/n;

% AccuracySwitch and SpeedSwitch
SwitchAcc=sum(correct'.*switchTrial)/nswitch;
SwitchRT=sum(RT'.*switchTrial)/nswitch;

% AccuracySame and SpeedSame
SameAcc=sum(correct'.*sameTrial)/(n-nswitch);
SameRT=sum(RT'.*sameTrial)/(n-nswitch);

% AccuracyDifference and SpeedDifference
AccDiff=SameAcc-SwitchAcc;
RTDiff=SameRT-SwitchRT;

%Switching Cost
SwitchingCost=(CountAccBase-CountAcc)+(ColorAccBase-ColorAcc)+(ShapeAccBase-ShapeAcc);

ForExcel=[perseverationResponses PERperseveration PERperseverationError nsequence IllogicalPerseveration totalPerseveration Error SwitchingCost nswitch];
wcslabel={ 'WCSNpersev', 'WCSPerPersev', 'WCSPerPersevErr', 'WCSSequencePersec',...
    'WCSIllogicalPersev', 'WCSTotPersev', 'WCSLogicErr', 'WCSSwitchCost', 'WCSNswitch'};
%% If I want to visualize what is happening...

if plotflag
    figure
    plot(plotrule); hold on
    x_correct=find(correct==1);
    y_correct=plotrule(x_correct);
    x_wrong=find(correct==0);
    y_wrong=plotrule(x_wrong);
    plot(x_correct, y_correct, '*k')%Plot correct
    plot(x_wrong, y_wrong, 'sr', 'MarkerFaceColor', 'r')%Plot correct
    plot(plotthought, 'og')   %plot what they were thinking
    plot(omission, 'sb', 'MarkerFaceColor', 'b')
    title('Matching Rule: -1=Shape, 0=Count, 1=Color')
    legend('rule', 'Correct Answers','Wrong Answers',  'Rule Subjects Used to Match', 'Omission, Wrong Answer')
    axis([0 128 -1.2 1.2])
end
end

