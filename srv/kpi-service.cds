using {db} from '../db/schema';

service KpiService {

    entity NAST as projection on db.NAST;
}

annotate db.NAST with @(
 UI: {
        SelectionFields: [DOCQTY,PSTYPE,PDLVDF,DLVZN,ERNAM],
        LineItem: [
            { Value: DOCQTY},
            { Value: PSTYPE},
            { Value: PDLVDF},
            { Value: DLVZN},
            { Value: ERNAM},
        ]
    }){
    DOCQTY @(
        Analytics.Measure   : true,
        Aggregation.default : #SUM
    )
};
