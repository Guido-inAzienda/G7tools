//////////////////////////////////////////////////////////////////////
//
//  EXCEL.CH
//
//  Copyright:
//   Alaska Software, (c) 2002-2006. All rights reserved.         
//  
//  Contents:
//   This file was generated with tlb2ch.exe
//   
//  Remarks:
//   Refer to the Xbase++ online documentation for the parameter
//   profile of tlb2ch.exe
//   
//  Syntax:
//   tlb2ch.exe excel.application > excel.ch
//  Return:
//   
//////////////////////////////////////////////////////////////////////

#ifndef EXCEL_APPLICATION_HAEDER_DAEMON
#define EXCEL_APPLICATION_HAEDER_DAEMON
//Constants
#DEFINE xlAll                                                                            -4104
#DEFINE xlAutomatic                                                                      -4105
#DEFINE xlBoth                                                                               1
#DEFINE xlCenter                                                                         -4108
#DEFINE xlChecker                                                                            9
#DEFINE xlCircle                                                                             8
#DEFINE xlCorner                                                                             2
#DEFINE xlCrissCross                                                                        16
#DEFINE xlCross                                                                              4
#DEFINE xlDiamond                                                                            2
#DEFINE xlDistributed                                                                    -4117
#DEFINE xlDoubleAccounting                                                                   5
#DEFINE xlFixedValue                                                                         1
#DEFINE xlFormats                                                                        -4122
#DEFINE xlGray16                                                                            17
#DEFINE xlGray8                                                                             18
#DEFINE xlGrid                                                                              15
#DEFINE xlHigh                                                                           -4127
#DEFINE xlInside                                                                             2
#DEFINE xlJustify                                                                        -4130
#DEFINE xlLightDown                                                                         13
#DEFINE xlLightHorizontal                                                                   11
#DEFINE xlLightUp                                                                           14
#DEFINE xlLightVertical                                                                     12
#DEFINE xlLow                                                                            -4134
#DEFINE xlManual                                                                         -4135
#DEFINE xlMinusValues                                                                        3
#DEFINE xlModule                                                                         -4141
#DEFINE xlNextToAxis                                                                         4
#DEFINE xlNone                                                                           -4142
#DEFINE xlNotes                                                                          -4144
#DEFINE xlOff                                                                            -4146
#DEFINE xlOn                                                                                 1
#DEFINE xlPercent                                                                            2
#DEFINE xlPlus                                                                               9
#DEFINE xlPlusValues                                                                         2
#DEFINE xlSemiGray75                                                                        10
#DEFINE xlShowLabel                                                                          4
#DEFINE xlShowLabelAndPercent                                                                5
#DEFINE xlShowPercent                                                                        3
#DEFINE xlShowValue                                                                          2
#DEFINE xlSimple                                                                         -4154
#DEFINE xlSingle                                                                             2
#DEFINE xlSingleAccounting                                                                   4
#DEFINE xlSolid                                                                              1
#DEFINE xlSquare                                                                             1
#DEFINE xlStar                                                                               5
#DEFINE xlStError                                                                            4
#DEFINE xlToolbarButton                                                                      2
#DEFINE xlTriangle                                                                           3
#DEFINE xlGray25                                                                         -4124
#DEFINE xlGray50                                                                         -4125
#DEFINE xlGray75                                                                         -4126
#DEFINE xlBottom                                                                         -4107
#DEFINE xlLeft                                                                           -4131
#DEFINE xlRight                                                                          -4152
#DEFINE xlTop                                                                            -4160
#DEFINE xl3DBar                                                                          -4099
#DEFINE xl3DSurface                                                                      -4103
#DEFINE xlBar                                                                                2
#DEFINE xlColumn                                                                             3
#DEFINE xlCombination                                                                    -4111
#DEFINE xlCustom                                                                         -4114
#DEFINE xlDefaultAutoFormat                                                                 -1
#DEFINE xlMaximum                                                                            2
#DEFINE xlMinimum                                                                            4
#DEFINE xlOpaque                                                                             3
#DEFINE xlTransparent                                                                        2
#DEFINE xlBidi                                                                           -5000
#DEFINE xlLatin                                                                          -5001
#DEFINE xlContext                                                                        -5002
#DEFINE xlLTR                                                                            -5003
#DEFINE xlRTL                                                                            -5004
#DEFINE xlFullScript                                                                         1
#DEFINE xlPartialScript                                                                      2
#DEFINE xlMixedScript                                                                        3
#DEFINE xlMixedAuthorizedScript                                                              4
#DEFINE xlVisualCursor                                                                       2
#DEFINE xlLogicalCursor                                                                      1
#DEFINE xlSystem                                                                             1
#DEFINE xlPartial                                                                            3
#DEFINE xlHindiNumerals                                                                      3
#DEFINE xlBidiCalendar                                                                       3
#DEFINE xlGregorian                                                                          2
#DEFINE xlComplete                                                                           4
#DEFINE xlScale                                                                              3
#DEFINE xlClosed                                                                             3
#DEFINE xlColor1                                                                             7
#DEFINE xlColor2                                                                             8
#DEFINE xlColor3                                                                             9
#DEFINE xlConstants                                                                          2
#DEFINE xlContents                                                                           2
#DEFINE xlBelow                                                                              1
#DEFINE xlCascade                                                                            7
#DEFINE xlCenterAcrossSelection                                                              7
#DEFINE xlChart4                                                                             2
#DEFINE xlChartSeries                                                                       17
#DEFINE xlChartShort                                                                         6
#DEFINE xlChartTitles                                                                       18
#DEFINE xlClassic1                                                                           1
#DEFINE xlClassic2                                                                           2
#DEFINE xlClassic3                                                                           3
#DEFINE xl3DEffects1                                                                        13
#DEFINE xl3DEffects2                                                                        14
#DEFINE xlAbove                                                                              0
#DEFINE xlAccounting1                                                                        4
#DEFINE xlAccounting2                                                                        5
#DEFINE xlAccounting3                                                                        6
#DEFINE xlAccounting4                                                                       17
#DEFINE xlAdd                                                                                2
#DEFINE xlDebugCodePane                                                                     13
#DEFINE xlDesktop                                                                            9
#DEFINE xlDirect                                                                             1
#DEFINE xlDivide                                                                             5
#DEFINE xlDoubleClosed                                                                       5
#DEFINE xlDoubleOpen                                                                         4
#DEFINE xlDoubleQuote                                                                        1
#DEFINE xlEntireChart                                                                       20
#DEFINE xlExcelMenus                                                                         1
#DEFINE xlExtended                                                                           3
#DEFINE xlFill                                                                               5
#DEFINE xlFirst                                                                              0
#DEFINE xlFloating                                                                           5
#DEFINE xlFormula                                                                            5
#DEFINE xlGeneral                                                                            1
#DEFINE xlGridline                                                                          22
#DEFINE xlIcons                                                                              1
#DEFINE xlImmediatePane                                                                     12
#DEFINE xlInteger                                                                            2
#DEFINE xlLast                                                                               1
#DEFINE xlLastCell                                                                          11
#DEFINE xlList1                                                                             10
#DEFINE xlList2                                                                             11
#DEFINE xlList3                                                                             12
#DEFINE xlLocalFormat1                                                                      15
#DEFINE xlLocalFormat2                                                                      16
#DEFINE xlLong                                                                               3
#DEFINE xlLotusHelp                                                                          2
#DEFINE xlMacrosheetCell                                                                     7
#DEFINE xlMixed                                                                              2
#DEFINE xlMultiply                                                                           4
#DEFINE xlNarrow                                                                             1
#DEFINE xlNoDocuments                                                                        3
#DEFINE xlOpen                                                                               2
#DEFINE xlOutside                                                                            3
#DEFINE xlReference                                                                          4
#DEFINE xlSemiautomatic                                                                      2
#DEFINE xlShort                                                                              1
#DEFINE xlSingleQuote                                                                        2
#DEFINE xlStrict                                                                             2
#DEFINE xlSubtract                                                                           3
#DEFINE xlTextBox                                                                           16
#DEFINE xlTiled                                                                              1
#DEFINE xlTitleBar                                                                           8
#DEFINE xlToolbar                                                                            1
#DEFINE xlVisible                                                                           12
#DEFINE xlWatchPane                                                                         11
#DEFINE xlWide                                                                               3
#DEFINE xlWorkbookTab                                                                        6
#DEFINE xlWorksheet4                                                                         1
#DEFINE xlWorksheetCell                                                                      3
#DEFINE xlWorksheetShort                                                                     5
#DEFINE xlAllExceptBorders                                                                   6
#DEFINE xlLeftToRight                                                                        2
#DEFINE xlTopToBottom                                                                        1
#DEFINE xlVeryHidden                                                                         2
#DEFINE xlDrawingObject                                                                     14
//XlCreator
#DEFINE xlCreatorCode                                                               1480803660
//XlChartGallery
#DEFINE xlBuiltIn                                                                           21
#DEFINE xlUserDefined                                                                       22
#DEFINE xlAnyGallery                                                                        23
//XlColorIndex
#DEFINE xlColorIndexAutomatic                                                            -4105
#DEFINE xlColorIndexNone                                                                 -4142
//XlEndStyleCap
#DEFINE xlCap                                                                                1
#DEFINE xlNoCap                                                                              2
//XlRowCol
#DEFINE xlColumns                                                                            2
#DEFINE xlRows                                                                               1
//XlScaleType
#DEFINE xlScaleLinear                                                                    -4132
#DEFINE xlScaleLogarithmic                                                               -4133
//XlDataSeriesType
#DEFINE xlAutoFill                                                                           4
#DEFINE xlChronological                                                                      3
#DEFINE xlGrowth                                                                             2
#DEFINE xlDataSeriesLinear                                                               -4132
//XlAxisCrosses
#DEFINE xlAxisCrossesAutomatic                                                           -4105
#DEFINE xlAxisCrossesCustom                                                              -4114
#DEFINE xlAxisCrossesMaximum                                                                 2
#DEFINE xlAxisCrossesMinimum                                                                 4
//XlAxisGroup
#DEFINE xlPrimary                                                                            1
#DEFINE xlSecondary                                                                          2
//XlBackground
#DEFINE xlBackgroundAutomatic                                                            -4105
#DEFINE xlBackgroundOpaque                                                                   3
#DEFINE xlBackgroundTransparent                                                              2
//XlWindowState
#DEFINE xlMaximized                                                                      -4137
#DEFINE xlMinimized                                                                      -4140
#DEFINE xlNormal                                                                         -4143
//XlAxisType
#DEFINE xlCategory                                                                           1
#DEFINE xlSeriesAxis                                                                         3
#DEFINE xlValue                                                                              2
//XlArrowHeadLength
#DEFINE xlArrowHeadLengthLong                                                                3
#DEFINE xlArrowHeadLengthMedium                                                          -4138
#DEFINE xlArrowHeadLengthShort                                                               1
//XlVAlign
#DEFINE xlVAlignBottom                                                                   -4107
#DEFINE xlVAlignCenter                                                                   -4108
#DEFINE xlVAlignDistributed                                                              -4117
#DEFINE xlVAlignJustify                                                                  -4130
#DEFINE xlVAlignTop                                                                      -4160
//XlTickMark
#DEFINE xlTickMarkCross                                                                      4
#DEFINE xlTickMarkInside                                                                     2
#DEFINE xlTickMarkNone                                                                   -4142
#DEFINE xlTickMarkOutside                                                                    3
//XlErrorBarDirection
#DEFINE xlX                                                                              -4168
#DEFINE xlY                                                                                  1
//XlErrorBarInclude
#DEFINE xlErrorBarIncludeBoth                                                                1
#DEFINE xlErrorBarIncludeMinusValues                                                         3
#DEFINE xlErrorBarIncludeNone                                                            -4142
#DEFINE xlErrorBarIncludePlusValues                                                          2
//XlDisplayBlanksAs
#DEFINE xlInterpolated                                                                       3
#DEFINE xlNotPlotted                                                                         1
#DEFINE xlZero                                                                               2
//XlArrowHeadStyle
#DEFINE xlArrowHeadStyleClosed                                                               3
#DEFINE xlArrowHeadStyleDoubleClosed                                                         5
#DEFINE xlArrowHeadStyleDoubleOpen                                                           4
#DEFINE xlArrowHeadStyleNone                                                             -4142
#DEFINE xlArrowHeadStyleOpen                                                                 2
//XlArrowHeadWidth
#DEFINE xlArrowHeadWidthMedium                                                           -4138
#DEFINE xlArrowHeadWidthNarrow                                                               1
#DEFINE xlArrowHeadWidthWide                                                                 3
//XlHAlign
#DEFINE xlHAlignCenter                                                                   -4108
#DEFINE xlHAlignCenterAcrossSelection                                                        7
#DEFINE xlHAlignDistributed                                                              -4117
#DEFINE xlHAlignFill                                                                         5
#DEFINE xlHAlignGeneral                                                                      1
#DEFINE xlHAlignJustify                                                                  -4130
#DEFINE xlHAlignLeft                                                                     -4131
#DEFINE xlHAlignRight                                                                    -4152
//XlTickLabelPosition
#DEFINE xlTickLabelPositionHigh                                                          -4127
#DEFINE xlTickLabelPositionLow                                                           -4134
#DEFINE xlTickLabelPositionNextToAxis                                                        4
#DEFINE xlTickLabelPositionNone                                                          -4142
//XlLegendPosition
#DEFINE xlLegendPositionBottom                                                           -4107
#DEFINE xlLegendPositionCorner                                                               2
#DEFINE xlLegendPositionLeft                                                             -4131
#DEFINE xlLegendPositionRight                                                            -4152
#DEFINE xlLegendPositionTop                                                              -4160
//XlChartPictureType
#DEFINE xlStackScale                                                                         3
#DEFINE xlStack                                                                              2
#DEFINE xlStretch                                                                            1
//XlChartPicturePlacement
#DEFINE xlSides                                                                              1
#DEFINE xlEnd                                                                                2
#DEFINE xlEndSides                                                                           3
#DEFINE xlFront                                                                              4
#DEFINE xlFrontSides                                                                         5
#DEFINE xlFrontEnd                                                                           6
#DEFINE xlAllFaces                                                                           7
//XlOrientation
#DEFINE xlDownward                                                                       -4170
#DEFINE xlHorizontal                                                                     -4128
#DEFINE xlUpward                                                                         -4171
#DEFINE xlVertical                                                                       -4166
//XlTickLabelOrientation
#DEFINE xlTickLabelOrientationAutomatic                                                  -4105
#DEFINE xlTickLabelOrientationDownward                                                   -4170
#DEFINE xlTickLabelOrientationHorizontal                                                 -4128
#DEFINE xlTickLabelOrientationUpward                                                     -4171
#DEFINE xlTickLabelOrientationVertical                                                   -4166
//XlBorderWeight
#DEFINE xlHairline                                                                           1
#DEFINE xlMedium                                                                         -4138
#DEFINE xlThick                                                                              4
#DEFINE xlThin                                                                               2
//XlDataSeriesDate
#DEFINE xlDay                                                                                1
#DEFINE xlMonth                                                                              3
#DEFINE xlWeekday                                                                            2
#DEFINE xlYear                                                                               4
//XlUnderlineStyle
#DEFINE xlUnderlineStyleDouble                                                           -4119
#DEFINE xlUnderlineStyleDoubleAccounting                                                     5
#DEFINE xlUnderlineStyleNone                                                             -4142
#DEFINE xlUnderlineStyleSingle                                                               2
#DEFINE xlUnderlineStyleSingleAccounting                                                     4
//XlErrorBarType
#DEFINE xlErrorBarTypeCustom                                                             -4114
#DEFINE xlErrorBarTypeFixedValue                                                             1
#DEFINE xlErrorBarTypePercent                                                                2
#DEFINE xlErrorBarTypeStDev                                                              -4155
#DEFINE xlErrorBarTypeStError                                                                4
//XlTrendlineType
#DEFINE xlExponential                                                                        5
#DEFINE xlLinear                                                                         -4132
#DEFINE xlLogarithmic                                                                    -4133
#DEFINE xlMovingAvg                                                                          6
#DEFINE xlPolynomial                                                                         3
#DEFINE xlPower                                                                              4
//XlLineStyle
#DEFINE xlContinuous                                                                         1
#DEFINE xlDash                                                                           -4115
#DEFINE xlDashDot                                                                            4
#DEFINE xlDashDotDot                                                                         5
#DEFINE xlDot                                                                            -4118
#DEFINE xlDouble                                                                         -4119
#DEFINE xlSlantDashDot                                                                      13
#DEFINE xlLineStyleNone                                                                  -4142
//XlDataLabelsType
#DEFINE xlDataLabelsShowNone                                                             -4142
#DEFINE xlDataLabelsShowValue                                                                2
#DEFINE xlDataLabelsShowPercent                                                              3
#DEFINE xlDataLabelsShowLabel                                                                4
#DEFINE xlDataLabelsShowLabelAndPercent                                                      5
#DEFINE xlDataLabelsShowBubbleSizes                                                          6
//XlMarkerStyle
#DEFINE xlMarkerStyleAutomatic                                                           -4105
#DEFINE xlMarkerStyleCircle                                                                  8
#DEFINE xlMarkerStyleDash                                                                -4115
#DEFINE xlMarkerStyleDiamond                                                                 2
#DEFINE xlMarkerStyleDot                                                                 -4118
#DEFINE xlMarkerStyleNone                                                                -4142
#DEFINE xlMarkerStylePicture                                                             -4147
#DEFINE xlMarkerStylePlus                                                                    9
#DEFINE xlMarkerStyleSquare                                                                  1
#DEFINE xlMarkerStyleStar                                                                    5
#DEFINE xlMarkerStyleTriangle                                                                3
#DEFINE xlMarkerStyleX                                                                   -4168
//XlPictureConvertorType
#DEFINE xlBMP                                                                                1
#DEFINE xlCGM                                                                                7
#DEFINE xlDRW                                                                                4
#DEFINE xlDXF                                                                                5
#DEFINE xlEPS                                                                                8
#DEFINE xlHGL                                                                                6
#DEFINE xlPCT                                                                               13
#DEFINE xlPCX                                                                               10
#DEFINE xlPIC                                                                               11
#DEFINE xlPLT                                                                               12
#DEFINE xlTIF                                                                                9
#DEFINE xlWMF                                                                                2
#DEFINE xlWPG                                                                                3
//XlPattern
#DEFINE xlPatternAutomatic                                                               -4105
#DEFINE xlPatternChecker                                                                     9
#DEFINE xlPatternCrissCross                                                                 16
#DEFINE xlPatternDown                                                                    -4121
#DEFINE xlPatternGray16                                                                     17
#DEFINE xlPatternGray25                                                                  -4124
#DEFINE xlPatternGray50                                                                  -4125
#DEFINE xlPatternGray75                                                                  -4126
#DEFINE xlPatternGray8                                                                      18
#DEFINE xlPatternGrid                                                                       15
#DEFINE xlPatternHorizontal                                                              -4128
#DEFINE xlPatternLightDown                                                                  13
#DEFINE xlPatternLightHorizontal                                                            11
#DEFINE xlPatternLightUp                                                                    14
#DEFINE xlPatternLightVertical                                                              12
#DEFINE xlPatternNone                                                                    -4142
#DEFINE xlPatternSemiGray75                                                                 10
#DEFINE xlPatternSolid                                                                       1
#DEFINE xlPatternUp                                                                      -4162
#DEFINE xlPatternVertical                                                                -4166
//XlChartSplitType
#DEFINE xlSplitByPosition                                                                    1
#DEFINE xlSplitByPercentValue                                                                3
#DEFINE xlSplitByCustomSplit                                                                 4
#DEFINE xlSplitByValue                                                                       2
//XlDisplayUnit
#DEFINE xlHundreds                                                                          -2
#DEFINE xlThousands                                                                         -3
#DEFINE xlTenThousands                                                                      -4
#DEFINE xlHundredThousands                                                                  -5
#DEFINE xlMillions                                                                          -6
#DEFINE xlTenMillions                                                                       -7
#DEFINE xlHundredMillions                                                                   -8
#DEFINE xlThousandMillions                                                                  -9
#DEFINE xlMillionMillions                                                                  -10
//XlDataLabelPosition
#DEFINE xlLabelPositionCenter                                                            -4108
#DEFINE xlLabelPositionAbove                                                                 0
#DEFINE xlLabelPositionBelow                                                                 1
#DEFINE xlLabelPositionLeft                                                              -4131
#DEFINE xlLabelPositionRight                                                             -4152
#DEFINE xlLabelPositionOutsideEnd                                                            2
#DEFINE xlLabelPositionInsideEnd                                                             3
#DEFINE xlLabelPositionInsideBase                                                            4
#DEFINE xlLabelPositionBestFit                                                               5
#DEFINE xlLabelPositionMixed                                                                 6
#DEFINE xlLabelPositionCustom                                                                7
//XlTimeUnit
#DEFINE xlDays                                                                               0
#DEFINE xlMonths                                                                             1
#DEFINE xlYears                                                                              2
//XlCategoryType
#DEFINE xlCategoryScale                                                                      2
#DEFINE xlTimeScale                                                                          3
#DEFINE xlAutomaticScale                                                                 -4105
//XlBarShape
#DEFINE xlBox                                                                                0
#DEFINE xlPyramidToPoint                                                                     1
#DEFINE xlPyramidToMax                                                                       2
#DEFINE xlCylinder                                                                           3
#DEFINE xlConeToPoint                                                                        4
#DEFINE xlConeToMax                                                                          5
//XlChartType
#DEFINE xlColumnClustered                                                                   51
#DEFINE xlColumnStacked                                                                     52
#DEFINE xlColumnStacked100                                                                  53
#DEFINE xl3DColumnClustered                                                                 54
#DEFINE xl3DColumnStacked                                                                   55
#DEFINE xl3DColumnStacked100                                                                56
#DEFINE xlBarClustered                                                                      57
#DEFINE xlBarStacked                                                                        58
#DEFINE xlBarStacked100                                                                     59
#DEFINE xl3DBarClustered                                                                    60
#DEFINE xl3DBarStacked                                                                      61
#DEFINE xl3DBarStacked100                                                                   62
#DEFINE xlLineStacked                                                                       63
#DEFINE xlLineStacked100                                                                    64
#DEFINE xlLineMarkers                                                                       65
#DEFINE xlLineMarkersStacked                                                                66
#DEFINE xlLineMarkersStacked100                                                             67
#DEFINE xlPieOfPie                                                                          68
#DEFINE xlPieExploded                                                                       69
#DEFINE xl3DPieExploded                                                                     70
#DEFINE xlBarOfPie                                                                          71
#DEFINE xlXYScatterSmooth                                                                   72
#DEFINE xlXYScatterSmoothNoMarkers                                                          73
#DEFINE xlXYScatterLines                                                                    74
#DEFINE xlXYScatterLinesNoMarkers                                                           75
#DEFINE xlAreaStacked                                                                       76
#DEFINE xlAreaStacked100                                                                    77
#DEFINE xl3DAreaStacked                                                                     78
#DEFINE xl3DAreaStacked100                                                                  79
#DEFINE xlDoughnutExploded                                                                  80
#DEFINE xlRadarMarkers                                                                      81
#DEFINE xlRadarFilled                                                                       82
#DEFINE xlSurface                                                                           83
#DEFINE xlSurfaceWireframe                                                                  84
#DEFINE xlSurfaceTopView                                                                    85
#DEFINE xlSurfaceTopViewWireframe                                                           86
#DEFINE xlBubble                                                                            15
#DEFINE xlBubble3DEffect                                                                    87
#DEFINE xlStockHLC                                                                          88
#DEFINE xlStockOHLC                                                                         89
#DEFINE xlStockVHLC                                                                         90
#DEFINE xlStockVOHLC                                                                        91
#DEFINE xlCylinderColClustered                                                              92
#DEFINE xlCylinderColStacked                                                                93
#DEFINE xlCylinderColStacked100                                                             94
#DEFINE xlCylinderBarClustered                                                              95
#DEFINE xlCylinderBarStacked                                                                96
#DEFINE xlCylinderBarStacked100                                                             97
#DEFINE xlCylinderCol                                                                       98
#DEFINE xlConeColClustered                                                                  99
#DEFINE xlConeColStacked                                                                   100
#DEFINE xlConeColStacked100                                                                101
#DEFINE xlConeBarClustered                                                                 102
#DEFINE xlConeBarStacked                                                                   103
#DEFINE xlConeBarStacked100                                                                104
#DEFINE xlConeCol                                                                          105
#DEFINE xlPyramidColClustered                                                              106
#DEFINE xlPyramidColStacked                                                                107
#DEFINE xlPyramidColStacked100                                                             108
#DEFINE xlPyramidBarClustered                                                              109
#DEFINE xlPyramidBarStacked                                                                110
#DEFINE xlPyramidBarStacked100                                                             111
#DEFINE xlPyramidCol                                                                       112
#DEFINE xl3DColumn                                                                       -4100
#DEFINE xlLine                                                                               4
#DEFINE xl3DLine                                                                         -4101
#DEFINE xl3DPie                                                                          -4102
#DEFINE xlPie                                                                                5
#DEFINE xlXYScatter                                                                      -4169
#DEFINE xl3DArea                                                                         -4098
#DEFINE xlArea                                                                               1
#DEFINE xlDoughnut                                                                       -4120
#DEFINE xlRadar                                                                          -4151
//XlChartItem
#DEFINE xlDataLabel                                                                          0
#DEFINE xlChartArea                                                                          2
#DEFINE xlSeries                                                                             3
#DEFINE xlChartTitle                                                                         4
#DEFINE xlWalls                                                                              5
#DEFINE xlCorners                                                                            6
#DEFINE xlDataTable                                                                          7
#DEFINE xlTrendline                                                                          8
#DEFINE xlErrorBars                                                                          9
#DEFINE xlXErrorBars                                                                        10
#DEFINE xlYErrorBars                                                                        11
#DEFINE xlLegendEntry                                                                       12
#DEFINE xlLegendKey                                                                         13
#DEFINE xlShape                                                                             14
#DEFINE xlMajorGridlines                                                                    15
#DEFINE xlMinorGridlines                                                                    16
#DEFINE xlAxisTitle                                                                         17
#DEFINE xlUpBars                                                                            18
#DEFINE xlPlotArea                                                                          19
#DEFINE xlDownBars                                                                          20
#DEFINE xlAxis                                                                              21
#DEFINE xlSeriesLines                                                                       22
#DEFINE xlFloor                                                                             23
#DEFINE xlLegend                                                                            24
#DEFINE xlHiLoLines                                                                         25
#DEFINE xlDropLines                                                                         26
#DEFINE xlRadarAxisLabels                                                                   27
#DEFINE xlNothing                                                                           28
#DEFINE xlLeaderLines                                                                       29
#DEFINE xlDisplayUnitLabel                                                                  30
#DEFINE xlPivotChartFieldButton                                                             31
#DEFINE xlPivotChartDropZone                                                                32
//XlSizeRepresents
#DEFINE xlSizeIsWidth                                                                        2
#DEFINE xlSizeIsArea                                                                         1
//XlInsertShiftDirection
#DEFINE xlShiftDown                                                                      -4121
#DEFINE xlShiftToRight                                                                   -4161
//XlDeleteShiftDirection
#DEFINE xlShiftToLeft                                                                    -4159
#DEFINE xlShiftUp                                                                        -4162
//XlDirection
#DEFINE xlDown                                                                           -4121
#DEFINE xlToLeft                                                                         -4159
#DEFINE xlToRight                                                                        -4161
#DEFINE xlUp                                                                             -4162
//XlConsolidationFunction
#DEFINE xlAverage                                                                        -4106
#DEFINE xlCount                                                                          -4112
#DEFINE xlCountNums                                                                      -4113
#DEFINE xlMax                                                                            -4136
#DEFINE xlMin                                                                            -4139
#DEFINE xlProduct                                                                        -4149
#DEFINE xlStDev                                                                          -4155
#DEFINE xlStDevP                                                                         -4156
#DEFINE xlSum                                                                            -4157
#DEFINE xlVar                                                                            -4164
#DEFINE xlVarP                                                                           -4165
#DEFINE xlUnknown                                                                         1000
//XlSheetType
#DEFINE xlChart                                                                          -4109
#DEFINE xlDialogSheet                                                                    -4116
#DEFINE xlExcel4IntlMacroSheet                                                               4
#DEFINE xlExcel4MacroSheet                                                                   3
#DEFINE xlWorksheet                                                                      -4167
//XlLocationInTable
#DEFINE xlColumnHeader                                                                   -4110
#DEFINE xlColumnItem                                                                         5
#DEFINE xlDataHeader                                                                         3
#DEFINE xlDataItem                                                                           7
#DEFINE xlPageHeader                                                                         2
#DEFINE xlPageItem                                                                           6
#DEFINE xlRowHeader                                                                      -4153
#DEFINE xlRowItem                                                                            4
#DEFINE xlTableBody                                                                          8
//XlFindLookIn
#DEFINE xlFormulas                                                                       -4123
#DEFINE xlComments                                                                       -4144
#DEFINE xlValues                                                                         -4163
//XlWindowType
#DEFINE xlChartAsWindow                                                                      5
#DEFINE xlChartInPlace                                                                       4
#DEFINE xlClipboard                                                                          3
#DEFINE xlInfo                                                                           -4129
#DEFINE xlWorkbook                                                                           1
//XlPivotFieldDataType
#DEFINE xlDate                                                                               2
#DEFINE xlNumber                                                                         -4145
#DEFINE xlText                                                                           -4158
//XlCopyPictureFormat
#DEFINE xlBitmap                                                                             2
#DEFINE xlPicture                                                                        -4147
//XlPivotTableSourceType
#DEFINE xlConsolidation                                                                      3
#DEFINE xlDatabase                                                                           1
#DEFINE xlExternal                                                                           2
#DEFINE xlPivotTable                                                                     -4148
//XlReferenceStyle
#DEFINE xlA1                                                                                 1
#DEFINE xlR1C1                                                                           -4150
//XlMSApplication
#DEFINE xlMicrosoftAccess                                                                    4
#DEFINE xlMicrosoftFoxPro                                                                    5
#DEFINE xlMicrosoftMail                                                                      3
#DEFINE xlMicrosoftPowerPoint                                                                2
#DEFINE xlMicrosoftProject                                                                   6
#DEFINE xlMicrosoftSchedulePlus                                                              7
#DEFINE xlMicrosoftWord                                                                      1
//XlMouseButton
#DEFINE xlNoButton                                                                           0
#DEFINE xlPrimaryButton                                                                      1
#DEFINE xlSecondaryButton                                                                    2
//XlCutCopyMode
#DEFINE xlCopy                                                                               1
#DEFINE xlCut                                                                                2
//XlFillWith
#DEFINE xlFillWithAll                                                                    -4104
#DEFINE xlFillWithContents                                                                   2
#DEFINE xlFillWithFormats                                                                -4122
//XlFilterAction
#DEFINE xlFilterCopy                                                                         2
#DEFINE xlFilterInPlace                                                                      1
//XlOrder
#DEFINE xlDownThenOver                                                                       1
#DEFINE xlOverThenDown                                                                       2
//XlLinkType
#DEFINE xlLinkTypeExcelLinks                                                                 1
#DEFINE xlLinkTypeOLELinks                                                                   2
//XlApplyNamesOrder
#DEFINE xlColumnThenRow                                                                      2
#DEFINE xlRowThenColumn                                                                      1
//XlEnableCancelKey
#DEFINE xlDisabled                                                                           0
#DEFINE xlErrorHandler                                                                       2
#DEFINE xlInterrupt                                                                          1
//XlPageBreak
#DEFINE xlPageBreakAutomatic                                                             -4105
#DEFINE xlPageBreakManual                                                                -4135
#DEFINE xlPageBreakNone                                                                  -4142
//XlOLEType
#DEFINE xlOLEControl                                                                         2
#DEFINE xlOLEEmbed                                                                           1
#DEFINE xlOLELink                                                                            0
//XlPageOrientation
#DEFINE xlLandscape                                                                          2
#DEFINE xlPortrait                                                                           1
//XlLinkInfo
#DEFINE xlEditionDate                                                                        2
#DEFINE xlUpdateState                                                                        1
//XlCommandUnderlines
#DEFINE xlCommandUnderlinesAutomatic                                                     -4105
#DEFINE xlCommandUnderlinesOff                                                           -4146
#DEFINE xlCommandUnderlinesOn                                                                1
//XlOLEVerb
#DEFINE xlVerbOpen                                                                           2
#DEFINE xlVerbPrimary                                                                        1
//XlCalculation
#DEFINE xlCalculationAutomatic                                                           -4105
#DEFINE xlCalculationManual                                                              -4135
#DEFINE xlCalculationSemiautomatic                                                           2
//XlFileAccess
#DEFINE xlReadOnly                                                                           3
#DEFINE xlReadWrite                                                                          2
//XlEditionType
#DEFINE xlPublisher                                                                          1
#DEFINE xlSubscriber                                                                         2
//XlObjectSize
#DEFINE xlFitToPage                                                                          2
#DEFINE xlFullPage                                                                           3
#DEFINE xlScreenSize                                                                         1
//XlLookAt
#DEFINE xlPart                                                                               2
#DEFINE xlWhole                                                                              1
//XlMailSystem
#DEFINE xlMAPI                                                                               1
#DEFINE xlNoMailSystem                                                                       0
#DEFINE xlPowerTalk                                                                          2
//XlLinkInfoType
#DEFINE xlLinkInfoOLELinks                                                                   2
#DEFINE xlLinkInfoPublishers                                                                 5
#DEFINE xlLinkInfoSubscribers                                                                6
//XlCVError
#DEFINE xlErrDiv0                                                                         2007
#DEFINE xlErrNA                                                                           2042
#DEFINE xlErrName                                                                         2029
#DEFINE xlErrNull                                                                         2000
#DEFINE xlErrNum                                                                          2036
#DEFINE xlErrRef                                                                          2023
#DEFINE xlErrValue                                                                        2015
//XlEditionFormat
#DEFINE xlBIFF                                                                               2
#DEFINE xlPICT                                                                               1
#DEFINE xlRTF                                                                                4
#DEFINE xlVALU                                                                               8
//XlLink
#DEFINE xlExcelLinks                                                                         1
#DEFINE xlOLELinks                                                                           2
#DEFINE xlPublishers                                                                         5
#DEFINE xlSubscribers                                                                        6
//XlCellType
#DEFINE xlCellTypeBlanks                                                                     4
#DEFINE xlCellTypeConstants                                                                  2
#DEFINE xlCellTypeFormulas                                                               -4123
#DEFINE xlCellTypeLastCell                                                                  11
#DEFINE xlCellTypeComments                                                               -4144
#DEFINE xlCellTypeVisible                                                                   12
#DEFINE xlCellTypeAllFormatConditions                                                    -4172
#DEFINE xlCellTypeSameFormatConditions                                                   -4173
#DEFINE xlCellTypeAllValidation                                                          -4174
#DEFINE xlCellTypeSameValidation                                                         -4175
//XlArrangeStyle
#DEFINE xlArrangeStyleCascade                                                                7
#DEFINE xlArrangeStyleHorizontal                                                         -4128
#DEFINE xlArrangeStyleTiled                                                                  1
#DEFINE xlArrangeStyleVertical                                                           -4166
//XlMousePointer
#DEFINE xlIBeam                                                                              3
#DEFINE xlDefault                                                                        -4143
#DEFINE xlNorthwestArrow                                                                     1
#DEFINE xlWait                                                                               2
//XlEditionOptionsOption
#DEFINE xlAutomaticUpdate                                                                    4
#DEFINE xlCancel                                                                             1
#DEFINE xlChangeAttributes                                                                   6
#DEFINE xlManualUpdate                                                                       5
#DEFINE xlOpenSource                                                                         3
#DEFINE xlSelect                                                                             3
#DEFINE xlSendPublisher                                                                      2
#DEFINE xlUpdateSubscriber                                                                   2
//XlAutoFillType
#DEFINE xlFillCopy                                                                           1
#DEFINE xlFillDays                                                                           5
#DEFINE xlFillDefault                                                                        0
#DEFINE xlFillFormats                                                                        3
#DEFINE xlFillMonths                                                                         7
#DEFINE xlFillSeries                                                                         2
#DEFINE xlFillValues                                                                         4
#DEFINE xlFillWeekdays                                                                       6
#DEFINE xlFillYears                                                                          8
#DEFINE xlGrowthTrend                                                                       10
#DEFINE xlLinearTrend                                                                        9
//XlAutoFilterOperator
#DEFINE xlAnd                                                                                1
#DEFINE xlBottom10Items                                                                      4
#DEFINE xlBottom10Percent                                                                    6
#DEFINE xlOr                                                                                 2
#DEFINE xlTop10Items                                                                         3
#DEFINE xlTop10Percent                                                                       5
//XlClipboardFormat
#DEFINE xlClipboardFormatBIFF                                                                8
#DEFINE xlClipboardFormatBIFF2                                                              18
#DEFINE xlClipboardFormatBIFF3                                                              20
#DEFINE xlClipboardFormatBIFF4                                                              30
#DEFINE xlClipboardFormatBinary                                                             15
#DEFINE xlClipboardFormatBitmap                                                              9
#DEFINE xlClipboardFormatCGM                                                                13
#DEFINE xlClipboardFormatCSV                                                                 5
#DEFINE xlClipboardFormatDIF                                                                 4
#DEFINE xlClipboardFormatDspText                                                            12
#DEFINE xlClipboardFormatEmbeddedObject                                                     21
#DEFINE xlClipboardFormatEmbedSource                                                        22
#DEFINE xlClipboardFormatLink                                                               11
#DEFINE xlClipboardFormatLinkSource                                                         23
#DEFINE xlClipboardFormatLinkSourceDesc                                                     32
#DEFINE xlClipboardFormatMovie                                                              24
#DEFINE xlClipboardFormatNative                                                             14
#DEFINE xlClipboardFormatObjectDesc                                                         31
#DEFINE xlClipboardFormatObjectLink                                                         19
#DEFINE xlClipboardFormatOwnerLink                                                          17
#DEFINE xlClipboardFormatPICT                                                                2
#DEFINE xlClipboardFormatPrintPICT                                                           3
#DEFINE xlClipboardFormatRTF                                                                 7
#DEFINE xlClipboardFormatScreenPICT                                                         29
#DEFINE xlClipboardFormatStandardFont                                                       28
#DEFINE xlClipboardFormatStandardScale                                                      27
#DEFINE xlClipboardFormatSYLK                                                                6
#DEFINE xlClipboardFormatTable                                                              16
#DEFINE xlClipboardFormatText                                                                0
#DEFINE xlClipboardFormatToolFace                                                           25
#DEFINE xlClipboardFormatToolFacePICT                                                       26
#DEFINE xlClipboardFormatVALU                                                                1
#DEFINE xlClipboardFormatWK1                                                                10
//XlFileFormat
#DEFINE xlAddIn                                                                             18
#DEFINE xlCSV                                                                                6
#DEFINE xlCSVMac                                                                            22
#DEFINE xlCSVMSDOS                                                                          24
#DEFINE xlCSVWindows                                                                        23
#DEFINE xlDBF2                                                                               7
#DEFINE xlDBF3                                                                               8
#DEFINE xlDBF4                                                                              11
#DEFINE xlDIF                                                                                9
#DEFINE xlExcel2                                                                            16
#DEFINE xlExcel2FarEast                                                                     27
#DEFINE xlExcel3                                                                            29
#DEFINE xlExcel4                                                                            33
#DEFINE xlExcel5                                                                            39
#DEFINE xlExcel7                                                                            39
#DEFINE xlExcel9795                                                                         43
#DEFINE xlExcel4Workbook                                                                    35
#DEFINE xlIntlAddIn                                                                         26
#DEFINE xlIntlMacro                                                                         25
#DEFINE xlWorkbookNormal                                                                 -4143
#DEFINE xlSYLK                                                                               2
#DEFINE xlTemplate                                                                          17
#DEFINE xlCurrentPlatformText                                                            -4158
#DEFINE xlTextMac                                                                           19
#DEFINE xlTextMSDOS                                                                         21
#DEFINE xlTextPrinter                                                                       36
#DEFINE xlTextWindows                                                                       20
#DEFINE xlWJ2WD1                                                                            14
#DEFINE xlWK1                                                                                5
#DEFINE xlWK1ALL                                                                            31
#DEFINE xlWK1FMT                                                                            30
#DEFINE xlWK3                                                                               15
#DEFINE xlWK4                                                                               38
#DEFINE xlWK3FM3                                                                            32
#DEFINE xlWKS                                                                                4
#DEFINE xlWorks2FarEast                                                                     28
#DEFINE xlWQ1                                                                               34
#DEFINE xlWJ3                                                                               40
#DEFINE xlWJ3FJ3                                                                            41
#DEFINE xlUnicodeText                                                                       42
#DEFINE xlHtml                                                                              44
//XlApplicationInternational
#DEFINE xl24HourClock                                                                       33
#DEFINE xl4DigitYears                                                                       43
#DEFINE xlAlternateArraySeparator                                                           16
#DEFINE xlColumnSeparator                                                                   14
#DEFINE xlCountryCode                                                                        1
#DEFINE xlCountrySetting                                                                     2
#DEFINE xlCurrencyBefore                                                                    37
#DEFINE xlCurrencyCode                                                                      25
#DEFINE xlCurrencyDigits                                                                    27
#DEFINE xlCurrencyLeadingZeros                                                              40
#DEFINE xlCurrencyMinusSign                                                                 38
#DEFINE xlCurrencyNegative                                                                  28
#DEFINE xlCurrencySpaceBefore                                                               36
#DEFINE xlCurrencyTrailingZeros                                                             39
#DEFINE xlDateOrder                                                                         32
#DEFINE xlDateSeparator                                                                     17
#DEFINE xlDayCode                                                                           21
#DEFINE xlDayLeadingZero                                                                    42
#DEFINE xlDecimalSeparator                                                                   3
#DEFINE xlGeneralFormatName                                                                 26
#DEFINE xlHourCode                                                                          22
#DEFINE xlLeftBrace                                                                         12
#DEFINE xlLeftBracket                                                                       10
#DEFINE xlListSeparator                                                                      5
#DEFINE xlLowerCaseColumnLetter                                                              9
#DEFINE xlLowerCaseRowLetter                                                                 8
#DEFINE xlMDY                                                                               44
#DEFINE xlMetric                                                                            35
#DEFINE xlMinuteCode                                                                        23
#DEFINE xlMonthCode                                                                         20
#DEFINE xlMonthLeadingZero                                                                  41
#DEFINE xlMonthNameChars                                                                    30
#DEFINE xlNoncurrencyDigits                                                                 29
#DEFINE xlNonEnglishFunctions                                                               34
#DEFINE xlRightBrace                                                                        13
#DEFINE xlRightBracket                                                                      11
#DEFINE xlRowSeparator                                                                      15
#DEFINE xlSecondCode                                                                        24
#DEFINE xlThousandsSeparator                                                                 4
#DEFINE xlTimeLeadingZero                                                                   45
#DEFINE xlTimeSeparator                                                                     18
#DEFINE xlUpperCaseColumnLetter                                                              7
#DEFINE xlUpperCaseRowLetter                                                                 6
#DEFINE xlWeekdayNameChars                                                                  31
#DEFINE xlYearCode                                                                          19
//XlPageBreakExtent
#DEFINE xlPageBreakFull                                                                      1
#DEFINE xlPageBreakPartial                                                                   2
//XlCellInsertionMode
#DEFINE xlOverwriteCells                                                                     0
#DEFINE xlInsertDeleteCells                                                                  1
#DEFINE xlInsertEntireRows                                                                   2
//XlFormulaLabel
#DEFINE xlNoLabels                                                                       -4142
#DEFINE xlRowLabels                                                                          1
#DEFINE xlColumnLabels                                                                       2
#DEFINE xlMixedLabels                                                                        3
//XlHighlightChangesTime
#DEFINE xlSinceMyLastSave                                                                    1
#DEFINE xlAllChanges                                                                         2
#DEFINE xlNotYetReviewed                                                                     3
//XlCommentDisplayMode
#DEFINE xlNoIndicator                                                                        0
#DEFINE xlCommentIndicatorOnly                                                              -1
#DEFINE xlCommentAndIndicator                                                                1
//XlFormatConditionType
#DEFINE xlCellValue                                                                          1
#DEFINE xlExpression                                                                         2
//XlFormatConditionOperator
#DEFINE xlBetween                                                                            1
#DEFINE xlNotBetween                                                                         2
#DEFINE xlEqual                                                                              3
#DEFINE xlNotEqual                                                                           4
#DEFINE xlGreater                                                                            5
#DEFINE xlLess                                                                               6
#DEFINE xlGreaterEqual                                                                       7
#DEFINE xlLessEqual                                                                          8
//XlEnableSelection
#DEFINE xlNoRestrictions                                                                     0
#DEFINE xlUnlockedCells                                                                      1
#DEFINE xlNoSelection                                                                    -4142
//XlDVType
#DEFINE xlValidateInputOnly                                                                  0
#DEFINE xlValidateWholeNumber                                                                1
#DEFINE xlValidateDecimal                                                                    2
#DEFINE xlValidateList                                                                       3
#DEFINE xlValidateDate                                                                       4
#DEFINE xlValidateTime                                                                       5
#DEFINE xlValidateTextLength                                                                 6
#DEFINE xlValidateCustom                                                                     7
//XlIMEMode
#DEFINE xlIMEModeNoControl                                                                   0
#DEFINE xlIMEModeOn                                                                          1
#DEFINE xlIMEModeOff                                                                         2
#DEFINE xlIMEModeDisable                                                                     3
#DEFINE xlIMEModeHiragana                                                                    4
#DEFINE xlIMEModeKatakana                                                                    5
#DEFINE xlIMEModeKatakanaHalf                                                                6
#DEFINE xlIMEModeAlphaFull                                                                   7
#DEFINE xlIMEModeAlpha                                                                       8
#DEFINE xlIMEModeHangulFull                                                                  9
#DEFINE xlIMEModeHangul                                                                     10
//XlDVAlertStyle
#DEFINE xlValidAlertStop                                                                     1
#DEFINE xlValidAlertWarning                                                                  2
#DEFINE xlValidAlertInformation                                                              3
//XlChartLocation
#DEFINE xlLocationAsNewSheet                                                                 1
#DEFINE xlLocationAsObject                                                                   2
#DEFINE xlLocationAutomatic                                                                  3
//XlPaperSize
#DEFINE xlPaper10x14                                                                        16
#DEFINE xlPaper11x17                                                                        17
#DEFINE xlPaperA3                                                                            8
#DEFINE xlPaperA4                                                                            9
#DEFINE xlPaperA4Small                                                                      10
#DEFINE xlPaperA5                                                                           11
#DEFINE xlPaperB4                                                                           12
#DEFINE xlPaperB5                                                                           13
#DEFINE xlPaperCsheet                                                                       24
#DEFINE xlPaperDsheet                                                                       25
#DEFINE xlPaperEnvelope10                                                                   20
#DEFINE xlPaperEnvelope11                                                                   21
#DEFINE xlPaperEnvelope12                                                                   22
#DEFINE xlPaperEnvelope14                                                                   23
#DEFINE xlPaperEnvelope9                                                                    19
#DEFINE xlPaperEnvelopeB4                                                                   33
#DEFINE xlPaperEnvelopeB5                                                                   34
#DEFINE xlPaperEnvelopeB6                                                                   35
#DEFINE xlPaperEnvelopeC3                                                                   29
#DEFINE xlPaperEnvelopeC4                                                                   30
#DEFINE xlPaperEnvelopeC5                                                                   28
#DEFINE xlPaperEnvelopeC6                                                                   31
#DEFINE xlPaperEnvelopeC65                                                                  32
#DEFINE xlPaperEnvelopeDL                                                                   27
#DEFINE xlPaperEnvelopeItaly                                                                36
#DEFINE xlPaperEnvelopeMonarch                                                              37
#DEFINE xlPaperEnvelopePersonal                                                             38
#DEFINE xlPaperEsheet                                                                       26
#DEFINE xlPaperExecutive                                                                     7
#DEFINE xlPaperFanfoldLegalGerman                                                           41
#DEFINE xlPaperFanfoldStdGerman                                                             40
#DEFINE xlPaperFanfoldUS                                                                    39
#DEFINE xlPaperFolio                                                                        14
#DEFINE xlPaperLedger                                                                        4
#DEFINE xlPaperLegal                                                                         5
#DEFINE xlPaperLetter                                                                        1
#DEFINE xlPaperLetterSmall                                                                   2
#DEFINE xlPaperNote                                                                         18
#DEFINE xlPaperQuarto                                                                       15
#DEFINE xlPaperStatement                                                                     6
#DEFINE xlPaperTabloid                                                                       3
#DEFINE xlPaperUser                                                                        256
//XlPasteSpecialOperation
#DEFINE xlPasteSpecialOperationAdd                                                           2
#DEFINE xlPasteSpecialOperationDivide                                                        5
#DEFINE xlPasteSpecialOperationMultiply                                                      4
#DEFINE xlPasteSpecialOperationNone                                                      -4142
#DEFINE xlPasteSpecialOperationSubtract                                                      3
//XlPasteType
#DEFINE xlPasteAll                                                                       -4104
#DEFINE xlPasteAllExceptBorders                                                              7
#DEFINE xlPasteFormats                                                                   -4122
#DEFINE xlPasteFormulas                                                                  -4123
#DEFINE xlPasteComments                                                                  -4144
#DEFINE xlPasteValues                                                                    -4163
//XlPhoneticCharacterType
#DEFINE xlKatakanaHalf                                                                       0
#DEFINE xlKatakana                                                                           1
#DEFINE xlHiragana                                                                           2
#DEFINE xlNoConversion                                                                       3
//XlPhoneticAlignment
#DEFINE xlPhoneticAlignNoControl                                                             0
#DEFINE xlPhoneticAlignLeft                                                                  1
#DEFINE xlPhoneticAlignCenter                                                                2
#DEFINE xlPhoneticAlignDistributed                                                           3
//XlPictureAppearance
#DEFINE xlPrinter                                                                            2
#DEFINE xlScreen                                                                             1
//XlPivotFieldOrientation
#DEFINE xlColumnField                                                                        2
#DEFINE xlDataField                                                                          4
#DEFINE xlHidden                                                                             0
#DEFINE xlPageField                                                                          3
#DEFINE xlRowField                                                                           1
//XlPivotFieldCalculation
#DEFINE xlDifferenceFrom                                                                     2
#DEFINE xlIndex                                                                              9
#DEFINE xlNoAdditionalCalculation                                                        -4143
#DEFINE xlPercentDifferenceFrom                                                              4
#DEFINE xlPercentOf                                                                          3
#DEFINE xlPercentOfColumn                                                                    7
#DEFINE xlPercentOfRow                                                                       6
#DEFINE xlPercentOfTotal                                                                     8
#DEFINE xlRunningTotal                                                                       5
//XlPlacement
#DEFINE xlFreeFloating                                                                       3
#DEFINE xlMove                                                                               2
#DEFINE xlMoveAndSize                                                                        1
//XlPlatform
#DEFINE xlMacintosh                                                                          1
#DEFINE xlMSDOS                                                                              3
#DEFINE xlWindows                                                                            2
//XlPrintLocation
#DEFINE xlPrintSheetEnd                                                                      1
#DEFINE xlPrintInPlace                                                                      16
#DEFINE xlPrintNoComments                                                                -4142
//XlPriority
#DEFINE xlPriorityHigh                                                                   -4127
#DEFINE xlPriorityLow                                                                    -4134
#DEFINE xlPriorityNormal                                                                 -4143
//XlPTSelectionMode
#DEFINE xlLabelOnly                                                                          1
#DEFINE xlDataAndLabel                                                                       0
#DEFINE xlDataOnly                                                                           2
#DEFINE xlOrigin                                                                             3
#DEFINE xlButton                                                                            15
#DEFINE xlBlanks                                                                             4
#DEFINE xlFirstRow                                                                         256
//XlRangeAutoFormat
#DEFINE xlRangeAutoFormat3DEffects1                                                         13
#DEFINE xlRangeAutoFormat3DEffects2                                                         14
#DEFINE xlRangeAutoFormatAccounting1                                                         4
#DEFINE xlRangeAutoFormatAccounting2                                                         5
#DEFINE xlRangeAutoFormatAccounting3                                                         6
#DEFINE xlRangeAutoFormatAccounting4                                                        17
#DEFINE xlRangeAutoFormatClassic1                                                            1
#DEFINE xlRangeAutoFormatClassic2                                                            2
#DEFINE xlRangeAutoFormatClassic3                                                            3
#DEFINE xlRangeAutoFormatColor1                                                              7
#DEFINE xlRangeAutoFormatColor2                                                              8
#DEFINE xlRangeAutoFormatColor3                                                              9
#DEFINE xlRangeAutoFormatList1                                                              10
#DEFINE xlRangeAutoFormatList2                                                              11
#DEFINE xlRangeAutoFormatList3                                                              12
#DEFINE xlRangeAutoFormatLocalFormat1                                                       15
#DEFINE xlRangeAutoFormatLocalFormat2                                                       16
#DEFINE xlRangeAutoFormatLocalFormat3                                                       19
#DEFINE xlRangeAutoFormatLocalFormat4                                                       20
#DEFINE xlRangeAutoFormatReport1                                                            21
#DEFINE xlRangeAutoFormatReport2                                                            22
#DEFINE xlRangeAutoFormatReport3                                                            23
#DEFINE xlRangeAutoFormatReport4                                                            24
#DEFINE xlRangeAutoFormatReport5                                                            25
#DEFINE xlRangeAutoFormatReport6                                                            26
#DEFINE xlRangeAutoFormatReport7                                                            27
#DEFINE xlRangeAutoFormatReport8                                                            28
#DEFINE xlRangeAutoFormatReport9                                                            29
#DEFINE xlRangeAutoFormatReport10                                                           30
#DEFINE xlRangeAutoFormatClassicPivotTable                                                  31
#DEFINE xlRangeAutoFormatTable1                                                             32
#DEFINE xlRangeAutoFormatTable2                                                             33
#DEFINE xlRangeAutoFormatTable3                                                             34
#DEFINE xlRangeAutoFormatTable4                                                             35
#DEFINE xlRangeAutoFormatTable5                                                             36
#DEFINE xlRangeAutoFormatTable6                                                             37
#DEFINE xlRangeAutoFormatTable7                                                             38
#DEFINE xlRangeAutoFormatTable8                                                             39
#DEFINE xlRangeAutoFormatTable9                                                             40
#DEFINE xlRangeAutoFormatTable10                                                            41
#DEFINE xlRangeAutoFormatPTNone                                                             42
#DEFINE xlRangeAutoFormatNone                                                            -4142
#DEFINE xlRangeAutoFormatSimple                                                          -4154
//XlReferenceType
#DEFINE xlAbsolute                                                                           1
#DEFINE xlAbsRowRelColumn                                                                    2
#DEFINE xlRelative                                                                           4
#DEFINE xlRelRowAbsColumn                                                                    3
//XlLayoutFormType
#DEFINE xlTabular                                                                            0
#DEFINE xlOutline                                                                            1
//XlRoutingSlipDelivery
#DEFINE xlAllAtOnce                                                                          2
#DEFINE xlOneAfterAnother                                                                    1
//XlRoutingSlipStatus
#DEFINE xlNotYetRouted                                                                       0
#DEFINE xlRoutingComplete                                                                    2
#DEFINE xlRoutingInProgress                                                                  1
//XlRunAutoMacro
#DEFINE xlAutoActivate                                                                       3
#DEFINE xlAutoClose                                                                          2
#DEFINE xlAutoDeactivate                                                                     4
#DEFINE xlAutoOpen                                                                           1
//XlSaveAction
#DEFINE xlDoNotSaveChanges                                                                   2
#DEFINE xlSaveChanges                                                                        1
//XlSaveAsAccessMode
#DEFINE xlExclusive                                                                          3
#DEFINE xlNoChange                                                                           1
#DEFINE xlShared                                                                             2
//XlSaveConflictResolution
#DEFINE xlLocalSessionChanges                                                                2
#DEFINE xlOtherSessionChanges                                                                3
#DEFINE xlUserResolution                                                                     1
//XlSearchDirection
#DEFINE xlNext                                                                               1
#DEFINE xlPrevious                                                                           2
//XlSearchOrder
#DEFINE xlByColumns                                                                          2
#DEFINE xlByRows                                                                             1
//XlSheetVisibility
#DEFINE xlSheetVisible                                                                      -1
#DEFINE xlSheetHidden                                                                        0
#DEFINE xlSheetVeryHidden                                                                    2
//XlSortMethod
#DEFINE xlPinYin                                                                             1
#DEFINE xlStroke                                                                             2
//XlSortMethodOld
#DEFINE xlCodePage                                                                           2
#DEFINE xlSyllabary                                                                          1
//XlSortOrder
#DEFINE xlAscending                                                                          1
#DEFINE xlDescending                                                                         2
//XlSortOrientation
#DEFINE xlSortRows                                                                           2
#DEFINE xlSortColumns                                                                        1
//XlSortType
#DEFINE xlSortLabels                                                                         2
#DEFINE xlSortValues                                                                         1
//XlSpecialCellsValue
#DEFINE xlErrors                                                                            16
#DEFINE xlLogical                                                                            4
#DEFINE xlNumbers                                                                            1
#DEFINE xlTextValues                                                                         2
//XlSubscribeToFormat
#DEFINE xlSubscribeToPicture                                                             -4147
#DEFINE xlSubscribeToText                                                                -4158
//XlSummaryRow
#DEFINE xlSummaryAbove                                                                       0
#DEFINE xlSummaryBelow                                                                       1
//XlSummaryColumn
#DEFINE xlSummaryOnLeft                                                                  -4131
#DEFINE xlSummaryOnRight                                                                 -4152
//XlSummaryReportType
#DEFINE xlSummaryPivotTable                                                              -4148
#DEFINE xlStandardSummary                                                                    1
//XlTabPosition
#DEFINE xlTabPositionFirst                                                                   0
#DEFINE xlTabPositionLast                                                                    1
//XlTextParsingType
#DEFINE xlDelimited                                                                          1
#DEFINE xlFixedWidth                                                                         2
//XlTextQualifier
#DEFINE xlTextQualifierDoubleQuote                                                           1
#DEFINE xlTextQualifierNone                                                              -4142
#DEFINE xlTextQualifierSingleQuote                                                           2
//XlWBATemplate
#DEFINE xlWBATChart                                                                      -4109
#DEFINE xlWBATExcel4IntlMacroSheet                                                           4
#DEFINE xlWBATExcel4MacroSheet                                                               3
#DEFINE xlWBATWorksheet                                                                  -4167
//XlWindowView
#DEFINE xlNormalView                                                                         1
#DEFINE xlPageBreakPreview                                                                   2
//XlXLMMacroType
#DEFINE xlCommand                                                                            2
#DEFINE xlFunction                                                                           1
#DEFINE xlNotXLM                                                                             3
//XlYesNoGuess
#DEFINE xlGuess                                                                              0
#DEFINE xlNo                                                                                 2
#DEFINE xlYes                                                                                1
//XlBordersIndex
#DEFINE xlInsideHorizontal                                                                  12
#DEFINE xlInsideVertical                                                                    11
#DEFINE xlDiagonalDown                                                                       5
#DEFINE xlDiagonalUp                                                                         6
#DEFINE xlEdgeBottom                                                                         9
#DEFINE xlEdgeLeft                                                                           7
#DEFINE xlEdgeRight                                                                         10
#DEFINE xlEdgeTop                                                                            8
//XlToolbarProtection
#DEFINE xlNoButtonChanges                                                                    1
#DEFINE xlNoChanges                                                                          4
#DEFINE xlNoDockingChanges                                                                   3
#DEFINE xlToolbarProtectionNone                                                          -4143
#DEFINE xlNoShapeChanges                                                                     2
//XlBuiltInDialog
#DEFINE xlDialogOpen                                                                         1
#DEFINE xlDialogOpenLinks                                                                    2
#DEFINE xlDialogSaveAs                                                                       5
#DEFINE xlDialogFileDelete                                                                   6
#DEFINE xlDialogPageSetup                                                                    7
#DEFINE xlDialogPrint                                                                        8
#DEFINE xlDialogPrinterSetup                                                                 9
#DEFINE xlDialogArrangeAll                                                                  12
#DEFINE xlDialogWindowSize                                                                  13
#DEFINE xlDialogWindowMove                                                                  14
#DEFINE xlDialogRun                                                                         17
#DEFINE xlDialogSetPrintTitles                                                              23
#DEFINE xlDialogFont                                                                        26
#DEFINE xlDialogDisplay                                                                     27
#DEFINE xlDialogProtectDocument                                                             28
#DEFINE xlDialogCalculation                                                                 32
#DEFINE xlDialogExtract                                                                     35
#DEFINE xlDialogDataDelete                                                                  36
#DEFINE xlDialogSort                                                                        39
#DEFINE xlDialogDataSeries                                                                  40
#DEFINE xlDialogTable                                                                       41
#DEFINE xlDialogFormatNumber                                                                42
#DEFINE xlDialogAlignment                                                                   43
#DEFINE xlDialogStyle                                                                       44
#DEFINE xlDialogBorder                                                                      45
#DEFINE xlDialogCellProtection                                                              46
#DEFINE xlDialogColumnWidth                                                                 47
#DEFINE xlDialogClear                                                                       52
#DEFINE xlDialogPasteSpecial                                                                53
#DEFINE xlDialogEditDelete                                                                  54
#DEFINE xlDialogInsert                                                                      55
#DEFINE xlDialogPasteNames                                                                  58
#DEFINE xlDialogDefineName                                                                  61
#DEFINE xlDialogCreateNames                                                                 62
#DEFINE xlDialogFormulaGoto                                                                 63
#DEFINE xlDialogFormulaFind                                                                 64
#DEFINE xlDialogGalleryArea                                                                 67
#DEFINE xlDialogGalleryBar                                                                  68
#DEFINE xlDialogGalleryColumn                                                               69
#DEFINE xlDialogGalleryLine                                                                 70
#DEFINE xlDialogGalleryPie                                                                  71
#DEFINE xlDialogGalleryScatter                                                              72
#DEFINE xlDialogCombination                                                                 73
#DEFINE xlDialogGridlines                                                                   76
#DEFINE xlDialogAxes                                                                        78
#DEFINE xlDialogAttachText                                                                  80
#DEFINE xlDialogPatterns                                                                    84
#DEFINE xlDialogMainChart                                                                   85
#DEFINE xlDialogOverlay                                                                     86
#DEFINE xlDialogScale                                                                       87
#DEFINE xlDialogFormatLegend                                                                88
#DEFINE xlDialogFormatText                                                                  89
#DEFINE xlDialogParse                                                                       91
#DEFINE xlDialogUnhide                                                                      94
#DEFINE xlDialogWorkspace                                                                   95
#DEFINE xlDialogActivate                                                                   103
#DEFINE xlDialogCopyPicture                                                                108
#DEFINE xlDialogDeleteName                                                                 110
#DEFINE xlDialogDeleteFormat                                                               111
#DEFINE xlDialogNew                                                                        119
#DEFINE xlDialogRowHeight                                                                  127
#DEFINE xlDialogFormatMove                                                                 128
#DEFINE xlDialogFormatSize                                                                 129
#DEFINE xlDialogFormulaReplace                                                             130
#DEFINE xlDialogSelectSpecial                                                              132
#DEFINE xlDialogApplyNames                                                                 133
#DEFINE xlDialogReplaceFont                                                                134
#DEFINE xlDialogSplit                                                                      137
#DEFINE xlDialogOutline                                                                    142
#DEFINE xlDialogSaveWorkbook                                                               145
#DEFINE xlDialogCopyChart                                                                  147
#DEFINE xlDialogFormatFont                                                                 150
#DEFINE xlDialogNote                                                                       154
#DEFINE xlDialogSetUpdateStatus                                                            159
#DEFINE xlDialogColorPalette                                                               161
#DEFINE xlDialogChangeLink                                                                 166
#DEFINE xlDialogAppMove                                                                    170
#DEFINE xlDialogAppSize                                                                    171
#DEFINE xlDialogMainChartType                                                              185
#DEFINE xlDialogOverlayChartType                                                           186
#DEFINE xlDialogOpenMail                                                                   188
#DEFINE xlDialogSendMail                                                                   189
#DEFINE xlDialogStandardFont                                                               190
#DEFINE xlDialogConsolidate                                                                191
#DEFINE xlDialogSortSpecial                                                                192
#DEFINE xlDialogGallery3dArea                                                              193
#DEFINE xlDialogGallery3dColumn                                                            194
#DEFINE xlDialogGallery3dLine                                                              195
#DEFINE xlDialogGallery3dPie                                                               196
#DEFINE xlDialogView3d                                                                     197
#DEFINE xlDialogGoalSeek                                                                   198
#DEFINE xlDialogWorkgroup                                                                  199
#DEFINE xlDialogFillGroup                                                                  200
#DEFINE xlDialogUpdateLink                                                                 201
#DEFINE xlDialogPromote                                                                    202
#DEFINE xlDialogDemote                                                                     203
#DEFINE xlDialogShowDetail                                                                 204
#DEFINE xlDialogObjectProperties                                                           207
#DEFINE xlDialogSaveNewObject                                                              208
#DEFINE xlDialogApplyStyle                                                                 212
#DEFINE xlDialogAssignToObject                                                             213
#DEFINE xlDialogObjectProtection                                                           214
#DEFINE xlDialogCreatePublisher                                                            217
#DEFINE xlDialogSubscribeTo                                                                218
#DEFINE xlDialogShowToolbar                                                                220
#DEFINE xlDialogPrintPreview                                                               222
#DEFINE xlDialogEditColor                                                                  223
#DEFINE xlDialogFormatMain                                                                 225
#DEFINE xlDialogFormatOverlay                                                              226
#DEFINE xlDialogEditSeries                                                                 228
#DEFINE xlDialogDefineStyle                                                                229
#DEFINE xlDialogGalleryRadar                                                               249
#DEFINE xlDialogEditionOptions                                                             251
#DEFINE xlDialogZoom                                                                       256
#DEFINE xlDialogInsertObject                                                               259
#DEFINE xlDialogSize                                                                       261
#DEFINE xlDialogMove                                                                       262
#DEFINE xlDialogFormatAuto                                                                 269
#DEFINE xlDialogGallery3dBar                                                               272
#DEFINE xlDialogGallery3dSurface                                                           273
#DEFINE xlDialogCustomizeToolbar                                                           276
#DEFINE xlDialogWorkbookAdd                                                                281
#DEFINE xlDialogWorkbookMove                                                               282
#DEFINE xlDialogWorkbookCopy                                                               283
#DEFINE xlDialogWorkbookOptions                                                            284
#DEFINE xlDialogSaveWorkspace                                                              285
#DEFINE xlDialogChartWizard                                                                288
#DEFINE xlDialogAssignToTool                                                               293
#DEFINE xlDialogPlacement                                                                  300
#DEFINE xlDialogFillWorkgroup                                                              301
#DEFINE xlDialogWorkbookNew                                                                302
#DEFINE xlDialogScenarioCells                                                              305
#DEFINE xlDialogScenarioAdd                                                                307
#DEFINE xlDialogScenarioEdit                                                               308
#DEFINE xlDialogScenarioSummary                                                            311
#DEFINE xlDialogPivotTableWizard                                                           312
#DEFINE xlDialogPivotFieldProperties                                                       313
#DEFINE xlDialogOptionsCalculation                                                         318
#DEFINE xlDialogOptionsEdit                                                                319
#DEFINE xlDialogOptionsView                                                                320
#DEFINE xlDialogAddinManager                                                               321
#DEFINE xlDialogMenuEditor                                                                 322
#DEFINE xlDialogAttachToolbars                                                             323
#DEFINE xlDialogOptionsChart                                                               325
#DEFINE xlDialogVbaInsertFile                                                              328
#DEFINE xlDialogVbaProcedureDefinition                                                     330
#DEFINE xlDialogRoutingSlip                                                                336
#DEFINE xlDialogMailLogon                                                                  339
#DEFINE xlDialogInsertPicture                                                              342
#DEFINE xlDialogGalleryDoughnut                                                            344
#DEFINE xlDialogChartTrend                                                                 350
#DEFINE xlDialogWorkbookInsert                                                             354
#DEFINE xlDialogOptionsTransition                                                          355
#DEFINE xlDialogOptionsGeneral                                                             356
#DEFINE xlDialogFilterAdvanced                                                             370
#DEFINE xlDialogMailNextLetter                                                             378
#DEFINE xlDialogDataLabel                                                                  379
#DEFINE xlDialogInsertTitle                                                                380
#DEFINE xlDialogFontProperties                                                             381
#DEFINE xlDialogMacroOptions                                                               382
#DEFINE xlDialogWorkbookUnhide                                                             384
#DEFINE xlDialogWorkbookName                                                               386
#DEFINE xlDialogGalleryCustom                                                              388
#DEFINE xlDialogAddChartAutoformat                                                         390
#DEFINE xlDialogChartAddData                                                               392
#DEFINE xlDialogTabOrder                                                                   394
#DEFINE xlDialogSubtotalCreate                                                             398
#DEFINE xlDialogWorkbookTabSplit                                                           415
#DEFINE xlDialogWorkbookProtect                                                            417
#DEFINE xlDialogScrollbarProperties                                                        420
#DEFINE xlDialogPivotShowPages                                                             421
#DEFINE xlDialogTextToColumns                                                              422
#DEFINE xlDialogFormatCharttype                                                            423
#DEFINE xlDialogPivotFieldGroup                                                            433
#DEFINE xlDialogPivotFieldUngroup                                                          434
#DEFINE xlDialogCheckboxProperties                                                         435
#DEFINE xlDialogLabelProperties                                                            436
#DEFINE xlDialogListboxProperties                                                          437
#DEFINE xlDialogEditboxProperties                                                          438
#DEFINE xlDialogOpenText                                                                   441
#DEFINE xlDialogPushbuttonProperties                                                       445
#DEFINE xlDialogFilter                                                                     447
#DEFINE xlDialogFunctionWizard                                                             450
#DEFINE xlDialogSaveCopyAs                                                                 456
#DEFINE xlDialogOptionsListsAdd                                                            458
#DEFINE xlDialogSeriesAxes                                                                 460
#DEFINE xlDialogSeriesX                                                                    461
#DEFINE xlDialogSeriesY                                                                    462
#DEFINE xlDialogErrorbarX                                                                  463
#DEFINE xlDialogErrorbarY                                                                  464
#DEFINE xlDialogFormatChart                                                                465
#DEFINE xlDialogSeriesOrder                                                                466
#DEFINE xlDialogMailEditMailer                                                             470
#DEFINE xlDialogStandardWidth                                                              472
#DEFINE xlDialogScenarioMerge                                                              473
#DEFINE xlDialogProperties                                                                 474
#DEFINE xlDialogSummaryInfo                                                                474
#DEFINE xlDialogFindFile                                                                   475
#DEFINE xlDialogActiveCellFont                                                             476
#DEFINE xlDialogVbaMakeAddin                                                               478
#DEFINE xlDialogFileSharing                                                                481
#DEFINE xlDialogAutoCorrect                                                                485
#DEFINE xlDialogCustomViews                                                                493
#DEFINE xlDialogInsertNameLabel                                                            496
#DEFINE xlDialogSeriesShape                                                                504
#DEFINE xlDialogChartOptionsDataLabels                                                     505
#DEFINE xlDialogChartOptionsDataTable                                                      506
#DEFINE xlDialogSetBackgroundPicture                                                       509
#DEFINE xlDialogDataValidation                                                             525
#DEFINE xlDialogChartType                                                                  526
#DEFINE xlDialogChartLocation                                                              527
#DEFINE _xlDialogPhonetic                                                                  538
#DEFINE xlDialogChartSourceData                                                            540
#DEFINE _xlDialogChartSourceData                                                           541
#DEFINE xlDialogSeriesOptions                                                              557
#DEFINE xlDialogPivotTableOptions                                                          567
#DEFINE xlDialogPivotSolveOrder                                                            568
#DEFINE xlDialogPivotCalculatedField                                                       570
#DEFINE xlDialogPivotCalculatedItem                                                        572
#DEFINE xlDialogConditionalFormatting                                                      583
#DEFINE xlDialogInsertHyperlink                                                            596
#DEFINE xlDialogProtectSharing                                                             620
#DEFINE xlDialogOptionsME                                                                  647
#DEFINE xlDialogPublishAsWebPage                                                           653
#DEFINE xlDialogPhonetic                                                                   656
#DEFINE xlDialogNewWebQuery                                                                667
#DEFINE xlDialogImportTextFile                                                             666
#DEFINE xlDialogExternalDataProperties                                                     530
#DEFINE xlDialogWebOptionsGeneral                                                          683
#DEFINE xlDialogWebOptionsFiles                                                            684
#DEFINE xlDialogWebOptionsPictures                                                         685
#DEFINE xlDialogWebOptionsEncoding                                                         686
#DEFINE xlDialogWebOptionsFonts                                                            687
#DEFINE xlDialogPivotClientServerSet                                                       689
//XlParameterType
#DEFINE xlPrompt                                                                             0
#DEFINE xlConstant                                                                           1
#DEFINE xlRange                                                                              2
//XlParameterDataType
#DEFINE xlParamTypeUnknown                                                                   0
#DEFINE xlParamTypeChar                                                                      1
#DEFINE xlParamTypeNumeric                                                                   2
#DEFINE xlParamTypeDecimal                                                                   3
#DEFINE xlParamTypeInteger                                                                   4
#DEFINE xlParamTypeSmallInt                                                                  5
#DEFINE xlParamTypeFloat                                                                     6
#DEFINE xlParamTypeReal                                                                      7
#DEFINE xlParamTypeDouble                                                                    8
#DEFINE xlParamTypeVarChar                                                                  12
#DEFINE xlParamTypeDate                                                                      9
#DEFINE xlParamTypeTime                                                                     10
#DEFINE xlParamTypeTimestamp                                                                11
#DEFINE xlParamTypeLongVarChar                                                              -1
#DEFINE xlParamTypeBinary                                                                   -2
#DEFINE xlParamTypeVarBinary                                                                -3
#DEFINE xlParamTypeLongVarBinary                                                            -4
#DEFINE xlParamTypeBigInt                                                                   -5
#DEFINE xlParamTypeTinyInt                                                                  -6
#DEFINE xlParamTypeBit                                                                      -7
#DEFINE xlParamTypeWChar                                                                    -8
//XlFormControl
#DEFINE xlButtonControl                                                                      0
#DEFINE xlCheckBox                                                                           1
#DEFINE xlDropDown                                                                           2
#DEFINE xlEditBox                                                                            3
#DEFINE xlGroupBox                                                                           4
#DEFINE xlLabel                                                                              5
#DEFINE xlListBox                                                                            6
#DEFINE xlOptionButton                                                                       7
#DEFINE xlScrollBar                                                                          8
#DEFINE xlSpinner                                                                            9
//XlSourceType
#DEFINE xlSourceSheet                                                                        1
#DEFINE xlSourcePrintArea                                                                    2
#DEFINE xlSourceAutoFilter                                                                   3
#DEFINE xlSourceRange                                                                        4
#DEFINE xlSourceChart                                                                        5
#DEFINE xlSourcePivotTable                                                                   6
#DEFINE xlSourceQuery                                                                        7
//XlHtmlType
#DEFINE xlHtmlStatic                                                                         0
#DEFINE xlHtmlCalc                                                                           1
#DEFINE xlHtmlList                                                                           2
#DEFINE xlHtmlChart                                                                          3
//xlPivotFormatType
#DEFINE xlReport1                                                                            0
#DEFINE xlReport2                                                                            1
#DEFINE xlReport3                                                                            2
#DEFINE xlReport4                                                                            3
#DEFINE xlReport5                                                                            4
#DEFINE xlReport6                                                                            5
#DEFINE xlReport7                                                                            6
#DEFINE xlReport8                                                                            7
#DEFINE xlReport9                                                                            8
#DEFINE xlReport10                                                                           9
#DEFINE xlTable1                                                                            10
#DEFINE xlTable2                                                                            11
#DEFINE xlTable3                                                                            12
#DEFINE xlTable4                                                                            13
#DEFINE xlTable5                                                                            14
#DEFINE xlTable6                                                                            15
#DEFINE xlTable7                                                                            16
#DEFINE xlTable8                                                                            17
#DEFINE xlTable9                                                                            18
#DEFINE xlTable10                                                                           19
#DEFINE xlPTClassic                                                                         20
#DEFINE xlPTNone                                                                            21
//XlCmdType
#DEFINE xlCmdCube                                                                            1
#DEFINE xlCmdSql                                                                             2
#DEFINE xlCmdTable                                                                           3
#DEFINE xlCmdDefault                                                                         4
//xlColumnDataType
#DEFINE xlGeneralFormat                                                                      1
#DEFINE xlTextFormat                                                                         2
#DEFINE xlMDYFormat                                                                          3
#DEFINE xlDMYFormat                                                                          4
#DEFINE xlYMDFormat                                                                          5
#DEFINE xlMYDFormat                                                                          6
#DEFINE xlDYMFormat                                                                          7
#DEFINE xlYDMFormat                                                                          8
#DEFINE xlSkipColumn                                                                         9
#DEFINE xlEMDFormat                                                                         10
//xlQueryType
#DEFINE xlODBCQuery                                                                          1
#DEFINE xlDAORecordSet                                                                       2
#DEFINE xlWebQuery                                                                           4
#DEFINE xlOLEDBQuery                                                                         5
#DEFINE xlTextImport                                                                         6
#DEFINE xlADORecordset                                                                       7
//xlWebSelectionType
#DEFINE xlEntirePage                                                                         1
#DEFINE xlAllTables                                                                          2
#DEFINE xlSpecifiedTables                                                                    3
//XlCubeFieldType
#DEFINE xlHierarchy                                                                          1
#DEFINE xlMeasure                                                                            2
//xlWebFormatting
#DEFINE xlWebFormattingAll                                                                   1
#DEFINE xlWebFormattingRTF                                                                   2
#DEFINE xlWebFormattingNone                                                                  3
//xlDisplayDrawingObjects
#DEFINE xlDisplayShapes                                                                  -4104
#DEFINE xlHide                                                                               3
#DEFINE xlPlaceholders                                                                       2
//xLSubtototalLocationType
#DEFINE xlAtTop                                                                              1
#DEFINE xlAtBottom                                                                           2
#endif //EXCEL_APPLICATION_HAEDER_DAEMON