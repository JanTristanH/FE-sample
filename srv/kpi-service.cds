using {db} from '../db/schema';

service KpiService {

    entity NAST        as projection on db.NAST;

    entity Customers   as
        select from NAST distinct {
            key KUNWE,
                'mail.' || KUNWE || '@testmail.com' as mail : String(36)
        };

    @readonly
    @cds.odata.valuelist
    entity DlvznVH     as
        select from NAST distinct {
            key DLVZN
        };

    @readonly
    @cds.odata.valuelist
    entity PstypeVH    as
        select from NAST distinct {
            key PSTYPE
        };

    @readonly
    @cds.odata.valuelist
    entity CreatedByVH as
        select from NAST distinct {
            key ERNAM
        };

    @readonly
    @cds.odata.valuelist
    entity KUNWEVH     as
        select from NAST distinct {
            key KUNWE
        };

}

annotate KpiService.Customers with @(
    Communication.Contact #identify1 : {title : KUNWE,
                                                       //org : mail,
                                                       // role : OrganizationRole,
                                                       // tel : [
                                                       //     {
                                                       //         type : #fax,
                                                       //         uri : FaxNumber
                                                       //     },
                                                       //     {
                                                       //         type : [ #work, #pref ],
                                                       //         uri : PhoneNumber
                                                       //     }
                                                       // ],
                                                       // email : [{
                                                       //     type    : #work,
                                                       //     address : mail
                                                       // }]
                                                },

    UI                               : {
        LineItem            : [{
            $Type : 'UI.DataFieldWithUrl',
            Url   : 'forward.html',
            Value : KUNWE,
        }, ],

        HeaderInfo #header1 : {
            $Type          : 'UI.HeaderInfoType',
            TypeName       : 'Product',
            TypeNamePlural : 'Products',
            Title          : {
                $Type : 'UI.DataField',
                Label : 'Customer Name',
                Value : KUNWE
            },
            Description    : {
                $Type : 'UI.DataField',
                Label : 'Product Description',
                Value : KUNWE
            },
            TypeImageUrl   : 'sap-icon://customer',

        }
    }

);


annotate KpiService.NAST with {
    @Common.SemanticObject           : 'Movement'
    DOCNR;

    //field dependant annotations -> charts in top bar
    @Common                          : {
        ValueList #DlvznVisualFilter : {
            $Type                        : 'Common.ValueListType',
            CollectionPath               : 'NAST',
            PresentationVariantQualifier : 'DLVZN',
            Parameters                   : [{
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'DLVZN',
                ValueListProperty : 'DLVZN'
            }]
        },
        ValueList                    : {
            $Type          : 'Common.ValueListType',
            Label          : 'DLVZN',
            CollectionPath : 'NAST',
            Parameters     : [{
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'DLVZN',
                ValueListProperty : 'DLVZN'
            }]
        },
        //FilterDefaultValue           : 'HH_1'
    }
    DLVZN  @(ValueList.entity : 'DlvznVH');

    @Common.ValueListWithFixedValues : true
    @Common                          : {
        //visual Filter
        ValueList #PSTYPEVisualFilter : {
            $Type                        : 'Common.ValueListType',
            CollectionPath               : 'NAST',
            PresentationVariantQualifier : 'QtyByPstype',
            Parameters                   : [{
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'PSTYPE',
                ValueListProperty : 'PSTYPE'
            }]
        }
        //Drop down list without qualifier
        ,
        ValueList                     : {
            $Type          : 'Common.ValueListType',
            Label          : 'PSTYPE',
            CollectionPath : 'NAST',
            Parameters     : [{
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'PSTYPE',
                ValueListProperty : 'PSTYPE'
            }]
        }
    }
    PSTYPE @(ValueList.entity : 'PstypeVH');

    @Common.ValueListWithFixedValues : true
    @Common.ValueList                : {
        $Type          : 'Common.ValueListType',
        Label          : 'ERNAM',
        CollectionPath : 'NAST',
        Parameters     : [{
            $Type             : 'Common.ValueListParameterInOut',
            LocalDataProperty : 'ERNAM',
            ValueListProperty : 'ERNAM'
        }]
    }
    ERNAM  @(ValueList.entity : 'CreatedByVH');

    //definde value help
    @Common.ValueList                : {
        $Type          : 'Common.ValueListType',
        Label          : 'KUNWE',
        CollectionPath : 'NAST',
        Parameters     : [{
            $Type             : 'Common.ValueListParameterInOut',
            LocalDataProperty : 'KUNWE',
            ValueListProperty : 'KUNWE'
        }]
    }
    KUNWE  @(ValueList.entity : 'KUNWEVH');

    @Common                          : {ValueList #QUANTITYBYDAY : {
        $Type                        : 'Common.ValueListType',
        CollectionPath               : 'NAST',
        PresentationVariantQualifier : 'QUANTITYBYDAY',
        Parameters                   : [{
            $Type             : 'Common.ValueListParameterInOut',
            LocalDataProperty : 'PDLVDF',
            ValueListProperty : 'PDLVDF'
        }]
    }}
    //--> if enabled semanci date range filter is available, otherwise the chart will work
    //@sap.filter.restriction: 'interval'
    PDLVDF;
};


