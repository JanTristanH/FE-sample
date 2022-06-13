using {db} from '../db/schema';

service KpiService {

    entity NAST        as projection on db.NAST;

    @Communication.Contact #identify1 : {title : KUNWE,
    // org : CompanyName,
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
    email : [
        {
            type : [ #pref, #work ],
            address : KUNWE
        }
    ]
    }
    entity Customers   as
        select from NAST distinct {
            key KUNWE
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

}

annotate KpiService.Customers with @(


UI : {

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
//  TypeImageUrl : ImageUrl
}}

);


annotate KpiService.NAST with {
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

    @Common.IsCalendarDate
    PDLVDF
};


annotate KpiService.NAST with @(
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

        Chart #QUANTITYBYDAY       : {
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
        Facets                     : [{
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>Details}',
            Target : '@UI.FieldGroup#Details'
        }, ],
        FieldGroup #Details        : {Data : [
            {Value : DOCQTY},
            {Value : PSTYPE},
            {Value : PDLVDF},
            {Value : DLVZN},
            {Value : ERNAM},

        ]}
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
