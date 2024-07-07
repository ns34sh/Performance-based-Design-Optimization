function [ThNew,ThBEnew,SpacingBE] = WlDec1(x,Thickness,ThicknessBE,Spacing)
% Function to calculate change in wall property
switch x
    case 1
        ThNew=Thickness-0;
        ThBEnew=ThicknessBE-0;
        SpacingBE=Spacing;

    case 2
        ThNew=Thickness-0;
        ThBEnew=ThicknessBE-0;
        SpacingBE=Spacing/2;
    case 3
        ThNew=Thickness-50;
        ThBEnew=ThicknessBE-0;
        SpacingBE=Spacing;
    case 4
        ThNew=Thickness-50;
        ThBEnew=ThicknessBE-0;
        SpacingBE=Spacing/2;
    case 5
        ThNew=Thickness-100;
        ThBEnew=ThicknessBE-0;
        SpacingBE=Spacing;
    case 6
        ThNew=Thickness-100;
        ThBEnew=ThicknessBE-0;
        SpacingBE=Spacing/2;
    case 7
        ThNew=Thickness-0;
        ThBEnew=ThicknessBE-75;
        SpacingBE=Spacing;
    case 8
        ThNew=Thickness-0;
        ThBEnew=ThicknessBE-75;
        SpacingBE=Spacing/2;
    case 9
        ThNew=Thickness-50;
        ThBEnew=ThicknessBE-75;
        SpacingBE=Spacing;
    case 10
        ThNew=Thickness-50;
        ThBEnew=ThicknessBE-75;
        SpacingBE=Spacing/2;
    case 11
        ThNew=Thickness-100;
        ThBEnew=ThicknessBE-75;
        SpacingBE=Spacing;
    case 12
        ThNew=Thickness-100;
        ThBEnew=ThicknessBE-75;
        SpacingBE=Spacing/2;
    case 13
        ThNew=Thickness-0;
        ThBEnew=ThicknessBE-150;
        SpacingBE=Spacing;
    case 14
        ThNew=Thickness-0;
        ThBEnew=ThicknessBE-150;
        SpacingBE=Spacing/2;
    case 15
        ThNew=Thickness-50;
        ThBEnew=ThicknessBE-150;
        SpacingBE=Spacing;
    case 16
        ThNew=Thickness-50;
        ThBEnew=ThicknessBE-150;
        SpacingBE=Spacing/2;
    case 17
        ThNew=Thickness-100;
        ThBEnew=ThicknessBE-150;
        SpacingBE=Spacing;
    case 18
        ThNew=Thickness-100;
        ThBEnew=ThicknessBE-150;
        SpacingBE=Spacing/2;
end
if ThNew<230
     ThNew=230;
end

end