annotate KpiService.NAST with @(
    Aggregation.ApplySupported.PropertyRestrictions : true,
    Aggregation,
    UI                                              : {


        // Define ctriticality and semantic colors for Visual filter QTY
        DataPoint #GrossQuantiy            : {
            $Type                  : 'UI.DataPointType',
            Title                  : 'Gross Quantity',
            Value                  : DOCQTY,
            TargetValue            : 5000,
            MinimumValue           : 1000,
            MaximumValue           : 7000,

            CriticalityCalculation : {
                $Type                    : 'UI.CriticalityCalculationType',
                ImprovementDirection     : #Maximize,
                AcceptanceRangeLowValue  : 500,
                AcceptanceRangeHighValue : 1000,
                ToleranceRangeLowValue   : 400,
                ToleranceRangeHighValue  : 999,
                DeviationRangeLowValue   : 0,
                DeviationRangeHighValue  : 9999
            },
        },

        SelectionVariant #SVForQuantity : {
    Parameters : [
        {
            $Type : 'UI.Parameter',
            PropertyName : DOCUOM,
            PropertyValue : 'L15'
        },
    ]
},
        KPI #KPIQuantity                   : {
            DataPoint        : ![@UI.DataPoint#GrossQuantiy],
            SelectionVariant : ![@UI.SelectionVariant#SVForQuantity],
            ID               : 'ActualCostByGLAccountNameKPI',
            Detail           : {
                $Type                      : 'UI.KPIDetailType',
                SemanticObject             : 'EPMProduct',
                Action                     : 'manage_stta',
                DefaultPresentationVariant : ![@UI.PresentationVariant#QtyByPstype]
            }
        },

        SelectionFields                    : [
            DOCQTY,
            PSTYPE,
            PDLVDF,
            DLVZN,
            ERNAM
        ],

        //Needed to use in visual filter definition
        PresentationVariant #DLVZN         : {Visualizations : ['@UI.Chart#DLVZN']},
        PresentationVariant #QtyByPstype   : {Visualizations : ['@UI.Chart#Unloadings']},
        PresentationVariant #QUANTITYBYDAY : {Visualizations : ['@UI.Chart#QUANTITYBYDAY']},
        //unnamed presentation variant for interactive chart
        PresentationVariant                : {Visualizations : ['@UI.Chart#MaterialMovement']},

        Chart #DLVZN                       : {
            $Type               : 'UI.ChartDefinitionType',
            ChartType           : #Donut,
            Measures            : ['DOCQTY'],
            MeasureAttributes   : [{
                $Type   : 'UI.ChartMeasureAttributeType',
                Measure : 'DOCQTY',
                Role    : #Axis1
            }],
            Dimensions          : ['DLVZN'],
            DimensionAttributes : [{
                $Type     : 'UI.ChartDimensionAttributeType',
                Dimension : 'DLVZN',
                Role      : #Category
            }]
        },

        Chart #QUANTITYBYDAY               : {
            $Type               : 'UI.ChartDefinitionType',
            ChartType           : #Line,
            Measures            : ['DOCQTY'],
            MeasureAttributes   : [{
                $Type   : 'UI.ChartMeasureAttributeType',
                Measure : 'DOCQTY',
                Role    : #Axis1
            }],
            Dimensions          : ['PDLVDF'],
            DimensionAttributes : [{
                $Type     : 'UI.ChartDimensionAttributeType',
                Dimension : 'PDLVDF',
                Role      : #Category
            }]
        },

        Chart #Unloadings                  : {
            ChartType           : #Bar,
            Dimensions          : [PSTYPE],
            DimensionAttributes : [{
                Dimension : PSTYPE,
                Role      : #Category
            }],
            Measures            : [DOCQTY],
            MeasureAttributes   : [{
                Measure : DOCQTY,
                Role    : #Axis1
            }]
        },

        //chart is used as interactive chart (not woking yet)
        Chart #MaterialMovement            : {
            ChartType           : #Column,
            Dimensions          : [MATNR],
            Measures            : [DummyForCounting],
            DimensionAttributes : [{
                Dimension : MATNR,
                Role      : #Category
            }],
            MeasureAttributes   : [{
                Measure : DummyForCounting,
                Role    : #Axis1
            }]
        },

        LineItem                           : [
            {Value : DOCNR},
            {
                $Type : 'UI.DataFieldWithUrl',
                Url   : 'forward.html',
                Value : DOCNR,
            },
            {Value : DOCQTY},
            {Value : PSTYPE},
            {Value : PDLVDF},
            {Value : DLVZN},
            {Value : ERNAM},
            {Value : GEOLAT},
            {Value : GEOLON},
            {Value : KUNWE},

        ],

        Facets                             : [{
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>Details}',
            Target : '@UI.FieldGroup#Details',
        }, ],
        FieldGroup #Details                : {Data : [
            {Value : DOCNR},
            {
                $Type          : 'UI.DataFieldForIntentBasedNavigation',
                SemanticObject : 'displayDocNr',
                Action         : 'display',
            },
            {Value : DOCQTY},
            {Value : PSTYPE},
            {Value : PDLVDF},
            {Value : DLVZN},
            {Value : ERNAM},
            {Value : GEOLAT},
            {Value : GEOLON},
            {Value : KUNWE},

        ]}
    }

) {
    DOCQTY           @(
        Analytics.Measure   : true,
        Aggregation.default : #SUM
    );

    DummyForCounting @(
        Analytics.Measure   : true,
        Aggregation.default : #SUM
    );

    DLVZN            @(Analytics.Dimension : true);
    PSTYPE           @(Analytics.Dimension : true);
    PDLVDF           @(Analytics.Dimension : true);
    MATNR            @(Analytics.Dimension : true);
};
