using {db} from '../db/schema';

service KpiService {

    entity NAST as projection on db.NAST;
}

annotate db.NAST with @(
    Aggregation.ApplySupported.PropertyRestrictions : true,
    Aggregation,
    UI                                              : {
        Chart           : {
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
        SelectionFields : [
            DOCQTY,
            PSTYPE,
            PDLVDF,
            DLVZN,
            ERNAM
        ],
        LineItem        : [
            {Value : DOCQTY},
            {Value : PSTYPE},
            {Value : PDLVDF},
            {Value : DLVZN},
            {Value : ERNAM},
        ]
    }
) {
    DOCQTY @(
        Analytics.Measure   : true,
        Aggregation.default : #SUM
    );
    DLVZN  @(Analytics.Dimension : true);
    PDLVDF @(Analytics.Dimension : true)
};
