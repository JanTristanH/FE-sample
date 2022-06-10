using {db} from '../db/schema';

service KpiService {

    entity NAST     as projection on db.NAST;

    @readonly
    @cds.odata.valuelist
    entity DlvznVH  as
        select from NAST distinct {
            key DLVZN
        };

    @readonly
    @cds.odata.valuelist
    entity PstypeVH as
        select from NAST distinct {
            key PSTYPE
        };

}

annotate db.NAST with {
    @Common                          : {ValueList #DlvznVisualFilter : {
        $Type                        : 'Common.ValueListType',
        CollectionPath               : 'NAST',
        PresentationVariantQualifier : 'DLVZN',
        Parameters                   : [{
            $Type             : 'Common.ValueListParameterInOut',
            LocalDataProperty : 'DLVZN',
            ValueListProperty : 'DLVZN'
        }]
    }}
    DLVZN  @(ValueList.entity : 'DlvznVH');


    @Common.ValueListWithFixedValues : true
    @Common.ValueList                : {
        $Type          : 'Common.ValueListType',
        Label          : 'PSTYPE',
        CollectionPath : 'NAST',
        Parameters     : [{
            $Type             : 'Common.ValueListParameterInOut',
            LocalDataProperty : 'PSTYPE',
            ValueListProperty : 'PSTYPE'
        }]
    }
    PSTYPE @(ValueList.entity : 'PstypeVH');
};


annotate db.NAST with @(
    Aggregation.ApplySupported.PropertyRestrictions : true,
    Aggregation,
    UI                                              : {
        SelectionFields            : [
            DOCQTY,
            PSTYPE,
            PDLVDF,
            DLVZN,
            ERNAM
        ],
        LineItem                   : [
            {Value : DOCQTY},
            {Value : PSTYPE},
            {Value : PDLVDF},
            {Value : DLVZN},
            {Value : ERNAM},
        ],

        PresentationVariant #DLVZN : {Visualizations : ['@UI.Chart#DLVZN', ], },

        Chart #DLVZN               : {
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
    }
) {
    DOCQTY @(
        Analytics.Measure   : true,
        Aggregation.default : #SUM
    );
    DLVZN  @(Analytics.Dimension : true);
    PSTYPE @(Analytics.Dimension : true);
PDLVDF @(Analytics.Dimension : true)
};
