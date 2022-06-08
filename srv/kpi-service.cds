using { db } from '../db/schema';

service KpiService {

    entity NAST as projection on db.NAST;
}
